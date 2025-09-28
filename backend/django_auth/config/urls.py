"""
Main URL Configuration for JWT Auth Project
Production-ready with API documentation and proper routing
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularRedocView,
    SpectacularSwaggerView,
)


def health_check(request):
    """Simple health check endpoint for Docker/K8s"""
    return JsonResponse({
        'status': 'healthy',
        'service': 'CodementorX Django Auth',
        'version': '1.0.0',
        'debug': settings.DEBUG
    })


def api_root(request):
    """API Root endpoint with available endpoints"""
    return JsonResponse({
        'message': 'Welcome to JWT Authentication API',
        'version': '1.0.0',
        'endpoints': {
            'auth': '/api/v1/auth/',
            'docs': {
                'swagger': '/api/docs/',
                'redoc': '/api/redoc/',
                'schema': '/api/schema/',
            },
            'admin': '/admin/',
            'health': '/health/',
        },
        'status': 'active'
    })


urlpatterns = [
    # Admin interface
    path('admin/', admin.site.urls),

    # Health check
    path('health/', health_check, name='health'),

    # API Root
    path('api/', api_root, name='api_root'),

    # API Authentication endpoints (choose ONE: custom or Djoser)
    path('api/v1/auth/', include('users.urls')),
    # path("api/v1/auth/", include("djoser.urls")),
    # path("api/v1/auth/", include("djoser.urls.jwt")),

    # API Documentation
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('api/redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
]

# Serve static/media in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

# Custom admin titles
admin.site.site_header = "JWT Auth Administration"
admin.site.site_title = "JWT Auth Admin"
admin.site.index_title = "Welcome to JWT Auth Administration"
