FROM  perl:5-slim
SHELL ["/bin/bash", "-c"]
RUN apt-get -y update
RUN apt-get -y install apache2 vim git cpanminus locales-all
RUN cpanm -L extlib Perl::Critic
RUN chmod 755 sow.cgi
COPY 001-sower.conf /etc/apache2/site-enabled/

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN a2enmod cgi
RUN echo "ScriptSock /var/run/cgid.sock" >> /etc/apache2/httpd.conf

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]