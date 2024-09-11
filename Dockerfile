# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive mode for apt to prevent prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql php-cli php-curl php-json php-mbstring php-xml php-zip \
    python3-pip wget curl lua5.4 sudo nano iputils-ping

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

    
    