# CodementorX 🤖

A professional full-stack chatbot platform showcasing modern DevOps practices with **Docker, CI/CD, and AWS deployment**.

<img width="1919" height="941" alt="Screenshot 2025-09-05 161735" src="https://github.com/user-attachments/assets/c4209030-9049-489a-bfda-319a7f0f9b49" />
<img width="1879" height="940" alt="Screenshot 2025-09-05 161646" src="https://github.com/user-attachments/assets/51d15714-2696-4ef4-94cd-4bc54f4b9625" />
<img width="1905" height="934" alt="Screenshot 2025-09-05 161722" src="https://github.com/user-attachments/assets/721d4ee7-9c30-4e41-98a7-d5e928c59b05" />
<img width="1919" height="933" alt="Screenshot 2025-09-05 161834" src="https://github.com/user-attachments/assets/fe1bc048-3c5a-419e-af18-a2d31e8f4bd3" />

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     AWS Free Tier Architecture                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ GitHub Actions CI/CD Pipeline                             │ │
│  │ • Build Docker Images                                     │ │
│  │ • Run Tests                                               │ │
│  │ • Push to Registry                                        │ │
│  │ • Deploy to EC2                                           │ │
│  └─────────────────┬─────────────────────────────────────────┘ │
│                    │ (Auto Deploy)                             │
│                    ↓                                             │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ EC2 t2.micro Instance (750 hrs/month FREE)              │   │
│  │                                                          │   │
│  │  ┌──────────────────────────────────────────────────┐   │   │
│  │  │ Nginx Reverse Proxy (Container)                  │   │   │
│  │  │ • Port 80/443 → SSL Termination                  │   │   │
│  │  │ • Routes to backend services                     │   │   │
│  │  └────────┬─────────────────────┬──────────────┬────┘   │   │
│  │           │                     │              │        │   │
│  │           ↓                     ↓              ↓        │   │
│  │  ┌────────────┐  ┌──────────────┐  ┌──────────────┐   │   │
│  │  │  Django    │  │   FastAPI    │  │    React     │   │   │
│  │  │ (Auth API) │  │  (Chatbot)   │  │  (Frontend)  │   │   │
│  │  │  Port 8000 │  │  Port 8001   │  │  Static Files│   │   │
│  │  └─────┬──────┘  └──────┬───────┘  └──────────────┘   │   │
│  │        │                │                              │   │
│  │        └────────┬───────┘                              │   │
│  │                 ↓                                       │   │
│  │        ┌─────────────────┐                             │   │
│  │        │   PostgreSQL    │                             │   │
│  │        │   (Container)   │                             │   │
│  │        │   Port 5432     │                             │   │
│  │        └─────────────────┘                             │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ S3 Bucket (5GB FREE)                                    │   │
│  │ • Static assets (CSS, JS, images)                       │   │
│  │ • User-uploaded media files                             │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ CloudWatch (FREE)                                       │   │
│  │ • 10 alarms (billing, CPU, memory)                      │   │
│  │ • 5GB logs (application + container logs)               │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Features

### **Application Features**
- **Secure Authentication**: JWT-based user authentication with Django REST Framework
- **Real-time Chat**: FastAPI-powered chatbot with multiple AI service integrations
- **Responsive UI**: Modern React interface with Tailwind CSS

### **DevOps Features**
- **Containerization**: Docker multi-stage builds for optimized images
- **CI/CD Pipeline**: Automated testing and deployment via GitHub Actions
- **Cloud Deployment**: AWS Free Tier architecture (EC2, S3, CloudWatch)
- **Reverse Proxy**: Nginx for SSL termination and load balancing
- **Monitoring**: CloudWatch alarms for billing, performance, and errors
- **Cost-Optimized**: $0/month on AWS Free Tier

---

## 🛠 Tech Stack

### **Frontend**
- React 18 + Vite
- Tailwind CSS
- Axios for API communication
- React Router for navigation

