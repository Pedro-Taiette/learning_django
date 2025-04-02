#!/bin/bash

if ! command -v pipenv &> /dev/null; then
  echo 'Pipenv não encontrado. Instalando...'
  pip install --user pipenv
  export PATH="$HOME/.local/bin:$PATH"
fi

pipenv install

pipenv run bash -c "
  python manage.py makemigrations
  python manage.py migrate
  echo \"from django.contrib.auth import get_user_model; User = get_user_model();
if not User.objects.filter(is_superuser=True).exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'password')\" | python manage.py shell
  python manage.py runserver
"
