export interface Message {
  id: number;
  content: string;
  sender: 'user' | 'bot';
  timestamp: string;
  type: 'text' | 'audio';
  audioUrl?: string;
}

export interface WebhookConfig {
  url: string;
  active: boolean;
}
