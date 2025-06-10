#!/usr/bin/env bash
# Exit on error
set -o errexit

# Modify this line as needed for your package manager (pip, poetry, etc.)
pip install -r requirements.txt

# Convert static asset files
python manage.py collectstatic --no-input

python manage.py makemigrations

# Apply any outstanding database migrations
python manage.py migrate

# Create static admin/admin user for django
# TODO REMOVE WHEN WE CAN USE SSH 
DJANGO_PROJECT_DIR="mysite"  # Replace with your actual project folder
DJANGO_SETTINGS_MODULE="mysite.settings"  # Replace with your actual settings module

# Set superuser credentials
USERNAME="admin"
EMAIL="admin@example.com"
PASSWORD="admin"

# Navigate to Django project root
cd "$(dirname "$0")"

# Create the superuser using a custom Python script
echo "from django.contrib.auth import get_user_model

User = get_user_model()
if not User.objects.filter(username='$USERNAME').exists():
    User.objects.create_superuser('$USERNAME', '$EMAIL', '$PASSWORD')
    print('Superuser created.')
else:
    print('Superuser already exists.')" | \
python manage.py shell --settings=$DJANGO_SETTINGS_MODULE

