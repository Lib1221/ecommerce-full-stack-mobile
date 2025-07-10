#!/usr/bin/env python3
"""
Simple test script to verify Django API endpoints
Run this after starting the Django server
"""

import requests
import json

BASE_URL = "http://localhost:8000/shop/api/shop"

def test_signup():
    """Test user signup"""
    print("Testing signup...")
    url = f"{BASE_URL}/auth/signup/"
    data = {
        "username": "testuser",
        "email": "test@example.com",
        "password": "testpass123"
    }
    
    try:
        response = requests.post(url, json=data)
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.json().get('token')
    except Exception as e:
        print(f"Error: {e}")
        return None

def test_login(username, password):
    """Test user login"""
    print("Testing login...")
    url = f"{BASE_URL}/auth/login/"
    data = {
        "username": username,
        "password": password
    }
    
    try:
        response = requests.post(url, json=data)
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.json().get('token')
    except Exception as e:
        print(f"Error: {e}")
        return None

def test_products(token=None):
    """Test products endpoint"""
    print("Testing products...")
    url = f"{BASE_URL}/products/"
    headers = {}
    if token:
        headers['Authorization'] = f'Token {token}'
    
    try:
        response = requests.get(url, headers=headers)
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.json()
    except Exception as e:
        print(f"Error: {e}")
        return None

def test_add_to_cart(token, product_id):
    """Test adding to cart"""
    print("Testing add to cart...")
    url = f"{BASE_URL}/cart/add/"
    headers = {'Authorization': f'Token {token}'}
    data = {
        "product_id": product_id,
        "quantity": 2
    }
    
    try:
        response = requests.post(url, json=data, headers=headers)
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.json()
    except Exception as e:
        print(f"Error: {e}")
        return None

def test_cart(token):
    """Test cart endpoint"""
    print("Testing cart...")
    url = f"{BASE_URL}/cart/"
    headers = {'Authorization': f'Token {token}'}
    
    try:
        response = requests.get(url, headers=headers)
        print(f"Status: {response.status_code}")
        print(f"Response: {response.json()}")
        return response.json()
    except Exception as e:
        print(f"Error: {e}")
        return None

def main():
    print("=== Django API Test Script ===\n")
    
    # Test signup
    token = test_signup()
    print("\n" + "="*50 + "\n")
    
    if not token:
        # Try login with existing user
        token = test_login("testuser", "testpass123")
        print("\n" + "="*50 + "\n")
    
    if token:
        # Test products
        products = test_products(token)
        print("\n" + "="*50 + "\n")
        
        if products and len(products) > 0:
            # Test add to cart
            product_id = products[0]['id']
            test_add_to_cart(token, product_id)
            print("\n" + "="*50 + "\n")
            
            # Test cart
            test_cart(token)
            print("\n" + "="*50 + "\n")
    else:
        print("Failed to get authentication token")

if __name__ == "__main__":
    main() 