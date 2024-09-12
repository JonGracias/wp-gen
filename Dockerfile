# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive mode for apt to prevent prompts
ENV DEBIAN_FRONTEND=noninteractive

# # Update the package list and install required packages
# RUN apt-get update && apt-get upgrade -y && \
#     apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql php-cli php-curl php-json php-mbstring php-xml php-zip \
#     python3-pip wget curl lua5.4 sudo nano

# Update the package list and install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y apache2 \
    mysql-server \
    php \
    libapache2-mod-php \
    php-pear \
    php-dev \
    php-mysql \
    php-cli \
    php-curl \
    php-json \
    php-mbstring \
    php-xml \
    php-zip \
    php-gd \
    php-intl \
    python3-pip \
    wget \
    lua5.4 \
    iputils-ping \
    libmagickwand-dev \
    --no-install-recommends && \
    pecl install imagick && \
    echo "extension=imagick.so" > /etc/php/8.1/cli/conf.d/20-imagick.ini && \
    echo "extension=imagick.so" > /etc/php/8.1/apache2/conf.d/20-imagick.ini && \
    rm -rf /var/lib/apt/lists/*




# # Generate SSL certificate and key
# RUN mkdir -p /etc/ssl/certs /etc/ssl/private && \
#     openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#     -keyout /etc/ssl/private/apache-selfsigned.key \
#     -out /etc/ssl/certs/apache-selfsigned.crt \
#     -subj "/C=US/ST=Maryland/L=Frederick/O=Datakiin/OU=Online/CN=localhost"

# Ensure /etc/wordpress exists
RUN mkdir /etc/wordpress

# Set the ServerName globally to suppress the warning
RUN echo "ServerName datakiin" | tee /etc/apache2/conf-available/servername.conf && \
    a2enconf servername

# Enable Apache modules for SSL, PHP, and rewrite
# RUN a2enmod ssl
RUN a2enmod php8.1 && a2enmod rewrite

# # Enable the default SSL site
# RUN a2ensite default-ssl


# Expose port 80 for HTTP and 443 for HTTPS
EXPOSE 80 443

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
