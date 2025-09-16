# CodementorX 🤖

A professional full-stack chatbot platform showcasing modern web development practices with React, Django, FastAPI, and PostgreSQL.

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
-

## 📋 Prerequisites

- Node.js (v18+)
- Python (v3.9+)
- PostgreSQL (v13+)
- Redis (v6+)
- Docker & Docker Compose

## 🚀 Quick Start

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/CodementorX.git
   cd CodementorX
<<<<<<< HEAD
=======
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

# FastAPI tests
cd backend/chatbot
pytest tests/ -v
```

### Frontend Tests
```bash
cd frontend
npm test
npm run lint
```

### Integration Tests
```bash
# Run full test suite
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
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

# Redis
REDIS_URL=redis://host:port/0

# FastAPI Settings
CHATBOT_API_KEY=your-openai-api-key
CORS_ORIGINS=https://yourdomain.com,https://www.yourdomain.com

# Frontend
VITE_DJANGO_API_URL=https://your-backend.render.com
VITE_CHATBOT_API_URL=https://your-chatbot.render.com/api
```

### Deploy to Render

1. **Backend Deployment:**
   - Create new Web Service on Render
   - Connect your GitHub repository
   - Set build command: `pip install -r requirements.txt`
   - Set start command: `python manage.py migrate && gunicorn config.wsgi:application`

2. **Frontend Deployment:**
   - Create new Static Site on Render
   - Set build command: `npm ci && npm run build`
   - Set publish directory: `dist`

### Deploy to Vercel (Frontend)

```bash
npm install -g vercel
vercel --prod
```

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

### Pull Request Process
1. Create feature branch from `develop`
2. Make changes with tests
3. Run linting and tests locally
4. Submit PR to `develop`
5. Code review and CI checks
6. Merge after approval

## 📊 Project Structure

```
CodementorX/
├── .github/workflows/           # GitHub Actions CI/CD
├── backend/
│   ├── django_auth/            # Django REST API
│   └── chatbot/                # FastAPI chatbot service
├── frontend/                   # React application
├── docker-compose.yml          # Docker services
├── .env.example               # Environment template
└── README.md                  # This file
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

**Redis Connection:**
- Confirm Redis server is running
- Check `REDIS_URL` configuration
- Verify Redis port accessibility

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
# Install pre-commit hooks
pip install pre-commit
pre-commit install

# Run quality checks
make lint
make test
make security-check
```

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## 🙋‍♂️ Support
- **Email**: jayeshafre1@gmail.com



---

**Built by Jayesh Afre**
