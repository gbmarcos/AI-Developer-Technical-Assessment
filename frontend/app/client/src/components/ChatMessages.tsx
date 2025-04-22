import { RefObject, useState } from "react";
import { Message } from "@/lib/types";
import { ScrollArea } from "@/components/ui/scroll-area";
import AudioMessage from "@/components/AudioMessage";
import TypingIndicator from "@/components/TypingIndicator";
import { Bot, User, Copy, Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import { cn } from "@/lib/utils";
import { useToast } from "@/hooks/use-toast";
import ReactMarkdown from "react-markdown";

interface ChatMessagesProps {
  messages: Message[];
  isProcessing: boolean;
  messagesEndRef: RefObject<HTMLDivElement>;
}

const ChatMessages = ({ messages, isProcessing, messagesEndRef }: ChatMessagesProps) => {
  const [copiedMessageId, setCopiedMessageId] = useState<number | null>(null);
  const { toast } = useToast();
  
  const copyToClipboard = (text: string, messageId: number) => {
    navigator.clipboard.writeText(text)
      .then(() => {
        setCopiedMessageId(messageId);
        
        toast({
          title: "Copiado al portapapeles",
          description: "El mensaje ha sido copiado correctamente",
          duration: 2000
        });
        
        // Reset the copied status after 2 seconds
        setTimeout(() => {
          setCopiedMessageId(null);
        }, 2000);
      })
      .catch(err => {
        console.error('Error al copiar texto: ', err);
        toast({
          title: "Error",
          description: "No se pudo copiar el mensaje",
          variant: "destructive"
        });
      });
  };
  
  return (
    <ScrollArea className="flex-1 bg-background/95 px-4 py-6">
      <div className="flex flex-col space-y-6 max-w-3xl mx-auto">
        {messages.map((message) => (
          <div 
            key={message.id} 
            className={`flex items-start group ${message.sender === 'user' ? 'justify-end' : ''}`}
          >
            {message.sender === 'bot' && (
              <div className="w-8 h-8 rounded-full bg-primary/20 flex-shrink-0 flex items-center justify-center mr-3 mt-1 border border-primary/15 shadow-sm">
                <Bot className="h-3.5 w-3.5 text-primary" />
              </div>
            )}
            
            <div 
              className={`message-bubble ${
                message.sender === 'user' 
                  ? 'bg-primary/15 border border-primary/10 rounded-2xl rounded-tr-sm text-foreground max-w-[85%] shadow-sm' 
                  : 'bg-muted/40 border border-muted/60 rounded-2xl rounded-tl-sm text-foreground max-w-[85%] shadow-sm'
              } px-4 py-3 relative group`}
            >
              {message.type === 'text' ? (
                message.sender === 'bot' ? (
                  <div className="markdown-content text-sm leading-relaxed">
                    <ReactMarkdown>{message.content}</ReactMarkdown>
                  </div>
                ) : (
                  <p className="text-sm leading-relaxed">{message.content}</p>
                )
              ) : (
                <AudioMessage audioUrl={message.audioUrl || ''} />
              )}
              
              <div className="flex justify-between items-center mt-2">
                <div className="flex items-center">
                  {message.sender === 'bot' && message.type === 'text' && (
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => copyToClipboard(message.content, message.id)}
                      className={cn(
                        "h-6 w-6 p-0 rounded-full transition-opacity",
                        "opacity-0 group-hover:opacity-100 focus:opacity-100",
                        "text-muted-foreground/60 hover:text-primary hover:bg-primary/10"
                      )}
                      title="Copiar al portapapeles"
                    >
                      {copiedMessageId === message.id ? (
                        <Check className="h-3 w-3" />
                      ) : (
                        <Copy className="h-3 w-3" />
                      )}
                    </Button>
                  )}
                </div>
                <div className="text-[10px] text-muted-foreground/50">
                  {new Date(message.timestamp).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}
                </div>
              </div>
            </div>
            
            {message.sender === 'user' && (
              <div className="w-8 h-8 rounded-full bg-primary/20 flex-shrink-0 flex items-center justify-center ml-3 mt-1 border border-primary/15 shadow-sm">
                <User className="h-3.5 w-3.5 text-primary" />
              </div>
            )}
          </div>
        ))}
        
        {isProcessing && <TypingIndicator />}
        <div ref={messagesEndRef} className="h-6" />
      </div>
    </ScrollArea>
  );
};

export default ChatMessages;