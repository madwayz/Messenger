#!/bin/sh


export DJANGO_SECRET_KEY=`cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%^&*_+-' | fold -w 64 | head -n 1`

while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
  sleep 0.1
done

python manage.py flush --no-input
python manage.py collectstatic --noinput
python manage.py makemigrations
python manage.py migrate

chmod -R 777 static

if [ "$DJANGO_SUPERUSER_USERNAME" ]
then
    python manage.py createsuperuser \
        --username $DJANGO_SUPERUSER_USERNAME \
		--password $DJANGO_SUPERUSER_PASSWORD \
        --email $DJANGO_SUPERUSER_USERNAME \
		--skip-checks
fi

exec gunicorn config.wsgi:application --bind 0.0.0.0:8000
