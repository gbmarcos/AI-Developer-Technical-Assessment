# backend/Dockerfile

FROM python:3.11-slim

WORKDIR /app

# Instalamos dependencias necesarias del sistema para Chrome + Selenium
RUN apt-get update && apt-get install -y \
    wget curl gnupg2 unzip fonts-liberation \
    libnss3 libxss1 libasound2 libatk1.0-0 libatk-bridge2.0-0 \
    libc6 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxrandr2 \
    libgbm1 libgtk-3-0 libglib2.0-0 libxext6 libxi6 libsm6 libxrender1 ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Instalamos Google Chrome estable
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Actualizamos pip y luego instalamos poetry
RUN pip install --upgrade pip && pip install poetry

# Copiamos solo los archivos de dependencias primero (para aprovechar cache)
COPY pyproject.toml poetry.lock* ./

# Instalamos las dependencias del proyecto
RUN poetry config virtualenvs.create false \
  && poetry install --no-root --no-interaction --no-ansi

# Copiamos el resto del código
COPY ./app ./app

# Comando para iniciar FastAPI
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "7013"]
