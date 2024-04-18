**Background:** I'm creating a blog using Django along with the library `django-taggit` for tagging my blog posts.

**Goal:**  I want to extend the sitemap functionality to include URLs for each tag used in the blog, effectively listing posts filtered by those tags in the `sitemap.xml`.

**Here's what I've done so far:**
- I've got a sitemap set up for the posts using Django's sitemap framework.
- I've made URL patterns that allow viewing posts filtered by tags.
- I want to add these tag-filtered views to my sitemap but I'm not sure how.

**Here’s some of my existing setup:**

For the posts' sitemap: `blog/sitemaps.py`
```
from django.contrib.sitemaps import Sitemap
from .models import Post


class PostSitemap(Sitemap):
    changefreq = 'weekly'
    priority = 0.9

    def items(self):
        return Post.published.all()

    def lastmod(self, obj):
        return obj.updated
```

The URL pattern for listing posts by a tag: `blog/urls.py`
```
urlpatterns = [
    # ...
    path('tag/<slug:tag_slug>/', views.post_list, name='post_list_by_tag'),
]
```

And the main site's URL configuration: `mysite/urls.py`
```
from django.contrib import admin
from django.contrib.sitemaps.views import sitemap
from django.urls import include, path
from blog.sitemaps import PostSitemap

sitemaps = {
    'posts': PostSitemap,
}

urlpatterns = [
    path('admin/', admin.site.urls),
    path('blog/', include('blog.urls', namespace='blog')),
    path(
        'sitemap.xml',
        sitemap,
        {'sitemaps': sitemaps},
        name='django.contrib.sitemaps.views.sitemap',
    ),
]
```

Please, explain the necessary changes to the code, to add tag pages to the sitemap.
