TRIAL1:
		eclipse -b roster1.ecl -e 'getTimes(T),writeln(T).'
TRIAL0:
		eclipse -b roster0.ecl -b rostering.ecl -e roster.

dumpdata:
		python manage.py dumpdata scheduling  --indent 2 >scheduling/fixtures/scheduling.json

loaddata:

		python manage.py loaddata scheduling 

