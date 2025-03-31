#!/bin/bash

# Check if pipenv is installed, if not, install it
if ! [ -x "$(command -v pipenv)" ]; then
  echo 'Pipenv not found. Installing...' >&2
  pip install --user pipenv
fi

# Install dependencies with Pipenv
pipenv install

# Activate the virtual environment
pipenv shell

# Run Django migrations
python manage.py makemigrations
python manage.py migrate

# Create SuperUser
echo "Enter your Admin username (default: admin): "
read SUPERUSER_USERNAME
SUPERUSER_USERNAME=${SUPERUSER_USERNAME:-admin}

# Use 'read -s' to hide the password input
echo "Enter the password for the admin account (default: password): "
read -s SUPERUSER_PASSWORD
SUPERUSER_PASSWORD=${SUPERUSER_PASSWORD:-password}

# Create superuser in Django using Django shell command
echo "Creating superuser with username: $SUPERUSER_USERNAME"
python -c "
from django.contrib.auth import get_user_model
from django.core.management import call_command
from django.db import IntegrityError

User = get_user_model()
try:
    # Try to create superuser
    User.objects.create_superuser('$SUPERUSER_USERNAME', 'admin@example.com', '$SUPERUSER_PASSWORD')
except IntegrityError:
    # If the superuser already exists, print a message
    print('Superuser already exists or an error occurred.')
" 

# Run the Django development server
python manage.py runserver
