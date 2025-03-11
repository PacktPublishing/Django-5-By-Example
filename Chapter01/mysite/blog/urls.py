from django.urls import path

from . import views

app_name = 'blog'

urlpatterns = [
    # post views
    path('', views.post_list, name='post_list'),
    path('<int:id>/', views.post_detail, name='post_detail'),
    path('favrourite/add/<int:id>/', views.add_favourite, name='add_favourite'),
    path('favourites/', views.favourites, name='favourites'),
]
