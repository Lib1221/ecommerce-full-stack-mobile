# Architecture

Two deployable parts in one repo: a Django REST backend and a Flutter mobile client.

## Backend (`backend/`)

| Folder | Role |
| ------ | ---- |
| `shopping_backend/` | Settings, root URLs, OAuth2 provider config (django-oauth-toolkit) |
| `py_shopping/` | Products, categories, cart, orders, Stripe PaymentIntent endpoints, admin registrations |
| `media/` | Uploaded product images |

Auth is OAuth2 with access and refresh tokens (rotation and revocation). Payments create a Stripe PaymentIntent server-side and return the client secret to the app.

## Mobile (`flutter-food_delivery/`)

| Folder | Role |
| ------ | ---- |
| `core/` | HTTP client, token storage (secure storage), config |
| `data/` | Repositories and models for products, cart, orders |
| `presentation/` | Screens and widgets |
| `payment/` | Stripe PaymentSheet integration |
| `routes.dart` | Named routes |

## Request flow

```
Flutter -> OAuth2 token -> DRF endpoints -> PostgreSQL
Flutter -> /payments/intent -> Stripe (server) -> client secret -> PaymentSheet (device)
```
