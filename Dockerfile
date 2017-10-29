FROM ubuntu:16.04

RUN apt-get update && apt-get install -y apache2 \
    libapache2-mod-wsgi \
    build-essential \
    python \
    python-dev\
    python-pip \
    && apt-get clean \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*

COPY ./app/requirements.txt /var/www/flaskapp/app/requirements.txt
RUN pip install -r /var/www/flaskapp/app/requirements.txt

COPY ./flaskapp.conf /etc/apache2/sites-available/flaskapp.conf
RUN a2ensite flaskapp
RUN a2enmod headers

COPY ./flaskapp.wsgi /var/www/flaskapp/flaskapp.wsgi

COPY ./run.py /var/www/flaskapp/run.py
COPY ./app /var/www/flaskapp/app/

RUN a2dissite 000-default.conf
RUN a2ensite flaskapp.conf

EXPOSE 80

WORKDIR /var/www/flaskapp

CMD  /usr/sbin/apache2ctl -D FOREGROUND
