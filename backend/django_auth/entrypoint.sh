#!/bin/bash
# Django Entrypoint Script for CodeMentorX
# Handles database initialization, migrations, and Django startup

set -e  # Exit on any error

echo "🐳 Starting CodeMentorX Django Auth Service..."

# Function to wait for PostgreSQL to be ready
wait_for_db() {
    echo "⏳ Waiting for PostgreSQL to be ready..."
    
    # Extract database connection details from DATABASE_URL or env vars
    DB_HOST=${DB_HOST:-postgres}
    DB_PORT=${DB_PORT:-5432}
    
    # Wait for database connection (timeout after 30 seconds)
    until nc -z "$DB_HOST" "$DB_PORT"; do
        echo "PostgreSQL is unavailable - sleeping for 1 second..."
        sleep 1
    done
    
    echo "✅ PostgreSQL is ready!"
}

# Function to run Django management commands
run_django_setup() {
    echo "🔧 Running Django setup commands..."
    
    # Wait for database
    wait_for_db
    
    # Check if this is the first run (no migrations applied)
    echo "📊 Checking database status..."
    
    # Run database migrations
    echo "🔄 Applying database migrations..."
    python manage.py migrate --noinput
    
    # Create superuser if it doesn't exist (optional, for development)
    if [ "$DJANGO_SUPERUSER_EMAIL" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
        echo "👤 Creating superuser if not exists..."
        python manage.py shell << 'EOF'
import os
from django.contrib.auth import get_user_model
User = get_user_model()

email = os.environ.get('DJANGO_SUPERUSER_EMAIL')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD')

if email and password:
    # Check if user exists by email or username
    if not User.objects.filter(email=email).exists() and not User.objects.filter(username='admin').exists():
        try:
            User.objects.create_superuser(
                username='admin',
                email=email,
                password=password,
                first_name='Admin',
                last_name='User'
            )
            print(f"✅ Superuser created: {email}")
        except Exception as e:
            print(f"⚠️ Superuser creation failed: {e}")
    else:
        print("ℹ️ Superuser already exists")
else:
    print("ℹ️ Superuser credentials not provided")
EOF
    fi
    
    # Collect static files at runtime (when environment variables are available)
    echo "📁 Collecting static files..."
    python manage.py collectstatic --noinput --clear || echo "⚠️ Static files collection failed, continuing..."
    
    echo "✅ Django setup completed!"
}

# Function to validate environment variables
validate_env() {
    echo "🔍 Validating environment variables..."
    
    # Check required environment variables
    required_vars=("SECRET_KEY" "DATABASE_URL")
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            echo "❌ Error: $var environment variable is not set"
            exit 1
        fi
    done
    
    echo "✅ Environment validation passed!"
}

# Function to show startup information
show_startup_info() {
    echo "📋 CodeMentorX Django Auth Service Startup Info:"
    echo "   🐍 Python version: $(python --version)"
    echo "   🌐 Django version: $(python -c 'import django; print(django.get_version())')"
    echo "   🗄️ Database: ${DATABASE_URL%%@*}@***"  # Hide password in logs
    echo "   🐛 Debug mode: ${DJANGO_DEBUG:-True}"
    echo "   🌍 Allowed hosts: ${DJANGO_ALLOWED_HOSTS:-localhost,127.0.0.1,0.0.0.0}"
    echo "   🚀 Starting with command: $*"
}

# Main execution flow
main() {
    # Validate environment
    validate_env
    
    # Show startup information
    show_startup_info
    
    # Run Django setup (migrations, etc.)
    run_django_setup
    
    # Execute the main command (usually gunicorn or runserver)
    echo "🚀 Starting Django application..."
    exec "$@"
}

# Run main function with all script arguments
main "$@"