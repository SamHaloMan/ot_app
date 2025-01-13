from rest_framework import serializers
from .models import Project, Employee, OvertimeRequest

class ProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ['id', 'name', 'is_enabled']

class EmployeeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Employee
        fields = ['id', 'name', 'emp_id', 'is_enabled']

class OvertimeSerializer(serializers.ModelSerializer):
    class Meta:
        model = OvertimeRequest
        fields = [
            'id',
            'employee',
            'employee_name',
            'project',
            'project_name',
            'request_date',
            'time_start',
            'time_end',
            'total_hours',
            'has_break',
            'break_start',
            'break_end',
            'break_hours',
            'reason',
            'detail',
            'is_holiday'
        ]