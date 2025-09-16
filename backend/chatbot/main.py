"""
FastAPI Chatbot Service
Main application entry point with JWT integration
"""
from fastapi import FastAPI, Request, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.responses import JSONResponse
import uvicorn
import os
from dotenv import load_dotenv
import logging

from routes import chat_router
from utils import verify_jwt_token

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(
    title="CodementorX Chatbot API",
    description="AI-powered chatbot service with JWT authentication",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Security scheme
security = HTTPBearer()

# CORS configuration - Updated for Docker networking
CORS_ORIGINS = os.getenv(
    "CORS_ALLOWED_ORIGINS", 
    "http://localhost:5173,http://127.0.0.1:5173,http://localhost:3000,http://127.0.0.1:3000"
).split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=[origin.strip() for origin in CORS_ORIGINS],
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)

# Dependency for JWT authentication
async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """
    Dependency to verify JWT token and extract user info
    """
    try:
        token = credentials.credentials
        user_info = verify_jwt_token(token)
        return user_info
    except Exception as e:
        logger.error(f"JWT verification failed: {e}")
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired token"
        )

# Health check endpoint
@app.get("/health")
async def health_check():
    """Health check endpoint for Docker healthcheck"""
    return {
        "status": "healthy",
        "service": "CodementorX Chatbot API",
        "version": "1.0.0",
        "environment": os.getenv("DEBUG", "False")
    }

# Root endpoint
@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "message": "CodementorX Chatbot API",
        "version": "1.0.0",
        "docs_url": "/docs",
        "health_url": "/health",
        "chat_endpoints": "/api/chat/"
    }

# Include chat routes with authentication
app.include_router(
    chat_router,
    prefix="/api",
    dependencies=[Depends(get_current_user)]
)

# Exception handlers - Fixed duplicate handlers
@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    """Handle HTTP exceptions with proper logging"""
    logger.error(f"HTTP Exception on {request.url}: {exc.detail}")
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": exc.detail,
            "status_code": exc.status_code,
            "path": str(request.url)
        }
    )

@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    """Handle general exceptions"""
    logger.error(f"Unhandled exception on {request.url}: {exc}")
    return JSONResponse(
        status_code=500,
        content={
            "error": "Internal server error",
            "status_code": 500,
            "path": str(request.url)
        }
    )

# Startup event
@app.on_event("startup")
async def startup_event():
    """Startup event handler"""
    logger.info("🚀 FastAPI Chatbot Service starting up...")
    logger.info(f"CORS Origins: {CORS_ORIGINS}")
    logger.info(f"JWT Secret configured: {'✅' if os.getenv('JWT_SECRET_KEY') else '❌'}")
    logger.info(f"OpenAI API configured: {'✅' if os.getenv('OPENAI_API_KEY') else '❌'}")

# Shutdown event
@app.on_event("shutdown")
async def shutdown_event():
    """Shutdown event handler"""
    logger.info("🛑 FastAPI Chatbot Service shutting down...")

if __name__ == "__main__":
    port = int(os.getenv("FASTAPI_PORT", 8001))
    host = os.getenv("FASTAPI_HOST", "0.0.0.0")
    
    logger.info(f"Starting FastAPI server on {host}:{port}")
    
    uvicorn.run(
        "main:app",
        host=host,
        port=port,
        reload=True if os.getenv("DEBUG", "False").lower() == "true" else False,
        log_level="info"
    )