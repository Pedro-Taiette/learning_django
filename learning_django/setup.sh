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

echo "Enter the password (default: password): "
read -s SUPERUSER_PASSWORD
SUPERUSER_PASSWORD=${SUPERUSER_PASSWORD:-password}

# Create superuser in Django
echo "Creating superuser with username: $SUPERUSER_USERNAME and password: $SUPERUSER_PASSWORD"
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('$SUPERUSER_USERNAME', 'admin@example.com', '$SUPERUSER_PASSWORD')" | python manage.py shell

# Run the Django development server
python manage.py runserver

