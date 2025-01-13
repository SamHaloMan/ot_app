from django.urls import path, include
from rest_framework.routers import DefaultRouter
#from .views import SampleAPIView
from .views import ProjectViewSet,EmployeeViewSet, OvertimeRequestViewSet

router = DefaultRouter()
router.register(r'projects', ProjectViewSet)
router.register(r'employees', EmployeeViewSet)
router.register(r'overtime-requests', OvertimeRequestViewSet)

urlpatterns = [
    path('', include(router.urls)),
    #path('hello/', SampleAPIView.as_view(), name='hello'),
]