import { Bot } from "lucide-react";

interface ChatHeaderProps {
  botName: string;
  status: string;
}

const ChatHeader = ({ botName, status }: ChatHeaderProps) => {
  return (
    <header className="bg-background/60 glass-morphism py-3 px-6 flex items-center justify-between border-b border-border/30 sticky top-0 z-10 shadow-sm">
      <div className="flex items-center">
        <div className="w-9 h-9 rounded-full bg-primary/15 flex items-center justify-center shadow-sm">
          <Bot className="h-4 w-4 text-primary" />
        </div>
        <div className="ml-3.5">
          <h1 className="text-base font-medium text-foreground tracking-tight">{botName}</h1>
          <div className="flex items-center text-xs text-muted-foreground mt-0.5">
            <span className="inline-block w-1.5 h-1.5 rounded-full bg-green-500 mr-1.5 animate-pulse"></span>
            <span>{status}</span>
          </div>
        </div>
      </div>
    </header>
  );
};

export default ChatHeader;
