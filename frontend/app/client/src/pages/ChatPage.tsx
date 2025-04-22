import { useState, useEffect, useRef } from "react";
import ChatHeader from "@/components/ChatHeader";
import ChatMessages from "@/components/ChatMessages";
import ChatInputArea from "@/components/ChatInputArea";
import { Message } from "@/lib/types";
import { sendTextMessage, sendAudioMessage } from "@/lib/n8nApi";
import { useToast } from "@/hooks/use-toast";

const ChatPage = () => {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: 1,
      content: "Hola, soy tu asistente virtual. ¿En qué puedo ayudarte hoy? Puedes escribirme o enviarme un mensaje de voz.",
      sender: "bot",
      timestamp: new Date().toISOString(),
      type: "text"
    }
  ]);
  const [isProcessing, setIsProcessing] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement | null>(null);
  const { toast } = useToast();

  useEffect(() => {
    scrollToBottom();
  }, [messages, isProcessing]);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  const handleSendTextMessage = async (text: string) => {
    if (!text.trim()) return;

    // Add user message to chat
    const userMessage: Message = {
      id: Date.now(),
      content: text,
      sender: "user",
      timestamp: new Date().toISOString(),
      type: "text"
    };

    setMessages(prev => [...prev, userMessage]);
    setIsProcessing(true);

    try {
      // Send message to n8n webhook
      const response = await sendTextMessage(text);
      
      // Add bot response to chat
      if (response) {
        const botMessage: Message = {
          id: Date.now() + 1,
          content: response,
          sender: "bot",
          timestamp: new Date().toISOString(),
          type: "text"
        };
        
        setMessages(prev => [...prev, botMessage]);
      }
    } catch (error) {
      toast({
        title: "Error al enviar mensaje",
        description: "No se pudo enviar el mensaje. Por favor, intenta de nuevo.",
        variant: "destructive"
      });
      console.error("Error sending message:", error);
    } finally {
      setIsProcessing(false);
    }
  };

  const handleSendAudioMessage = async (audioBlob: Blob) => {
    // Create a temporary URL for the audio blob
    const audioUrl = URL.createObjectURL(audioBlob);
    
    // Add user audio message to chat
    const userMessage: Message = {
      id: Date.now(),
      content: "Mensaje de audio",
      audioUrl,
      sender: "user",
      timestamp: new Date().toISOString(),
      type: "audio"
    };

    setMessages(prev => [...prev, userMessage]);
    setIsProcessing(true);

    try {
      // Send audio to n8n webhook
      const response = await sendAudioMessage(audioBlob);
      
      // Add bot response to chat
      if (response) {
        const botMessage: Message = {
          id: Date.now() + 1,
          content: response,
          sender: "bot",
          timestamp: new Date().toISOString(),
          type: "text"
        };
        
        setMessages(prev => [...prev, botMessage]);
      }
    } catch (error) {
      toast({
        title: "Error al enviar audio",
        description: "No se pudo enviar el audio. Por favor, intenta de nuevo.",
        variant: "destructive"
      });
      console.error("Error sending audio:", error);
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="h-screen flex flex-col overflow-hidden bg-background text-foreground relative">
      <div className="absolute inset-0 chat-window pointer-events-none z-0"></div>
      <ChatHeader botName="Asistente Virtual" status="En línea" />
      <ChatMessages 
        messages={messages} 
        isProcessing={isProcessing} 
        messagesEndRef={messagesEndRef} 
      />
      <ChatInputArea 
        onSendTextMessage={handleSendTextMessage} 
        onSendAudioMessage={handleSendAudioMessage} 
        disabled={isProcessing} 
      />
    </div>
  );
};

export default ChatPage;
