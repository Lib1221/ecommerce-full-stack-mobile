# Setup

## Backend

```bash
cd backend
python -m venv env && source env/bin/activate
pip install -r requirements.txt
cp .env.example .env    # SECRET_KEY, DATABASE_URL, STRIPE_SECRET_KEY, OAUTH client ids
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

Create an OAuth2 application in the Django admin (grant type: password or authorization code) and copy its client id/secret into the Flutter config.

## Mobile

```bash
cd flutter-food_delivery
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_...
```

Use `10.0.2.2` for the Android emulator and your machine's LAN IP for physical devices.
