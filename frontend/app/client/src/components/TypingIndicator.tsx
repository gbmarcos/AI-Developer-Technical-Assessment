import { Bot } from "lucide-react";

const TypingIndicator = () => {
  return (
    <div className="flex items-start max-w-[85%]">
      <div className="w-8 h-8 rounded-full bg-primary/20 flex-shrink-0 flex items-center justify-center mr-3 mt-1 border border-primary/15 shadow-sm">
        <Bot className="h-3.5 w-3.5 text-primary" />
      </div>
      <div className="bg-muted/40 border border-muted/60 px-4 py-3 rounded-2xl rounded-tl-sm shadow-sm">
        <div className="flex space-x-2 h-5 items-center">
          <span className="w-1.5 h-1.5 bg-primary/60 rounded-full animate-pulse" style={{ animationDelay: "0ms" }}></span>
          <span className="w-1.5 h-1.5 bg-primary/60 rounded-full animate-pulse" style={{ animationDelay: "300ms" }}></span>
          <span className="w-1.5 h-1.5 bg-primary/60 rounded-full animate-pulse" style={{ animationDelay: "600ms" }}></span>
        </div>
      </div>
    </div>
  );
};

export default TypingIndicator;
