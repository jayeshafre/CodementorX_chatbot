#!/bin/bash
set -e

echo "=== Django Service Starting ==="

# Function to wait for database
wait_for_db() {
    echo "Waiting for PostgreSQL database..."
    while ! nc -z postgres 5432; do
        echo "Database not ready, waiting..."
        sleep 2
    done
    echo "✅ Database is ready!"
}

# Function to run migrations
run_migrations() {
    echo "Running database migrations..."
    python manage.py makemigrations --noinput || true
    python manage.py migrate --noinput
    echo "✅ Migrations completed!"
}

# Function to collect static files
collect_static() {
    echo "Collecting static files..."
    python manage.py collectstatic --noinput --clear
    echo "✅ Static files collected!"
}

# Function to create superuser if needed
create_superuser() {
    echo "Checking for superuser..."
    python manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(is_superuser=True).exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123');
    print('✅ Superuser created: admin/admin123');
else:
    print('✅ Superuser already exists');
" || echo "⚠️  Superuser creation skipped"
}

# Function to validate Django setup
validate_django() {
    echo "Validating Django configuration..."
    python manage.py check --deploy || python manage.py check
    echo "✅ Django validation passed!"
}

# Main execution
main() {
    wait_for_db
    run_migrations
    collect_static
    create_superuser
    validate_django
    
    echo "=== Django Service Ready ==="
    echo "🚀 Starting Django development server..."
    
    # Execute the passed command
    exec "$@"
}

# Handle signals gracefully
trap 'echo "Shutting down Django service..."; exit 0' SIGTERM SIGINT

# Run main function
main "$@"