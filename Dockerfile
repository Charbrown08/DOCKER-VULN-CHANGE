FROM httpd:2.4

# Copia los certificados SSL al contenedor
COPY ./server.crt /usr/local/apache2/conf/server.crt
COPY ./server.key /usr/local/apache2/conf/server.key

# Instala iputils-ping para habilitar el comando ping
RUN apt-get update && apt-get install -y iputils-ping

# Habilita los módulos SSL y configura los puertos 8080 y 443
RUN echo 'LoadModule ssl_module modules/mod_ssl.so' >> /usr/local/apache2/conf/httpd.conf && \
    echo 'Listen 8080' >> /usr/local/apache2/conf/httpd.conf && \
    echo 'Listen 443' >> /usr/local/apache2/conf/httpd.conf && \
    echo '<VirtualHost *:8080>' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    DocumentRoot /usr/local/apache2/htdocs/' >> /usr/local/apache2/conf/httpd.conf && \
    echo '</VirtualHost>' >> /usr/local/apache2/conf/httpd.conf && \
    echo '<VirtualHost *:443>' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    ServerName localhost' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    SSLEngine on' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    SSLCertificateFile /usr/local/apache2/conf/server.crt' >> /usr/local/apache2/conf/httpd.conf && \
    echo '    SSLCertificateKeyFile /usr/local/apache2/conf/server.key' >> /usr/local/apache2/conf/httpd.conf && \
    echo '</VirtualHost>' >> /usr/local/apache2/conf/httpd.conf

# Mantén el comando para iniciar Apache
CMD ["httpd-foreground"]
