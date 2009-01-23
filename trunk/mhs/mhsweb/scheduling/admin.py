from mhsweb.scheduling.models import Employee
from mhsweb.scheduling.models import DayHeader
from mhsweb.scheduling.models import DayDetail
from mhsweb.scheduling.models import Period
from django.contrib import admin

class DayHeaderInline(admin.TabularInline):
    model = DayHeader
    extra=7

class PeriodAdmin(admin.ModelAdmin):
    fieldsets = [
        (None, {'fields':['name']}),
        ('Date information', 
         {'fields': ['starting_date', 'ending_date']}),
        ]
    inlines = [DayHeaderInline]

class DayDetailInline(admin.TabularInline):
    model = DayDetail
    extra = 7

class DayHeaderAdmin(admin.ModelAdmin):
    fieldsets = [
        (None, {'fields':['date']}),
        ('Day Information',
         {'fields': ['veterinarian', 'opening_time', 'closing_time']}),
        ]
    inlines = [DayDetailInline]

class EmployeeAdmin(admin.ModelAdmin):
    list_display = ('nickname','first_name','last_name','has_license','has_key','max_hours_per_week')

admin.site.register(DayDetail)
admin.site.register(Employee,EmployeeAdmin)
admin.site.register(DayHeader,DayHeaderAdmin)
admin.site.register(Period,PeriodAdmin)

