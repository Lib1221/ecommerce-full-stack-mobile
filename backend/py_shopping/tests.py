from django.test import TestCase

# Create your tests here.
import requests

data = {
    'grant_type': 'password',
    'username': 'yourusername',
    'password': 'yourpassword',
    'client_id': 'yourclientid',
    'client_secret': 'yourclientsecret',
}

response = requests.post('http://127.0.0.1:8000/o/token/', data=data)
print(response.status_code)
print(response.json())
