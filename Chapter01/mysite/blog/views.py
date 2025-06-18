from django.contrib.auth.decorators import login_required
from django.http import HttpResponseRedirect
from django.shortcuts import get_object_or_404, render

from .models import FavouritePost, Post


def post_list(request):
    posts = Post.published.all()
    return render(
        request,
        'blog/post/list.html',
        {'posts': posts}
    )


def post_detail(request, id):
    favourite_post = None
    post = get_object_or_404(
        Post,
        id=id,
        status=Post.Status.PUBLISHED
    )
    try:
        if request.user.is_authenticated:
            favourite_post = FavouritePost.objects.get(
                user=request.user, post=post
            )
    except FavouritePost.DoesNotExist:
        pass
    return render(
        request,
        'blog/post/detail.html',
        {
            'is_favourite': favourite_post is not None,
            'post': post
        }
    )

def add_favourite(request, id):
    """ A view to add a post to favourites. Redirects to post detail when favourite added. """
    post = get_object_or_404(Post, id=id)
    FavouritePost.objects.get_or_create(
        user=request.user, post=post
    )
    return HttpResponseRedirect(post.get_absolute_url())

@login_required
def favourites(request):
    """ A view to list all favourite posts. """
    favourite_posts = Post.objects.filter(
        id__in=FavouritePost.objects.filter(
            user=request.user
        ).values_list('post_id', flat=True)
    )
    return render(
        request,
        'blog/post/favourites.html',
        {'favourite_posts': favourite_posts}
    )
