#!/bin/sh

# Esperar hasta que ngrok esté listo
while ! curl -s $NGROK_API_URL > /dev/null; do
  echo "Esperando a ngrok..."
  sleep 2
done

sleep 2

# Extraer URL pública HTTPS
PUBLIC_URL=$(curl -s $NGROK_API_URL | jq -r '.tunnels[] | select(.proto == "https") | .public_url')

# Construir aplicación Flutter

echo "Construyendo con WEBHOOK_URL: ${PUBLIC_URL}/webhook/ask"
cd app && flutter build web \
  --target lib/main_production.dart \
  --dart-define=WEBHOOK_URL=${PUBLIC_URL}/webhook/ask \
  --release


# Define the port
PORT=9000

# Check if the port is in use and release it if necessary.
if netstat -tuln | grep ":$PORT " > /dev/null; then
  echo "Liberando puerto $PORT..."
  # Obtener PID usando ss (alternativa moderna a netstat)
  PID=$(ss -tulpn | grep ":$PORT" | awk '{print $6}' | cut -d= -f2 | cut -d, -f1)
  if [ ! -z "$PID" ]; then
    kill -9 $PID
  fi
fi

# Switch to the web construction directory
cd build/web/

# Start the web server on the specified port
echo "Starting the server on port $PORT..."
python3 -m http.server $PORT --bind 0.0.0.0