### **Backend**
- Django REST Framework (Authentication API)
- FastAPI (Chatbot Microservice)
- PostgreSQL 13+ (Database)

### **DevOps & Infrastructure**
- **Containerization**: Docker, Docker Compose
- **CI/CD**: GitHub Actions
- **Cloud**: AWS EC2 (t2.micro), S3, CloudWatch
- **Web Server**: Nginx (Reverse Proxy)
- **SSL**: Let's Encrypt (Free Certificates)

---

## 📋 Prerequisites

### **Local Development**
- Docker & Docker Compose
- Node.js 18+
- Python 3.9+
- Git

### **AWS Deployment**
- AWS Account (Free Tier eligible)
- AWS CLI configured
- SSH key pair for EC2 access

---

## 🚀 Quick Start

### **1. Clone Repository**
```bash
git clone https://github.com/yourusername/CodementorX.git
cd CodementorX
```

### **2. Environment Configuration**
```bash
# Copy example environment file
cp .env.example .env

# Edit .env with your configuration
# See "Environment Variables" section below
```

### **3. Local Development with Docker**
```bash
# Start all services (Django, FastAPI, React, PostgreSQL)
docker-compose up --build

# Run in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

**Access Points:**
- Frontend: `http://localhost:3000`
- Django API: `http://localhost:8000`
- FastAPI: `http://localhost:8001`
- API Docs: `http://localhost:8001/docs`

---

## 🐳 Docker Architecture

### **Multi-Stage Builds**
Each service uses optimized multi-stage Dockerfiles:

```dockerfile
# Example: Django Dockerfile
FROM python:3.11-slim AS builder
# Install dependencies in separate stage

FROM python:3.11-slim
# Copy only necessary files (smaller image)
```

**Image Sizes:**
- Django: ~180MB
- FastAPI: ~150MB
- React (Nginx): ~25MB
- PostgreSQL: Official image ~200MB

### **Docker Compose Services**

```yaml
services:
  postgres:    # Database
  django:      # Auth API (depends on postgres)
  fastapi:     # Chatbot (depends on postgres)
  frontend:    # React app (depends on django, fastapi)
```

**Volumes:**
- `postgres_data`: Database persistence
- `static_volume`: Django static files
- `media_volume`: User uploads

---

## 🔄 CI/CD Pipeline

### **GitHub Actions Workflow**

**Triggers:**
- Push to `main` branch
- Pull requests to `main`

**Pipeline Stages:**

```yaml
1. 🧪 Test Stage
   ├── Run Django tests
   ├── Run FastAPI tests
   ├── Lint Python code (Black, Flake8)
   └── Lint JavaScript (ESLint)

2. 🏗️ Build Stage
   ├── Build Django Docker image
   ├── Build FastAPI Docker image
   ├── Build React Docker image
   └── Tag with commit SHA

3. 📦 Push Stage
   ├── Login to Docker Hub / AWS ECR
   └── Push images to registry

4. 🚀 Deploy Stage
   ├── SSH into EC2 instance
   ├── Pull latest images
   ├── Run database migrations
   ├── Restart containers
   └── Health check verification
```

**Secrets Required:**
```bash
AWS_EC2_HOST          # EC2 public IP
AWS_EC2_USER          # ubuntu
AWS_EC2_SSH_KEY       # Private key content
DOCKER_USERNAME       # Docker Hub username
DOCKER_PASSWORD       # Docker Hub token
```

---

## ☁️ AWS Deployment

### **EC2 Instance Setup**

**Instance Details:**
- **Type**: t2.micro (1 vCPU, 1GB RAM)
- **OS**: Ubuntu 22.04 LTS
- **Storage**: 30GB gp3 SSD
- **Cost**: FREE (750 hours/month)

**Security Groups:**
```bash
Port 22  (SSH)    - Your IP only
Port 80  (HTTP)   - 0.0.0.0/0
Port 443 (HTTPS)  - 0.0.0.0/0
```

### **Deployment Steps**

