# Recruiter Assistant Project

## Structure

```
├── backend
│   └── app
│       ├── api
│       │   └── endpoints
│       ├── models
│       ├── scrappers
│       ├── services
│       └── tests
├── frontend
│   └── app
│       ├── lib
│       │   ├── app
│       │   │   ├── models
│       │   │   └── view
│       │   ├── chatbot
│       │   ├── l10n
│       │   │   └── arb
│       │   └── services
│       └── web
│           └── icons
├── workflows
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── main_workflow.json
│   ├── n8n_credentials.json
│   └── speech-to-text-with-assembly.json
├── docker-compose.yml
└── README.md
```

## Usage

- `docker-compose up --build` to start all services.
- Access FastAPI at [http://localhost:18000/docs](http://localhost:18000/docs)
- Access frontend at [http://localhost:8080](http://localhost:3000)
- Access n8n at [http://localhost:5678](http://localhost:5678)

