**Background:** I've developed a Django application called account, which includes a Profile model. This model extends Django's default authentication User model.

**Goal:** I aim to use Django signals to automatically create an associated `Profile` object each time a `User` object is created.

**Here’s some of my existing setup:**

Definition of the `Profile` model in `account/models.py`:
```
class Profile(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE
    )
    date_of_birth = models.DateField(blank=True, null=True)
    photo = models.ImageField(
        upload_to='users/%Y/%m/%d/',
        blank=True
    )

    def __str__(self):
        return f'Profile of {self.user.username}'
```
