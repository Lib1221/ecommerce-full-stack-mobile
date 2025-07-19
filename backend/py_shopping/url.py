from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *
from . import views
from django.contrib.auth import views as auth_views

router = DefaultRouter()
router.register(r'categories', CategoryViewSet)
router.register(r'products', ProductViewSet)
router.register(r'cart', CartViewSet, basename='cart')
router.register(r'cart-items', CartItemViewSet, basename='cartitem')
router.register(r'orders', OrderViewSet, basename='order')
router.register(r'order-items', OrderItemViewSet, basename='orderitem')

api_urlpatterns = [
    path('auth/signup/', views.signup_api, name='signup_api'),
    path('auth/login/', views.login_api, name='login_api'),
    path('auth/logout/', views.logout_api, name='logout_api'),
    path('auth/profile/', views.user_profile_api, name='user_profile_api'),
    
    # Cart APIs
    path('cart/add/', views.add_to_cart_api, name='add_to_cart_api'),
    path('cart/update/<int:item_id>/', views.update_cart_item_api, name='update_cart_item_api'),
    path('cart/remove/<int:item_id>/', views.remove_from_cart_api, name='remove_from_cart_api'),
    
    path('cart/checkout/', CartCheckoutView.as_view(), name='cart-checkout'),
    
    # Product APIs
    path('products/<int:pk>/detail/', views.product_detail_api, name='product_detail_api'),
    path('categories/<int:category_id>/products/', views.category_products_api, name='category_products_api'),
    path('', include(router.urls)),
]

urlpatterns = [
    path('api/shop/cart/items/', views.cart_items_api, name='cart_items_api'),
    path('api/shop/', include(api_urlpatterns)),
    path('api/shop/homepage/', views.homepage_api, name='homepage_api'),
    path('', views.homepage, name='homepage'),
    path('products/', views.homepage, name='product_list_page'),
    path('products/<int:pk>/', views.product_detail, name='product_detail'),
    path('products/<int:pk>/add-to-cart/', views.add_to_cart, name='add_to_cart'),
    path('login/', auth_views.LoginView.as_view(template_name='py_shopping/login.html', redirect_authenticated_user=True, next_page='homepage'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(next_page='login'), name='logout'),
    path('signup/', views.signup_page, name='signup'),
    path('cart/', views.cart_page, name='cart_page'),
    path('orders/', views.orders_page, name='orders_page'),
    path('cart/count/', views.cart_count, name='cart_count'),
    path('cart/checkout/', CartCheckoutView.as_view(), name='cart-checkout'),
]
