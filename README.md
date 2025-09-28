# CodementorX 🤖

A professional full-stack chatbot platform showcasing modern web development practices with React, Django, FastAPI, and PostgreSQL.

## 🖼️ Screenshoots

<img width="1919" height="941" alt="Screenshot 2025-09-05 161735" src="https://github.com/user-attachments/assets/c4209030-9049-489a-bfda-319a7f0f9b49" />
<img width="1879" height="940" alt="Screenshot 2025-09-05 161646" src="https://github.com/user-attachments/assets/51d15714-2696-4ef4-94cd-4bc54f4b9625" />
<img width="1905" height="934" alt="Screenshot 2025-09-05 161722" src="https://github.com/user-attachments/assets/721d4ee7-9c30-4e41-98a7-d5e928c59b05" />
<img width="1919" height="933" alt="Screenshot 2025-09-05 161834" src="https://github.com/user-attachments/assets/fe1bc048-3c5a-419e-af18-a2d31e8f4bd3" />


## 🚀 Features

- **Secure Authentication**: JWT-based user authentication with Django REST Framework
- **Real-time Chat**: FastAPI-powered chatbot with multiple AI service integrations
- **Responsive UI**: Modern React interface with Tailwind CSS
- **Professional DevOps**: Docker containerization 

## 🛠 Tech Stack

### Frontend
- React 18 + Vite
- Tailwind CSS
- Axios for API communication
- React Router for navigation

### Backend
- Django REST Framework (Authentication)
- FastAPI (Chatbot Service)
- PostgreSQL (Primary Database)

### DevOps
- Docker & Docker Compose
- Railway (Deployment)

## 📋 Prerequisites

- Node.js (v18+)
- Python (v3.9+)
- PostgreSQL (v13+)
- Docker & Docker Compose

## 🚀 Quick Start

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/CodementorX.git
   cd CodementorX
   ```

2. **Environment Setup**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

3. **Start with Docker (Recommended)**
   ```bash
   docker-compose up --build
   ```

4. **Manual Setup (Alternative)**

   **Backend Setup:**
   ```bash
   # Django Auth Service
   cd backend/django_auth
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   python manage.py migrate
   python manage.py runserver 8000

   # FastAPI Chatbot Service (new terminal)
   cd backend/chatbot
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   uvicorn main:app --reload --port 8001
   ```

   **Frontend Setup:**
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

## 🌐 API Endpoints

### Django Auth Service (Port 8000)
```
POST   /auth/register/          - User registration
POST   /auth/login/             - User login
POST   /auth/logout/            - User logout
GET    /auth/profile/           - Get user profile
PUT    /auth/profile/           - Update profile
POST   /auth/password/reset/    - Reset password
```

### FastAPI Chatbot Service (Port 8001)
```
GET    /api/health              - Health check
POST   /api/chat/               - Send chat message
GET    /api/chat/history        - Get chat history
DELETE /api/chat/conversation   - Clear conversation
```

## 🐳 Docker Commands

```bash
# Start all services
docker-compose up --build

# Start in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild specific service
docker-compose build frontend
docker-compose up frontend
```

## 🧪 Testing

### Backend Tests
```bash
# Django tests
cd backend/django_auth
python manage.py test
```

### Frontend Tests
```bash
cd frontend
npm test
npm run lint
```

## 📦 Production Deployment

### Environment Variables

Create `.env` file with:

```env
# Django Settings
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com

# JWT Settings
JWT_SECRET_KEY=your-jwt-secret-key
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Database
DATABASE_URL=postgresql://user:password@host:port/database