**1. Connect to EC2**
```bash
ssh -i your-key.pem ubuntu@YOUR_EC2_IP
```

**2. Install Docker**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

**3. Clone and Deploy**
```bash
# Clone repository
git clone https://github.com/yourusername/CodementorX.git
cd CodementorX

# Create production environment file
nano .env  # Add production values

# Start services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Check logs
docker-compose logs -f
```

**4. Configure Nginx Reverse Proxy**
```bash
# Nginx handles SSL and routes to containers
# See nginx/nginx.conf for configuration
```

### **S3 Configuration**

**Create S3 Bucket:**
```bash
# Via AWS Console or CLI
aws s3 mb s3://codementorx-static --region us-east-1

# Set public read access for static files
aws s3api put-bucket-policy --bucket codementorx-static --policy file://s3-policy.json
```

**Django Configuration:**
```python
# settings.py
AWS_STORAGE_BUCKET_NAME = 'codementorx-static'
AWS_S3_REGION_NAME = 'us-east-1'
STATICFILES_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
```

---

## 🌐 API Endpoints

### **Django Auth Service** (`/api/auth/`)
```
POST   /auth/register/          # User registration
POST   /auth/login/             # User login (returns JWT)
POST   /auth/logout/            # Invalidate token
GET    /auth/profile/           # Get user profile
PUT    /auth/profile/           # Update profile
POST   /auth/password/reset/    # Password reset
POST   /auth/password/confirm/  # Confirm password reset
```

### **FastAPI Chatbot Service** (`/api/`)
```
GET    /health                  # Health check
POST   /chat/                   # Send message
GET    /chat/history            # Get conversation history
DELETE /chat/conversation       # Clear conversation
GET    /docs                    # Swagger documentation
```

---

## 📊 Monitoring & Observability

### **CloudWatch Alarms**

**1. Billing Alarm**
```bash
Trigger: When EstimatedCharges > $5
Action: Send SNS notification to email
```

**2. CPU Utilization**
```bash
Trigger: When CPU > 80% for 5 minutes
Action: Send alert (scale up manually)
```

**3. Memory Utilization**
```bash
Trigger: When Memory > 85%
Action: Send alert
```

**4. Disk Space**
```bash
Trigger: When Disk Usage > 80%
Action: Clean up Docker images/logs
```

### **Log Aggregation**

**CloudWatch Logs Groups:**
- `/aws/ec2/codementorx/django`
- `/aws/ec2/codementorx/fastapi`
- `/aws/ec2/codementorx/nginx`

**View Logs:**
```bash
# On EC2
docker-compose logs -f django
docker-compose logs -f fastapi

# Or via AWS Console → CloudWatch → Log Groups
```

### **Billing Alerts Setup**

```bash
# Set up budget alerts
AWS Console → Billing → Budgets → Create Budget
- Budget amount: $10
- Alerts at: 50%, 80%, 100%
```

---

## 🔒 Security Best Practices

### **1. Environment Variables**
```bash
# Never commit .env to Git
# Use AWS Secrets Manager for production
```

### **2. SSH Key Management**
```bash
# Restrict SSH to your IP only
# Use key-based authentication (no passwords)
chmod 400 your-key.pem
```

### **3. Database Security**
```bash
# PostgreSQL container not exposed to internet
# Only accessible via Docker network
```

### **4. HTTPS/SSL**
```bash
# Use Let's Encrypt for free SSL
# Auto-renewal via certbot
```

### **5. IAM Roles**
```bash
# Use EC2 instance roles instead of access keys
# Minimal permissions (least privilege)
```

---

## 🧪 Testing

### **Run Tests Locally**

**Backend Tests:**
```bash
# Django tests
docker-compose exec django python manage.py test

# FastAPI tests
docker-compose exec fastapi pytest
```

**Frontend Tests:**
```bash
# React tests
docker-compose exec frontend npm test

# Linting
docker-compose exec frontend npm run lint
```

