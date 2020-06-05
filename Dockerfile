FROM  perl:5.14
SHELL ["/bin/bash", "-c"]
RUN apt-get -y update
RUN apt-get -y install apache2 vim git

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN a2enmod cgi
RUN echo "ScriptSock /var/run/cgid.sock" >> /etc/apache2/httpd.conf

RUN mkdir -p /var/www/html/data/img
COPY ./doc /var/www/html/data
COPY ./img /var/www/html/data/img

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]