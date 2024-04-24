**Background:** I've developed an e-learning platform using Django that organizes course content into different modules.

**Goal:** I want to enable students to resume a course at the exact module where they last left off. To achieve this, I plan to utilize Redis to store the last module students accessed in a course.

**Implementation Details:**
I want to use the following code to establish a connection to Redis using the `redis` Python library, and I want to follow Redis's naming conventions for the keys.
```
import redis
from django.conf import settings

# Setting up the Redis connection
r = redis.Redis(
    host=settings.REDIS_HOST,
    port=settings.REDIS_PORT,
    db=settings.REDIS_DB,
)
```

**Here’s some of my existing setup:**

Definition of the `Course` and `Module` models in `courses/models.py`:
```
class Course(models.Model):
    # ...

    class Meta:
        ordering = ['-created']

    def __str__(self):
        return self.title


class Module(models.Model):
    course = models.ForeignKey(
        Course, related_name='modules', on_delete=models.CASCADE
    )
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    order = OrderField(blank=True, for_fields=['course'])

    class Meta:
        ordering = ['order']

    def __str__(self):
        return f'{self.order}. {self.title}'
```

View for students to access course module contents in `students/views.py`:
```
class StudentCourseDetailView(LoginRequiredMixin, DetailView):
    model = Course
    template_name = 'students/course/detail.html'

    def get_queryset(self):
        qs = super().get_queryset()
        return qs.filter(students__in=[self.request.user])

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # get course object
        course = self.get_object()
        if 'module_id' in self.kwargs:
            # get current module
            context['module'] = course.modules.get(
                id=self.kwargs['module_id']
            )
        else:
            # get first module
            context['module'] = course.modules.all()[0]
        return context
```
