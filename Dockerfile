# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive mode for apt to prevent prompts
ENV DEBIAN_FRONTEND=noninteractive

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
    php-imagick \
    ssl-cert \
    libapache2-mod-fcgid \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Ensure /etc/wordpress exists
RUN mkdir /etc/wordpress

# Set the ServerName globally to suppress the warning
RUN echo "ServerName Wordpress_Generator" | tee /etc/apache2/conf-available/servername.conf && \
    a2enconf servername

# Enable Apache modules for SSL, PHP, and rewrite
RUN a2enmod php8.1 && a2enmod \
    rewrite \
    ssl \
    proxy \
    proxy_http \
    fcgid \
    actions

# Enable the default SSL site
RUN a2ensite default-ssl

# Expose port 80 for HTTP and 443 for HTTPS
EXPOSE 80 443

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
