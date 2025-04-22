import type { Express } from "express";
import { createServer, type Server } from "http";
import { storage } from "./storage";
import multer from "multer";
import axios from "axios";
import fs from "fs";
import path from "path";
import { insertMessageSchema } from "@shared/schema";

// Setup multer for handling file uploads
const upload = multer({ 
  storage: multer.diskStorage({
    destination: (req, file, cb) => {
      const uploadsDir = path.join(import.meta.dirname, '../uploads');
      // Create directory if it doesn't exist
      if (!fs.existsSync(uploadsDir)){
        fs.mkdirSync(uploadsDir, { recursive: true });
      }
      cb(null, uploadsDir);
    },
    filename: (req, file, cb) => {
      // Create unique filename with timestamp
      const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
      cb(null, 'audio-' + uniqueSuffix + '.wav');
    }
  })
});

export async function registerRoutes(app: Express): Promise<Server> {
  // Default webhook URL (can be overridden by environment variable)
  const defaultWebhookUrl = process.env.N8N_WEBHOOK_URL || "https://example.com/webhook";
  
  // Store webhook configuration in memory
  let webhookConfig = {
    url: defaultWebhookUrl,
    active: true
  };

  // Get webhook configuration
  app.get('/api/webhook/config', (req, res) => {
    res.json(webhookConfig);
  });

  // Update webhook configuration
  app.post('/api/webhook/config', (req, res) => {
    const { url, active } = req.body;
    if (url) {
      webhookConfig = { url, active: active !== undefined ? active : true };
      res.json({ success: true, config: webhookConfig });
    } else {
      res.status(400).json({ success: false, message: 'URL is required' });
    }
  });

  // Send text message to n8n webhook
  app.post('/api/webhook/text', async (req, res) => {
    try {
      const { text } = req.body;
      
      if (!text) {
        return res.status(400).json({ success: false, message: 'Text is required' });
      }

      if (!webhookConfig.active) {
        return res.status(400).json({ success: false, message: 'Webhook is not active' });
      }

      // Log incoming text message
      console.log(`Sending text message to webhook: ${text}`);

      // Send text to n8n webhook
      const response = await axios.post(webhookConfig.url, {
        type: 'text',
        content: text
      });

      // Store message in database
      const userMessage = insertMessageSchema.parse({
        content: text,
        type: 'text',
        sender: 'user'
      });
      
      await storage.createMessage(userMessage);

      // Store bot response in database
      if (response.data && response.data.response) {
        const botMessage = insertMessageSchema.parse({
          content: response.data.response,
          type: 'text',
          sender: 'bot'
        });
        
        await storage.createMessage(botMessage);
      }

      // Return bot response or a default message
      res.json({ 
        success: true, 
        response: response.data?.response || "Mensaje recibido. El webhook no ha devuelto una respuesta."
      });
    } catch (error: any) {
      console.error('Error sending text to webhook:', error.message);
      res.status(500).json({ 
        success: false, 
        message: 'Error sending text to webhook',
        response: "Lo siento, ha ocurrido un error al procesar tu mensaje."
      });
    }
  });

  // Send audio message to n8n webhook
  app.post('/api/webhook/audio', upload.single('audio'), async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({ success: false, message: 'Audio file is required' });
      }

      if (!webhookConfig.active) {
        return res.status(400).json({ success: false, message: 'Webhook is not active' });
      }

      const audioFilePath = req.file.path;
      
      // Log the incoming audio file
      console.log(`Received audio file: ${audioFilePath}`);

      // Send audio file to n8n webhook using FormData
      const formData = new FormData();
      const fileStream = fs.createReadStream(audioFilePath);
      formData.append('type', 'audio');
      formData.append('audio', fileStream);

      const response = await axios.post(webhookConfig.url, formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });

      // Store message in database
      const userMessage = insertMessageSchema.parse({
        content: 'Mensaje de audio',
        type: 'audio',
        sender: 'user',
        audioUrl: audioFilePath
      });
      
      await storage.createMessage(userMessage);

      // Store bot response in database
      if (response.data && response.data.response) {
        const botMessage = insertMessageSchema.parse({
          content: response.data.response,
          type: 'text',
          sender: 'bot'
        });
        
        await storage.createMessage(botMessage);
      }

      // Return bot response or a default message
      res.json({ 
        success: true, 
        response: response.data?.response || "Audio recibido. El webhook no ha devuelto una respuesta."
      });
    } catch (error: any) {
      console.error('Error sending audio to webhook:', error.message);
      res.status(500).json({ 
        success: false, 
        message: 'Error sending audio to webhook',
        response: "Lo siento, ha ocurrido un error al procesar tu mensaje de audio."
      });
    }
  });

  const httpServer = createServer(app);
  return httpServer;
}