### **CI/CD Tests**
All tests run automatically on every push via GitHub Actions.

---

## 🐛 Troubleshooting

### **Common Issues**

**1. Docker Build Fails**
```bash
# Clear Docker cache
docker system prune -a
docker-compose build --no-cache
```

**2. Port Already in Use**
```bash
# Check what's using the port
sudo lsof -i :8000
# Kill the process or change port in docker-compose.yml
```

**3. Database Connection Error**
```bash
# Ensure PostgreSQL is running
docker-compose ps
# Check database credentials in .env
```

**4. EC2 Out of Memory**
```bash
# Check memory usage
free -h
# Restart containers to free memory
docker-compose restart
```

**5. SSL Certificate Issues**
```bash
# Renew Let's Encrypt certificate
sudo certbot renew
# Restart Nginx
docker-compose restart nginx
```

---

## 📈 Performance Optimization

### **Docker Optimizations**
- Multi-stage builds (smaller images)
- `.dockerignore` to exclude unnecessary files
- Alpine Linux base images where possible

### **Nginx Caching**
```nginx
# Static file caching
location /static/ {
    expires 30d;
    add_header Cache-Control "public, immutable";
}
```

### **Database Optimization**
- Connection pooling (PgBouncer)
- Query optimization with indexes
- Regular VACUUM and ANALYZE

---

## 🔄 Backup & Recovery

### **Database Backups**

**Manual Backup:**
```bash
# Backup PostgreSQL
docker-compose exec postgres pg_dump -U postgres codementorx > backup.sql

# Upload to S3
aws s3 cp backup.sql s3://codementorx-backups/$(date +%Y%m%d).sql
```

**Automated Backups:**
```bash
# Add to crontab
0 2 * * * /home/ubuntu/backup.sh  # Daily at 2 AM
```

### **Disaster Recovery**

**Full System Restore:**
```bash
# 1. Launch new EC2 instance
# 2. Install Docker
# 3. Clone repository
# 4. Restore database from S3
# 5. Start containers
```

---

## 📦 Project Structure

```
CodementorX/
├── .github/
│   └── workflows/
│       └── ci.yml                    # GitHub Actions CI/CD pipeline
├── backend/
│   ├── django_auth/
│   │   ├── Dockerfile                # Multi-stage Django build
│   │   ├── requirements.txt
│   │   └── config/settings.py        # JWT + CORS configuration
│   └── chatbot/
│       ├── Dockerfile                # FastAPI container
│       ├── main.py
│       └── requirements.txt
├── frontend/
│   ├── Dockerfile                    # Multi-stage React + Nginx
│   ├── nginx.conf                    # Nginx configuration
│   ├── package.json
│   └── src/
├── nginx/
│   └── nginx.conf                    # Reverse proxy configuration
├── docker-compose.yml                # Local development
├── docker-compose.prod.yml           # Production overrides
├── .env.example                      # Environment template
├── .dockerignore                     # Exclude from builds
└── README.md
```

---

## 🚀 Deployment Checklist

Before deploying to production:

- [ ] Set `DEBUG=False` in Django settings
- [ ] Generate strong `SECRET_KEY` and `JWT_SECRET_KEY`
- [ ] Configure `ALLOWED_HOSTS` with your domain
- [ ] Set up CloudWatch billing alarms
- [ ] Enable HTTPS with Let's Encrypt
- [ ] Set up database backups
- [ ] Test CI/CD pipeline
- [ ] Configure monitoring alerts
- [ ] Review security group rules
- [ ] Document AWS resource IDs
- [ ] Create rollback plan

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

---

## 👨‍💻 Author

**Jayesh Afre**
- Email: jayeshafre1@gmail.com
- Portfolio: [{https://jayeshafre-portfolio.vercel.app/]
- LinkedIn: [http://www.linkedin.com/in/jayesh-afre]
- GitHub: [@jayeshafre](https://github.com/jayeshafre)

---

**⭐ Star this repository if you found it helpful!**
