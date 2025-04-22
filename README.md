# Recruiter Assistant Project

## Structure

```
├── backend
│   ├── app
│   │   ├── __init__.py
│   │   ├── api
│   │   │   ├── __init__.py
│   │   │   ├── endpoints
│   │   │   │   ├── books.py
│   │   │   │   ├── hackernews.py
│   │   │   │   └── init.py
│   │   │   └── routes.py
│   │   ├── main.py
│   │   ├── models
│   │   │   ├── __init__.py
│   │   │   ├── book.py
│   │   │   └── search_request.py
│   │   ├── scrappers
│   │   │   ├── __init__.py
│   │   │   ├── scrape_books.py
│   │   │   └── scrape_hn.py
│   │   ├── services
│   │   │   ├── __init__.py
│   │   │   └── redis_client.py
│   │   └── tests
│   │       ├── __init__.py
│   │       └── test_books.py
│   ├── Dockerfile
│   └── pyproject.toml
├── frontend
│   ├── Dockerfile
│   ├── app
│   │   ├── client
│   │   │   ├── index.html
│   │   │   └── src
│   │   │       ├── App.tsx
│   │   │       ├── components
│   │   │       │   ├── AudioMessage.tsx
│   │   │       │   ├── ChatHeader.tsx
│   │   │       │   ├── ChatInputArea.tsx
│   │   │       │   ├── ChatMessages.tsx
│   │   │       │   ├── TypingIndicator.tsx
│   │   │       │   └── ui
│   │   │       │       ├── accordion.tsx
│   │   │       │       ├── alert-dialog.tsx
│   │   │       │       ├── alert.tsx
│   │   │       │       ├── aspect-ratio.tsx
│   │   │       │       ├── avatar.tsx
│   │   │       │       ├── badge.tsx
│   │   │       │       ├── breadcrumb.tsx
│   │   │       │       ├── button.tsx
│   │   │       │       ├── calendar.tsx
│   │   │       │       ├── card.tsx
│   │   │       │       ├── carousel.tsx
│   │   │       │       ├── chart.tsx
│   │   │       │       ├── checkbox.tsx
│   │   │       │       ├── collapsible.tsx
│   │   │       │       ├── command.tsx
│   │   │       │       ├── context-menu.tsx
│   │   │       │       ├── dialog.tsx
│   │   │       │       ├── drawer.tsx
│   │   │       │       ├── dropdown-menu.tsx
│   │   │       │       ├── form.tsx
│   │   │       │       ├── hover-card.tsx
│   │   │       │       ├── input-otp.tsx
│   │   │       │       ├── input.tsx
│   │   │       │       ├── label.tsx
│   │   │       │       ├── menubar.tsx
│   │   │       │       ├── navigation-menu.tsx
│   │   │       │       ├── pagination.tsx
│   │   │       │       ├── popover.tsx
│   │   │       │       ├── progress.tsx
│   │   │       │       ├── radio-group.tsx
│   │   │       │       ├── resizable.tsx
│   │   │       │       ├── scroll-area.tsx
│   │   │       │       ├── select.tsx
│   │   │       │       ├── separator.tsx
│   │   │       │       ├── sheet.tsx
│   │   │       │       ├── sidebar.tsx
│   │   │       │       ├── skeleton.tsx
│   │   │       │       ├── slider.tsx
│   │   │       │       ├── switch.tsx
│   │   │       │       ├── table.tsx
│   │   │       │       ├── tabs.tsx
│   │   │       │       ├── textarea.tsx
│   │   │       │       ├── toast.tsx
│   │   │       │       ├── toaster.tsx
│   │   │       │       ├── toggle-group.tsx
│   │   │       │       ├── toggle.tsx
│   │   │       │       └── tooltip.tsx
│   │   │       ├── hooks
│   │   │       │   ├── use-mobile.tsx
│   │   │       │   ├── use-toast.ts
│   │   │       │   └── useAudioRecorder.ts
│   │   │       ├── index.css
│   │   │       ├── lib
│   │   │       │   ├── n8nApi.ts
│   │   │       │   ├── queryClient.ts
│   │   │       │   ├── types.ts
│   │   │       │   └── utils.ts
│   │   │       ├── main.tsx
│   │   │       └── pages
│   │   │           ├── ChatPage.tsx
│   │   │           └── not-found.tsx
│   │   ├── components.json
│   │   ├── drizzle.config.ts
│   │   ├── generated-icon.png
│   │   ├── package-lock.json
│   │   ├── package.json
│   │   ├── postcss.config.js
│   │   ├── server
│   │   │   ├── index.ts
│   │   │   ├── routes.ts
│   │   │   ├── storage.ts
│   │   │   └── vite.ts
│   │   ├── shared
│   │   │   └── schema.ts
│   │   ├── tailwind.config.ts
│   │   ├── theme.json
│   │   ├── tsconfig.json
│   │   └── vite.config.ts
│   └── nginx
│       └── default.conf
├── workflows
│   ├── Dockerfile
│   ├── entrypoint.sh
│   ├── main_workflow.json
│   ├── n8n_credentials.json
│   └── speech-to-text-with-assembly.json
├── docker-compose.yml
├── .env
├── README.md
```

## Usage

- `docker-compose up --build` to start all services.
- Access FastAPI at [http://localhost:18000/docs](http://localhost:18000/docs)
- Access frontend at [http://localhost:8080](http://localhost:3000)
- Access n8n at [http://localhost:5678](http://localhost:5678)

