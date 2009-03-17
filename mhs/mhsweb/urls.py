from django.conf.urls.defaults import *

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Example:
    # (r'^mhsweb/', include('mhsweb.foo.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'admin/(.*)', admin.site.root),
    (r'scheduling/$', 'mhsweb.scheduling.views.index'),
    (r'scheduling/new', 'mhsweb.scheduling.views.new'),
    (r'scheduling/run', 'mhsweb.scheduling.views.run'),
    (r'scheduling/change', 'mhsweb.scheduling.views.change'),
)
