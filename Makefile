TRIALMHS:
		eclipse -b roster-mhs.ecl -b rostering -e roster.
TRIAL2:
		eclipse -b roster2.ecl -b rostering -e roster.
TRIAL1:
		eclipse -b roster1.ecl -b rostering -e roster.
TRIAL0:
		eclipse -b roster0.ecl -b rostering.ecl -e roster.

dumpdata:
		python manage.py dumpdata scheduling  --indent 2 >scheduling/fixtures/scheduling.json

loaddata:

		python manage.py loaddata scheduling 

