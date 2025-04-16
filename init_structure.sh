#!/bin/bash

# Crear carpetas del proyecto
mkdir -p backend/app/{api,endpoints,models,schemas,services,utils,tests,core}
mkdir -p frontend/src/components
mkdir -p workflows

# Archivos __init__.py para módulos Python
touch backend/app/__init__.py
for folder in api endpoints models schemas services utils tests core; do
  touch backend/app/$folder/__init__.py
done

# Crear backend/app/main.py
cat <<EOL > backend/app/main.py
from fastapi import FastAPI
from app.api.routes import router as api_router

app = FastAPI(
    title="Book & Hacker News API",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

app.include_router(api_router)
EOL

# Crear backend/app/api/routes.py
mkdir -p backend/app/api
cat <<EOL > backend/app/api/routes.py
from fastapi import APIRouter
from app.api.endpoints import books, hackernews, init

router = APIRouter()
router.include_router(init.router, prefix="/init", tags=["Init"])
router.include_router(books.router, prefix="/books", tags=["Books"])
router.include_router(hackernews.router, prefix="/headlines", tags=["HackerNews"])
EOL

# Crear endpoints básicos
mkdir -p backend/app/api/endpoints

cat <<EOL > backend/app/api/endpoints/init.py
from fastapi import APIRouter

router = APIRouter()

@router.post("/")
async def initialize_scraper():
    # TODO: Trigger book scraping logic
    return {"message": "Scraping started"}
EOL

cat <<EOL > backend/app/api/endpoints/books.py
from fastapi import APIRouter, Query

router = APIRouter()

@router.get("/search")
async def search_books(title: str = Query(None), category: str = Query(None)):
    return {"message": f"Searching books with title={title}, category={category}"}

@router.get("/")
async def get_books(category: str = None):
    return {"message": f"Retrieving books in category: {category}"}
EOL

cat <<EOL > backend/app/api/endpoints/hackernews.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_headlines():
    return {"headlines": []}
EOL

# Crear backend/Dockerfile
cat <<EOL > backend/Dockerfile
FROM python:3.11

WORKDIR /app

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false && poetry install --no-root

COPY ./app ./app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "7013"]
EOL

# Crear backend/pyproject.toml
cat <<EOL > backend/pyproject.toml
[tool.poetry]
name = "backend"
version = "0.1.0"
description = "FastAPI backend with Redis and Selenium"
authors = ["Marcos"]

[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.110.0"
uvicorn = { extras = ["standard"], version = "^0.27.0" }
redis = "^5.0.0"
selenium = "^4.18.0"
python-dotenv = "^1.0.1"
pydantic = "^2.5.0"
httpx = "^0.27.0"

[tool.poetry.dev-dependencies]
pytest = "^8.0.0"
pytest-asyncio = "^0.23.2"
EOL

# Crear frontend/Dockerfile
cat <<EOL > frontend/Dockerfile
FROM node:18

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

CMD ["npm", "run", "dev"]
EOL

# Crear frontend/src/App.js
cat <<EOL > frontend/src/App.js
import React from "react";

function App() {
  return (
    <div>
      <h1>Frontend Running</h1>
    </div>
  );
}

export default App;
EOL

# Crear workflows/n8n_workflow.json
cat <<EOL > workflows/n8n_workflow.json
{
  "name": "Example Workflow",
  "nodes": [],
  "connections": {}
}
EOL

# Crear archivo docker-compose.yml
cat <<EOL > docker-compose.yml
services:
  redis:
    image: redis:6.2
    container_name: recruiter-dev-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  selenium:
    image: selenium/standalone-chrome:latest
    container_name: recruiter-dev-selenium
    ports:
      - "14440:4444"
    environment:
      - SE_NODE_ENABLE_MANAGED_DOWNLOADS=true
      - SE_OPTS=--enable-managed-downloads true
      - SE_LOG_LEVEL=INFO
    restart: always
    shm_size: 4gb

  backend:
    build:
      context: ./backend
    container_name: recruiter-dev-backend
    command: poetry run uvicorn app.main:app --host 0.0.0.0 --port 7013
    ports:
      - "18000:7013"
    volumes:
      - ./backend:/app
    depends_on:
      - redis
    environment:
      - REDIS_HOST=recruiter-dev-redis
      - REDIS_PORT=6379
      - REMOTE_DRIVER_URL=recruiter-dev-selenium

  frontend:
    build:
      context: ./frontend
    container_name: recruiter-dev-frontend
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
    depends_on:
      - n8n

  n8n:
    image: n8nio/n8n
    container_name: recruiter-dev-n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=admin
      - N8N_HOST=n8n
      - N8N_PORT=5678
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - N8N_SECURE_COOKIE=false
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      - redis

volumes:
  redis_data:
  n8n_data:
EOL

# Crear README.md
cat <<EOL > README.md
# Recruiter Assistant Project

## Structure

\`\`\`
├── backend/
│   ├── app/
│   │   ├── api/
│   │   ├── endpoints/
│   │   ├── models/
│   │   ├── schemas/
│   │   ├── services/
│   │   ├── utils/
│   │   ├── tests/
│   │   ├── core/
│   │   └── main.py
│   ├── poetry.lock
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   └── App.js
│   └── Dockerfile
├── workflows/
│   └── n8n_workflow.json
├── docker-compose.yml
└── README.md
\`\`\`

## Usage

- \`docker-compose up --build\` to start all services.
- Access FastAPI at [http://localhost:18000/docs](http://localhost:18000/docs)
- Access frontend at [http://localhost:3000](http://localhost:3000)
- Access n8n at [http://localhost:5678](http://localhost:5678)

EOL

echo "✅ Estructura completa del proyecto generada."
