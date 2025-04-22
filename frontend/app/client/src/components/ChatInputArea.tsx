import { useState, useRef } from "react";
import { Send, Mic, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import useAudioRecorder from "@/hooks/useAudioRecorder";
import { cn } from "@/lib/utils";

interface ChatInputAreaProps {
  onSendTextMessage: (text: string) => void;
  onSendAudioMessage: (audio: Blob) => void;
  disabled: boolean;
}

const ChatInputArea = ({ onSendTextMessage, onSendAudioMessage, disabled }: ChatInputAreaProps) => {
  const [message, setMessage] = useState("");
  const inputRef = useRef<HTMLInputElement>(null);
  
  const { 
    isRecording, 
    recordingTime, 
    startRecording, 
    stopRecording, 
    cancelRecording 
  } = useAudioRecorder(onSendAudioMessage);

  const handleSendMessage = () => {
    if (message.trim()) {
      onSendTextMessage(message);
      setMessage("");
      inputRef.current?.focus();
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  return (
    <div className="bg-background/60 glass-morphism px-4 py-4 border-t border-border/30 sticky bottom-0 z-10 shadow-sm">
      <div className="max-w-3xl mx-auto">
        {isRecording ? (
          <div className="px-4 py-3 bg-primary/10 rounded-full shadow-sm border border-primary/15">
            <div className="flex items-center justify-between">
              <div className="flex items-center">
                <div className="w-2 h-2 bg-red-500 rounded-full mr-2 animate-pulse"></div>
                <span className="text-xs font-medium text-foreground">{recordingTime}</span>
              </div>
              <div className="flex space-x-1.5">
                <Button 
                  variant="ghost" 
                  size="sm" 
                  onClick={cancelRecording} 
                  className="h-7 w-7 rounded-full p-0 text-muted-foreground hover:text-destructive hover:bg-destructive/10"
                >
                  <X className="h-3.5 w-3.5" />
                </Button>
                <Button 
                  variant="ghost" 
                  size="sm" 
                  onClick={stopRecording} 
                  className="h-7 w-7 rounded-full p-0 text-primary hover:bg-primary/10"
                >
                  <Send className="h-3.5 w-3.5" />
                </Button>
              </div>
            </div>
          </div>
        ) : (
          <div className="flex items-center space-x-2">
            <div className="relative flex-1">
              <Input
                ref={inputRef}
                type="text"
                placeholder="Escribe un mensaje..."
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                onKeyPress={handleKeyPress}
                disabled={disabled}
                className={cn(
                  "w-full bg-muted/30 border border-border/30 px-4 py-2 h-11 rounded-full shadow-sm",
                  "text-sm focus-visible:ring-1 focus-visible:ring-primary/50 focus-visible:ring-offset-0 focus-visible:border-primary/30"
                )}
              />
            </div>
            <Button 
              type="button"
              onClick={handleSendMessage}
              disabled={!message.trim() || disabled}
              size="icon"
              className={cn(
                "rounded-full h-11 w-11 bg-primary text-white",
                "shadow-sm transition-all duration-200 border border-primary/40",
                (!message.trim() || disabled) ? "opacity-50" : "hover:bg-primary/90 hover:shadow-md hover:border-primary/60"
              )}
            >
              <Send className="h-4 w-4" />
            </Button>
            <Button 
              type="button"
              onClick={startRecording}
              disabled={disabled}
              size="icon"
              className={cn(
                "rounded-full h-11 w-11 bg-primary/15 text-primary",
                "shadow-sm transition-all duration-200 border border-primary/20",
                disabled ? "opacity-50" : "hover:bg-primary/20 hover:shadow-md hover:border-primary/30"
              )}
            >
              <Mic className="h-4 w-4" />
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

export default ChatInputArea;
