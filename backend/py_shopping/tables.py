import django_tables2 as tables
from .models import Product, Order

class ProductTable(tables.Table):
    class Meta:
        model = Product
        template_name = 'django_tables2/bootstrap4.html'
        fields = ('name', 'category', 'price', 'inventory', 'is_active', 'created_at')

class OrderTable(tables.Table):
    class Meta:
        model = Order
        template_name = 'django_tables2/bootstrap4.html'
        fields = ('id', 'status', 'total_amount', 'created_at') 