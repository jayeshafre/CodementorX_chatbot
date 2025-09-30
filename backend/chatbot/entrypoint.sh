#!/bin/bash
# FastAPI Entrypoint Script for CodeMentorX Chatbot Service
# Handles startup validation and service initialization

set -e  # Exit on any error

echo "🤖 Starting CodeMentorX FastAPI Chatbot Service..."

# Function to validate environment variables
validate_env() {
    echo "🔍 Validating environment variables..."
    
    # Check required environment variables
    required_vars=("JWT_SECRET_KEY" "OPENAI_API_KEY")
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            echo "❌ Error: $var environment variable is not set"
            exit 1
        fi
    done
    
    echo "✅ Environment validation passed!"
}

# Function to wait for Django service
wait_for_django() {
    echo "⏳ Waiting for Django service to be ready..."
    
    DJANGO_HOST=${DJANGO_API_URL:-http://django:8000}
    DJANGO_HOST=${DJANGO_HOST#http://}  # Remove http://
    DJANGO_HOST=${DJANGO_HOST#https://}  # Remove https://
    DJANGO_HOST=${DJANGO_HOST%/*}  # Remove path if any
    
    # Extract host and port
    if [[ $DJANGO_HOST == *":"* ]]; then
        DJANGO_IP=${DJANGO_HOST%:*}
        DJANGO_PORT=${DJANGO_HOST#*:}
    else
        DJANGO_IP=$DJANGO_HOST
        DJANGO_PORT=8000
    fi
    
    # Wait for Django to be accessible (timeout after 60 seconds)
    timeout=60
    count=0
    
    until curl -s -f "http://${DJANGO_IP}:${DJANGO_PORT}/health/" > /dev/null 2>&1; do
        if [ $count -ge $timeout ]; then
            echo "⚠️ Django service not ready after ${timeout}s, continuing anyway..."
            break
        fi
        echo "Django is unavailable - sleeping for 1 second... (${count}/${timeout})"
        sleep 1
        ((count++))
    done
    
    if [ $count -lt $timeout ]; then
        echo "✅ Django service is ready!"
    fi
}

# Function to test OpenAI API connection
test_openai_connection() {
    echo "🧠 Testing OpenAI API connection..."
    
    # Simple test using curl (optional, can fail gracefully)
    if command -v curl > /dev/null 2>&1; then
        if curl -s -H "Authorization: Bearer ${OPENAI_API_KEY}" \
           -H "Content-Type: application/json" \
           "${OPENAI_API_BASE}/models" > /dev/null 2>&1; then
            echo "✅ OpenAI API connection successful!"
        else
            echo "⚠️ OpenAI API connection failed - check API key and internet connection"
        fi
    else
        echo "ℹ️ Skipping OpenAI connection test (curl not available)"
    fi
}

# Function to show startup information
show_startup_info() {
    echo "📋 CodeMentorX FastAPI Chatbot Service Startup Info:"
    echo "   🐍 Python version: $(python --version)"
    echo "   🚀 FastAPI host: ${FASTAPI_HOST:-0.0.0.0}"
    echo "   🚀 FastAPI port: ${FASTAPI_PORT:-8001}"
    echo "   🤖 AI Model: ${AI_MODEL_NAME:-gpt-4o-mini}"
    echo "   🔗 Django API: ${DJANGO_API_URL:-http://django:8000}"
    echo "   🌐 CORS Origins: ${CORS_ALLOWED_ORIGINS:-localhost}"
    echo "   🐛 Debug mode: ${DEBUG:-False}"
    echo "   🚀 Starting with command: $*"
}

# Function to perform pre-flight checks
preflight_checks() {
    echo "🔧 Performing pre-flight checks..."
    
    # Check if required Python modules can be imported
    python -c "
import sys
modules = ['fastapi', 'uvicorn', 'openai', 'jwt', 'httpx']
missing = []

for module in modules:
    try:
        __import__(module)
        print(f'✅ {module}')
    except ImportError:
        missing.append(module)
        print(f'❌ {module}')

if missing:
    print(f'Missing modules: {missing}')
    sys.exit(1)
print('✅ All required modules available')
"
}

# Main execution flow
main() {
    # Validate environment
    validate_env
    
    # Show startup information
    show_startup_info
    
    # Perform pre-flight checks
    preflight_checks
    
    # Wait for Django service
    wait_for_django
    
    # Test OpenAI connection (optional)
    test_openai_connection
    
    # Execute the main command (usually uvicorn)
    echo "🚀 Starting FastAPI Chatbot Service..."
    exec "$@"
}

# Run main function with all script arguments
main "$@"