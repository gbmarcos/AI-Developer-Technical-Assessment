import { useState, useRef, useEffect } from "react";
import { useToast } from "@/hooks/use-toast";

const useAudioRecorder = (onAudioRecorded: (audio: Blob) => void) => {
  const [isRecording, setIsRecording] = useState(false);
  const [recordingTime, setRecordingTime] = useState("00:00");
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const audioChunksRef = useRef<Blob[]>([]);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  const startTimeRef = useRef<number>(0);
  const wasCancelledRef = useRef<boolean>(false);
  const { toast } = useToast();

  useEffect(() => {
    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current);
      }
      if (mediaRecorderRef.current && mediaRecorderRef.current.state === "recording") {
        wasCancelledRef.current = true; // Marcar como cancelado al desmontar
        mediaRecorderRef.current.stop();
      }
    };
  }, []);

  const updateRecordingTime = () => {
    const elapsed = Date.now() - startTimeRef.current;
    const seconds = Math.floor((elapsed / 1000) % 60);
    const minutes = Math.floor((elapsed / (1000 * 60)) % 60);
    setRecordingTime(`${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`);
  };

  const startRecording = async () => {
    audioChunksRef.current = [];
    wasCancelledRef.current = false; // Resetear la bandera de cancelación
    
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      mediaRecorderRef.current = new MediaRecorder(stream);
      
      mediaRecorderRef.current.addEventListener("dataavailable", (event) => {
        if (event.data.size > 0) {
          audioChunksRef.current.push(event.data);
        }
      });

      mediaRecorderRef.current.addEventListener("stop", () => {
        // Stop all tracks from the stream
        stream.getTracks().forEach(track => track.stop());
        
        // Solo procesar y enviar el audio si NO fue cancelado
        if (!wasCancelledRef.current && audioChunksRef.current.length > 0) {
          const audioBlob = new Blob(audioChunksRef.current, { type: "audio/wav" });
          onAudioRecorded(audioBlob);
        }
      });

      mediaRecorderRef.current.start();
      setIsRecording(true);
      
      // Start the timer
      startTimeRef.current = Date.now();
      setRecordingTime("00:00");
      timerRef.current = setInterval(updateRecordingTime, 1000);
    } catch (error) {
      console.error("Error starting recording:", error);
      toast({
        title: "Error",
        description: "No se pudo iniciar la grabación. Verifica los permisos del micrófono.",
        variant: "destructive"
      });
    }
  };

  const stopRecording = () => {
    if (mediaRecorderRef.current && mediaRecorderRef.current.state === "recording") {
      // No cancelado, proceder normalmente
      wasCancelledRef.current = false;
      mediaRecorderRef.current.stop();
      setIsRecording(false);
      
      if (timerRef.current) {
        clearInterval(timerRef.current);
        timerRef.current = null;
      }
    }
  };

  const cancelRecording = () => {
    if (mediaRecorderRef.current && mediaRecorderRef.current.state === "recording") {
      // Marcar como cancelado antes de detener
      wasCancelledRef.current = true;
      mediaRecorderRef.current.stop();
      audioChunksRef.current = []; // Limpiar los chunks de audio
      setIsRecording(false);
      
      if (timerRef.current) {
        clearInterval(timerRef.current);
        timerRef.current = null;
      }
    }
  };

  return {
    isRecording,
    recordingTime,
    startRecording,
    stopRecording,
    cancelRecording
  };
};

export default useAudioRecorder;
