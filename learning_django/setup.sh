#!/bin/bash

if ! [ -x "$(command -v pipenv)" ]; then
  echo 'Installing Pipenv...' >&2
  pip install pipenv
fi

pipenv install

pipenv shell

python manage.py makemigrations

python manage.py migrate

# Create SuperUser
echo "Type your Admin name (default: admin): "
read SUPERUSER_USERNAME
SUPERUSER_USERNAME=${SUPERUSER_USERNAME:-admin} 

echo "Password (default: password): "
read -s SUPERUSER_PASSWORD
SUPERUSER_PASSWORD=${SUPERUSER_PASSWORD:-password} 

echo "Creating superuser with name: $SUPERUSER_USERNAME and password: $SUPERUSER_PASSWORD"
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('$SUPERUSER_USERNAME', 'admin@example.com', '$SUPERUSER_PASSWORD')" | python manage.py shell

python manage.py runserver

