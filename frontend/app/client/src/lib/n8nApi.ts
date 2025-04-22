import { apiRequest } from "./queryClient";

// Default n8n webhook URL from environment variables
const DEFAULT_WEBHOOK_URL = "n8n/webhook/ask";

// Send text message to n8n webhook (application/json)
export async function sendTextMessage(text: string): Promise<string> {
  try {
    const response = await fetch(DEFAULT_WEBHOOK_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ text })
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    return await response.text();
  } catch (error) {
    console.error("Error sending text message:", error);
    throw new Error("Failed to send text message");
  }
}

// Send audio message to n8n webhook (multipart/form-data)
export async function sendAudioMessage(audioBlob: Blob): Promise<string> {
  try {
    const formData = new FormData();
    formData.append("audio", audioBlob, "audio.wav");

    const response = await fetch(DEFAULT_WEBHOOK_URL, {
      method: "POST",
      body: formData
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    return await response.text();
  } catch (error) {
    console.error("Error sending audio message:", error);
    throw new Error("Failed to send audio message");
  }
}
// Get webhook configuration
export async function getWebhookConfig(): Promise<{url: string, active: boolean}> {
  try {
    const response = await apiRequest("GET", "/api/webhook/config", undefined);
    return await response.json();
  } catch (error) {
    console.error("Error getting webhook config:", error);
    return { url: DEFAULT_WEBHOOK_URL, active: true };
  }
}

// Update webhook configuration
export async function updateWebhookConfig(config: {url: string, active: boolean}): Promise<void> {
  try {
    await apiRequest("POST", "/api/webhook/config", config);
  } catch (error) {
    console.error("Error updating webhook config:", error);
    throw error;
  }
}
