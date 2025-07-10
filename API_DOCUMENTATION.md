# Django Shopping API Documentation

This document describes the REST API endpoints for the Django shopping application.

## Base URL
```
http://localhost:8000/shop/api/shop/
```

## Authentication
The API uses Token authentication. Include the token in the Authorization header:
```
Authorization: Token <your_token>
```

## Endpoints

### Authentication

#### POST /auth/signup/
Create a new user account.

**Request Body:**
```json
{
    "username": "string",
    "email": "string",
    "password": "string"
}
```

**Response:**
```json
{
    "message": "User created successfully",
    "token": "string",
    "user": {
        "id": 1,
        "username": "string",
        "email": "string"
    }
}
```

#### POST /auth/login/
Authenticate a user and get a token.

**Request Body:**
```json
{
    "username": "string",
    "password": "string"
}
```

**Response:**
```json
{
    "message": "Login successful",
    "token": "string",
    "user": {
        "id": 1,
        "username": "string",
        "email": "string"
    }
}
```

#### POST /auth/logout/
Logout and invalidate the current token.

**Headers:** `Authorization: Token <token>`

**Response:**
```json
{
    "message": "Logout successful"
}
```

#### GET /auth/profile/
Get the current user's profile information.

**Headers:** `Authorization: Token <token>`

**Response:**
```json
{
    "id": 1,
    "username": "string",
    "email": "string",
    "date_joined": "2024-01-01T00:00:00Z"
}
```

### Products

#### GET /products/
Get all products (public endpoint).

**Response:**
```json
[
    {
        "id": 1,
        "name": "string",
        "description": "string",
        "price": "10.00",
        "image": "string",
        "category": 1,
        "created_at": "2024-01-01T00:00:00Z"
    }
]
```

#### GET /products/{id}/detail/
Get detailed information about a specific product.

**Response:**
```json
{
    "id": 1,
    "name": "string",
    "description": "string",
    "price": "10.00",
    "image": "string",
    "category": 1,
    "created_at": "2024-01-01T00:00:00Z"
}
```

#### GET /categories/{category_id}/products/
Get all products in a specific category.

**Response:**
```json
[
    {
        "id": 1,
        "name": "string",
        "description": "string",
        "price": "10.00",
        "image": "string",
        "category": 1,
        "created_at": "2024-01-01T00:00:00Z"
    }
]
```

### Cart

#### GET /cart/
Get the current user's cart with items.

**Headers:** `Authorization: Token <token>`

**Response:**
```json
{
    "id": 1,
    "user": 1,
    "items": [
        {
            "id": 1,
            "product": 1,
            "product_name": "string",
            "product_price": "10.00",
            "product_image": "string",
            "quantity": 2
        }
    ],
    "total_items": 2,
    "total_price": 20.00
}
```

#### POST /cart/add/
Add a product to the cart.

**Headers:** `Authorization: Token <token>`

**Request Body:**
```json
{
    "product_id": 1,
    "quantity": 2
}
```

**Response:**
```json
{
    "message": "Added 2 Product Name to cart",
    "cart_item": {
        "id": 1,
        "product": 1,
        "product_name": "string",
        "product_price": "10.00",
        "product_image": "string",
        "quantity": 2
    }
}
```

#### PUT /cart/update/{item_id}/
Update the quantity of a cart item.

**Headers:** `Authorization: Token <token>`

**Request Body:**
```json
{
    "quantity": 3
}
```

**Response:**
```json
{
    "message": "Cart item updated",
    "cart_item": {
        "id": 1,
        "product": 1,
        "product_name": "string",
        "product_price": "10.00",
        "product_image": "string",
        "quantity": 3
    }
}
```

#### DELETE /cart/remove/{item_id}/
Remove an item from the cart.

**Headers:** `Authorization: Token <token>`

**Response:**
```json
{
    "message": "Item removed from cart"
}
```

#### POST /cart/checkout/
Process checkout and create an order from cart items.

**Headers:** `Authorization: Token <token>`

**Response:**
```json
{
    "message": "Order created successfully",
    "order": {
        "id": 1,
        "user": 1,
        "items": [
            {
                "id": 1,
                "product": 1,
                "product_name": "string",
                "product_price": "10.00",
                "quantity": 2
            }
        ],
        "total_price": 20.00,
        "status": "pending",
        "created_at": "2024-01-01T00:00:00Z"
    }
}
```

### Orders

#### GET /orders/
Get all orders for the current user.

**Headers:** `Authorization: Token <token>`

**Response:**
```json
[
    {
        "id": 1,
        "user": 1,
        "items": [
            {
                "id": 1,
                "product": 1,
                "product_name": "string",
                "product_price": "10.00",
                "quantity": 2
            }
        ],
        "total_price": 20.00,
        "status": "pending",
        "created_at": "2024-01-01T00:00:00Z"
    }
]
```

### Categories

#### GET /categories/
Get all product categories.

**Response:**
```json
[
    {
        "id": 1,
        "name": "string",
        "description": "string"
    }
]
```

## Error Responses

All endpoints return appropriate HTTP status codes and error messages:

**400 Bad Request:**
```json
{
    "error": "Username, email, and password are required"
}
```

**401 Unauthorized:**
```json
{
    "error": "Invalid credentials"
}
```

**404 Not Found:**
```json
{
    "error": "Product not found"
}
```

**500 Internal Server Error:**
```json
{
    "error": "Internal server error"
}
```

## Testing the API

You can test the API endpoints using the provided test script:

```bash
python test_api.py
```

Or use tools like:
- **Postman**
- **curl**
- **Insomnia**

## Example Usage with curl

### Signup
```bash
curl -X POST http://localhost:8000/shop/api/shop/auth/signup/ \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "email": "test@example.com", "password": "testpass123"}'
```

### Login
```bash
curl -X POST http://localhost:8000/shop/api/shop/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "testpass123"}'
```

### Get Products
```bash
curl -X GET http://localhost:8000/shop/api/shop/products/ \
  -H "Authorization: Token <your_token>"
```

### Add to Cart
```bash
curl -X POST http://localhost:8000/shop/api/shop/cart/add/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Token <your_token>" \
  -d '{"product_id": 1, "quantity": 2}'
```

## Flutter Integration

The Flutter app uses these endpoints through the `ApiService` class. The service handles:
- Token management
- Error handling
- Response parsing
- Authentication headers

See `frontend/flutter_shopping/lib/app/services/api_service.dart` for implementation details. 