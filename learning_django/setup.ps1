# Define the project directory
$projectDir = "C:\Dev\learning_django\learning_django"

# Check if Python is installed
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python is not installed. Please install Python before proceeding."
    exit 1
}

# Create or activate the virtual environment
$venvDir = "$projectDir\venv"
$activateScript = "$venvDir\Scripts\Activate.ps1"

if (-not (Test-Path $venvDir)) {
    Write-Host "Creating virtual environment..."
    python -m venv $venvDir
} else {
    Write-Host "Activating virtual environment..."
}

# Activate the virtual environment
if (Test-Path $activateScript) {
    & $activateScript
} else {
    Write-Host "Error: Could not find the activation script."
    exit 1
}

# Install dependencies from requirements.txt
$requirementsPath = "$projectDir\requirements.txt"
if (Test-Path $requirementsPath) {
    Write-Host "Installing dependencies from requirements.txt..."
    pip install -r $requirementsPath
} else {
    Write-Host "No requirements.txt found. Skipping dependencies installation."
}

# Run Django migrations
Write-Host "Running Django migrations..."
python manage.py makemigrations
python manage.py migrate

# Create SuperUser (without password visibility)
$SUPERUSER_USERNAME = Read-Host "Enter the admin username (default: admin)"
if (-not $SUPERUSER_USERNAME) { $SUPERUSER_USERNAME = "admin" }

$SUPERUSER_PASSWORD = Read-Host "Enter the password for the admin account" -AsSecureString
$SUPERUSER_PASSWORDPlainText = [System.Net.NetworkCredential]::new('', $SUPERUSER_PASSWORD).Password

Write-Host "Creating superuser with username: $SUPERUSER_USERNAME"
$pythonScript = @"
from django.contrib.auth import get_user_model
User = get_user_model()
User.objects.create_superuser('$SUPERUSER_USERNAME', 'admin@example.com', '$SUPERUSER_PASSWORDPlainText')
"@
$pythonScript | python manage.py shell

# Start the Django development server
Write-Host "Starting Django development server..."
python manage.py runserver