# FastAPI Settings
CHATBOT_API_KEY=your-openai-api-key
CORS_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Frontend
VITE_DJANGO_API_URL=https://your-backend.railway.app
VITE_CHATBOT_API_URL=https://your-chatbot.railway.app/api
```

### Deploy to Railway

1. **Backend Deployment:**
   - Connect your GitHub repository to Railway
   - Create new service for Django backend
   - Set environment variables in Railway dashboard
   - Railway will automatically detect and build your Django app

2. **Chatbot Service Deployment:**
   - Create another service for FastAPI chatbot
   - Configure environment variables
   - Railway will handle the FastAPI deployment

3. **Frontend Deployment:**
   - Create a service for the React frontend
   - Set build command: `npm ci && npm run build`
   - Railway will serve the static files

4. **Database:**
   - Add PostgreSQL plugin in Railway
   - Railway will provide the DATABASE_URL automatically

## 🔧 Configuration

### Django Settings
Key settings in `backend/django_auth/config/settings.py`:
- `CORS_ALLOWED_ORIGINS`: Frontend domains
- `JWT_AUTH`: JWT token configuration
- `DATABASES`: Database configuration

### FastAPI Settings
Configuration in `backend/chatbot/main.py`:
- CORS middleware for cross-origin requests
- JWT verification middleware
- Rate limiting configuration

### Frontend Configuration
Settings in `frontend/src/api/`:
- `axiosClient.js`: Django API configuration
- `chatbotClient.js`: FastAPI configuration

## 🚦 Development Guidelines

### Code Style
- **Python**: Black formatter, isort for imports
- **JavaScript**: Prettier formatter, ESLint for linting
- **Git**: Conventional commits (feat:, fix:, docs:, etc.)

### Branching Strategy
- `main`: Production-ready code
- `develop`: Development branch
- `feature/*`: Feature branches
- `hotfix/*`: Production fixes

## 📊 Project Structure

```
CodementorX/
├── README.md
├── LICENSE
├── .gitignore
├── .dockerignore
├── .env
├── .env.example
├── docker-compose.yml
│
├── postman/                           # Postman collections & environments
│   ├── Collection.json
│   ├── Environment.json
│   ├── Fastapi_collection.json
│   └── Fastapi_environment.json
│
├── backend/
│   │
│   ├── django_auth/                   # Django REST + JWT
│   │   ├── manage.py
│   │   ├── config/
│   │   │   ├── __init__.py
│   │   │   ├── asgi.py
│   │   │   ├── settings.py            # JWT + DB configs
│   │   │   ├── urls.py
│   │   │   └── wsgi.py
│   │   │
│   │   ├── users/                     # Django Auth app
│   │   │   ├── __init__.py
│   │   │   ├── admin.py
│   │   │   ├── apps.py
│   │   │   ├── models.py              # Custom User model
│   │   │   ├── serializers.py
│   │   │   ├── urls.py                # /auth/ endpoints
│   │   │   ├── views.py               # login, register, profile
│   │   │   └── permissions.py         # role-based access
│   │   │
│   │   ├── requirements.txt
│   │   └── Dockerfile
│   │
│   ├── chatbot/                       # FastAPI service
│   │   ├── main.py                    # FastAPI app entry
│   │   ├── routes.py                  # /chat endpoints
│   │   ├── models.py                  # Chatbot models
│   │   ├── services.py                # Business logic
│   │   ├── utils.py                   # verify_jwt() with Django secret
│   │   ├── requirements.txt
│   │   └── Dockerfile
│   │
│   └── database/                      # Shared DB (optional, PostgreSQL)
│       ├── init.sql
│       └── migrations/                # Alembic for FastAPI OR Django migrations
│
├── frontend/                          # React (Auth + Chat)
│   ├── index.html
│   ├── package.json
│   ├── vite.config.js
│   ├── tailwind.config.js
│   ├── postcss.config.js
│   ├── .eslintrc.json
│   ├── .prettierrc
│   ├── Dockerfile
│   │
│   └── src/
│       ├── main.jsx
│       ├── App.jsx
│       │
│       ├── api/
│       │   ├── axiosClient.js         # Django API client
│       │   └── chatbotClient.js       # FastAPI API client
│       │
│       ├── context/
│       │   ├── AuthContext.jsx        # Global auth state
│       │   └── ChatContext.jsx
│       │
│       ├── components/
│       │   ├── Navbar.jsx
│       │   └── ProtectedRoute.jsx
│       │
│       ├── pages/                     # Auth pages
│       │   ├── Login.jsx
│       │   ├── Register.jsx
│       │   ├── Profile.jsx
│       │   ├── ForgotPassword.jsx
│       │   └── ResetPassword.jsx
│       │
│       ├── chatbot/                   # Chatbot UI
│       │   ├── ChatBox.jsx
│       │   ├── Sidebar.jsx
│       │   └── ChatInterface.jsx
│       │
│       └── styles/
│           └── tailwind.css
```

## 🔍 Troubleshooting

### Common Issues

**CORS Errors:**
- Check `CORS_ALLOWED_ORIGINS` in Django settings
- Verify FastAPI CORS middleware configuration

**Database Connection:**
- Ensure PostgreSQL is running
- Check `DATABASE_URL` format
- Verify database credentials

**Docker Issues:**
- Clear Docker cache: `docker system prune -a`
- Rebuild images: `docker-compose build --no-cache`
- Check port conflicts: `netstat -tulpn | grep :8000`

### Logs and Debugging

```bash
# View Django logs
docker-compose logs django

# View FastAPI logs
docker-compose logs chatbot

# View all logs
docker-compose logs -f

# Execute commands in running container
docker-compose exec django python manage.py shell
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Ensure all tests pass
6. Submit a pull request

### Development Setup
```bash
# Install development dependencies
cd backend/django_auth && pip install -r requirements-dev.txt
cd backend/chatbot && pip install -r requirements-dev.txt
cd frontend && npm install

# Run quality checks
python -m black .
python -m isort .
npm run lint
```

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## 🙋‍♂️ Support
- **Email**: jayeshafre1@gmail.com

---

**Built by Jayesh Afre**
