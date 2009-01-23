dumpdata:
		python manage.py dumpdata scheduling  --indent 2 >scheduling/fixtures/scheduling.json

loaddata:

		python manage.py loaddata scheduling 

production:
		rsync --exclude='*sqlite3.db' --exclude='*settings.py' \
			-avru ~/programming/mhs/mhsweb/ \
			mogwai.math.oakland.edu:programming/mhs/mhsweb

deploy:
		rsync --exclude settings.py\* --exclude sqlite3.db -avru ${HOME}/programming/mhs/ mogwai.math.oakland.edu:programming/mhs
