# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive mode for apt to prevent prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql php-cli php-curl php-json php-mbstring php-xml php-zip \
    python3-pip wget curl lua5.4 sudo nano

# Create the non-root user and add it to the webmasters group
RUN groupadd -r webmasters && \
    groupadd -r datakiin && \
    useradd -r -g datakiin -G webmasters datakiin && \
    echo 'datakiin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    
# Ensure /var/lib/projects/html and /var/www/html directories exist and have the correct permissions
RUN mkdir -p /home/datakiin/ && \
    mkdir -p /home/datakiin/wp-gen/ && \
    chown -R www-data:webmasters /home/datakiin /home/datakiin/wp-gen && \
    chmod -R 755 /home/datakiin/ /home/datakiin/wp-gen

# Ensure /var/lib/projects/html and /var/www/html directories exist and have the correct permissions
RUN mkdir -p /var/lib/projects/html && \
    mkdir -p /var/www/html && \
    chown -R www-data:webmasters /var/lib/projects/html /var/www/html && \
    chmod -R 755 /var/lib/projects/html /var/www/html

# Set permissions for wp-config.php
RUN touch /var/www/html/wp-config.php && \
    chown www-data:webmasters /var/www/html/wp-config.php && \
    chmod 755 /var/www/html/wp-config.php

# Ensure permissions for Apache config files
RUN touch /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf && \
    chown root:root /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf && \
    chmod 644 /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf

# Ensure /etc/wordpress exists
RUN mkdir /etc/wordpress

# Set the ServerName globally to suppress the warning
RUN echo "ServerName datakiin" | sudo tee /etc/apache2/conf-available/servername.conf && \
    sudo a2enconf servername

# Enable Apache modules for SSL and PHP
RUN sudo a2enmod ssl && sudo a2enmod php8.1 && sudo a2enmod rewrite

# Expose port 80 for HTTP and 443 for HTTPS
EXPOSE 80 443

# Start MySQL and Apache services using apachectl
CMD ["apachectl", "-D", "FOREGROUND"]

    
    