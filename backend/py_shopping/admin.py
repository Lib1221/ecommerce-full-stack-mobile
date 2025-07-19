from django.contrib import admin
from django.urls import path
from django.template.response import TemplateResponse
from django.utils.html import format_html
from .models import Category, Product, Cart, CartItem, Order, OrderItem

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name', 'description', 'created_at')
    search_fields = ('name',)

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'price', 'inventory', 'is_active', 'created_at')
    list_filter = ('category', 'is_active')
    search_fields = ('name',)

class CartItemInline(admin.TabularInline):
    model = CartItem
    extra = 0

@admin.register(Cart)
class CartAdmin(admin.ModelAdmin):
    inlines = [CartItemInline]
    list_display = ('user', 'updated_at')

class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0

@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    inlines = [OrderItemInline]
    list_display = ('user', 'status', 'total', 'created_at')
    list_filter = ('status',)

# Custom Admin Dashboard
class ShopAdminSite(admin.AdminSite):
    site_header = 'Shop Admin'
    site_title = 'Shop Admin Portal'
    index_title = 'Welcome to the Shop Admin'

    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path('dashboard/', self.admin_view(self.dashboard_view), name='shop-dashboard'),
        ]
        return custom_urls + urls

    def dashboard_view(self, request):
        from django.db.models import Sum
        from django.db.models.functions import TruncMonth
        total_sales = Order.objects.aggregate(total=Sum('total'))['total'] or 0
        order_count = Order.objects.count()
        product_count = Product.objects.count()
        category_count = Category.objects.count()
        recent_orders = Order.objects.order_by('-created_at')[:5]
        # Sales by month for chart
        sales_by_month = (
            Order.objects
            .annotate(month=TruncMonth('created_at'))
            .values('month')
            .annotate(total=Sum('total'))
            .order_by('month')
        )
        chart_labels = [s['month'].strftime('%b %Y') for s in sales_by_month]
        chart_data = [float(s['total']) for s in sales_by_month]
        context = dict(
            self.each_context(request),
            total_sales=total_sales,
            order_count=order_count,
            product_count=product_count,
            category_count=category_count,
            recent_orders=recent_orders,
            chart_labels=chart_labels,
            chart_data=chart_data,
        )
        return TemplateResponse(request, 'admin/shop_dashboard.html', context)

# Register the custom admin site
admin_site = ShopAdminSite(name='shop_admin')
from django.contrib import admin
from oauth2_provider.models import Application
from oauth2_provider.admin import ApplicationAdmin


class CustomApplicationAdmin(ApplicationAdmin):
    readonly_fields = ('client_id', 'client_secret')

    def get_readonly_fields(self, request, obj=None):
        # Only make these readonly during update, not during create
        if obj:
            return self.readonly_fields + ('client_id', 'client_secret')
        return self.readonly_fields

admin.site.unregister(Application)
admin.site.register(Application, CustomApplicationAdmin)

admin.site.unregister(Cart)
admin.site.unregister(Order)
admin.site.register(Cart, CartAdmin)
admin.site.register(Order, OrderAdmin)
