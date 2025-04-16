# Recruiter Assistant Project

## Structure

```
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
```

## Usage

- `docker-compose up --build` to start all services.
- Access FastAPI at [http://localhost:18000/docs](http://localhost:18000/docs)
- Access frontend at [http://localhost:3000](http://localhost:3000)
- Access n8n at [http://localhost:5678](http://localhost:5678)

