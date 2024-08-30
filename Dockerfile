FROM ubuntu:latest

# Set environment variables to suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    apache2 \
    php8.1 \
    wget \
    lua5.3 \
    python3.10 \
    mysql-server \
    dbconfig-common \
    && apt-get clean

# Preconfigure phpMyAdmin to use apache2 and auto-configure the database
RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections && \
    echo "phpmyadmin phpmyadmin/app-password-confirm password password" | debconf-set-selections && \
    echo "phpmyadmin phpmyadmin/mysql/admin-pass password password" | debconf-set-selections && \
    echo "phpmyadmin phpmyadmin/mysql/app-pass password password" | debconf-set-selections && \
    echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

# Install phpMyAdmin
RUN apt-get install -y phpmyadmin && apt-get clean

# Create the 'admin' user with passwordless sudo
RUN useradd -m admin && \
    echo 'admin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create the 'webmasters' group and add 'admin' and 'www-data' to it
RUN groupadd webmasters && \
    usermod -aG webmasters admin && \
    usermod -aG webmasters www-data

# Unpack the tarball
COPY base-image-conf/_files_backup.tar.gz /tmp/
RUN tar -xvzf /tmp/_files_backup.tar.gz -C /

# Add the .my.cnf file to the appropriate location
COPY .my.cnf /root/.my.cnf

# Set up MySQL root login via unix_socket
RUN service mysql start && \
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'auth_socket';" && \
    mysql -u root -e "FLUSH PRIVILEGES;"

# Add alias to the admin user's .bashrc
RUN echo "alias wp-gen='sudo lua /home/admin/wordpress/main.lua'" >> /home/admin/.bashrc

# Expose necessary ports
EXPOSE 80 443

# Start services (Apache, MySQL)
CMD ["sh", "-c", "service apache2 start && service mysql start && tail -f /var/log/apache2/access.log"]
