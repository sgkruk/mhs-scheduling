# Create your views here.
from django.template import Context, loader
from django.http import HttpResponse
from scheduling.models import Period
from scheduling.models import PeriodForm
from scheduling.models import DayHeader
from django.shortcuts import get_object_or_404, render_to_response
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse
from datetime import timedelta
def index(request):
    # Get the last few periods
    last_periods = Period.objects.all().order_by('-ending_date')[:1]
    t = loader.get_template('scheduling/index.html')
    c = Context({'last_periods': last_periods})
    return HttpResponse(t.render(c))

def new(request):
    last_period = Period.objects.all().order_by('-ending_date')[0]
    if request.method == 'POST': # If the form has been submitted...
        form = PeriodForm(request.POST) 
        if form.is_valid(): # All validation rules pass
            # Process the data in form.cleaned_data
            # Save the period
            new_period = form.save()
            # Create the associated DayHeaders (one per day of period)
            oneday = timedelta(days=1)
            oneweek = timedelta(days=7)
            day = new_period.starting_date
            while(day < new_period.ending_date):
                previousdate = day-oneweek
                try:
                    previousday = DayHeader.objects.get(date=previousdate)
                except DayHeader.DoesNotExist: 
                    dh = DayHeader(period=new_period,\
                                       date=day,\
                                       opening_time='07:00',\
                                       closing_time='20:00',\
                                       veterinarian='S')
                else:
                    dh = DayHeader(period=new_period,\
                                       date=day,\
                                       opening_time=previousday.opening_time,\
                                       closing_time=previousday.closing_time,\
                                       veterinarian=previousday.veterinarian)
                dh.save()
                day = day+oneday
            return HttpResponseRedirect('../admin') # Redirect after POST
    else:
        # Fill with intelligent defaults
        # The next 35 days, for example
        t35 = timedelta(days=35)
        t5 = timedelta(days=5)
        mid = ending_date=last_period.ending_date+t5
        p = Period(name=mid.strftime('%B-%Y'),\
                       starting_date=last_period.ending_date, \
                       ending_date=last_period.ending_date+t35)
        # A form bound to the POST data
        form = PeriodForm(instance=p) # An unbound form
            
    return render_to_response('scheduling/new.html', {'form': form})

def run(request):
    return HttpResponse("Run the AI on the current scheduling period")

def change(request):
    return HttpResponse("View/Edit the current scheduling period")
