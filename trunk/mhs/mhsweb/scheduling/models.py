from django.db import models
from django.forms import ModelForm

# Create your models here.

class Employee(models.Model):
    nickname = models.CharField(max_length=12)
    last_name = models.CharField(max_length=30)
    first_name = models.CharField(max_length=30)
    def __unicode__(self):
        return self.nickname
    has_license = models.BooleanField()
    has_key = models.BooleanField()
    max_hours_per_week = models.SmallIntegerField()

VET_CHOICES = (
    ('N', 'None'),
    ('F', 'Fast'),
    ('S', 'Slow')
)

class Period(models.Model):
    name = models.CharField(max_length=20)
    starting_date = models.DateField()
    ending_date = models.DateField()
    def __unicode__(self):
        return self.name

class PeriodForm(ModelForm):
    class Meta:
        model = Period

class DayHeader(models.Model):
    period = models.ForeignKey(Period)
    date = models.DateField()
    def __unicode__(self):
        return self.date.strftime('%Y/%m/%d %A')
    veterinarian = models.CharField(max_length=1, choices=VET_CHOICES)
    opening_time = models.TimeField(null=True,blank=True)
    closing_time = models.TimeField(null=True,blank=True)

class DayDetail(models.Model):
    header = models.ForeignKey(DayHeader)
    employee = models.ForeignKey(Employee)
    off_work = models.BooleanField()
    starting_time = models.TimeField(null=True,blank=True)
    ending_time = models.TimeField(null=True,blank=True)
    def __unicode__(self):
        return self.employee.first_name

