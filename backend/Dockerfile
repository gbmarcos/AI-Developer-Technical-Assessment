# backend/Dockerfile

FROM python:3.11

WORKDIR /app

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
