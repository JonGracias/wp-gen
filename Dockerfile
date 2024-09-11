# Start from the official WordPress image
FROM wordpr
ess:latest

# Install dependencies for PHP extensions and other required packages
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    libzip-dev \
    libicu-dev \
    libmagickwand-dev \
    php-cli \
    php-curl \
    php-json \
    php-mbstring \
    php-xml \
    php-zip \
    python3-pip \
    wget \
    curl \
    lua5.4 \
    iputils-ping \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

# Configure and install the gd extension
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp && \
    docker-php-ext-install gd

# Install the intl extension
RUN docker-php-ext-install intl

# Install imagick via PECL and enable it
RUN pecl install imagick && docker-php-ext-enable imagick

# Ensure /etc/wordpress exists
RUN mkdir /etc/wordpress

# Set the ServerName globally to suppress the warning
RUN echo "ServerName Apache2_Wordpress" | tee /etc/apache2/conf-available/servername.conf && \
    a2enconf servername

# Enable the rewrite Apache module
RUN a2enmod rewrite

# Expose ports 80 (HTTP) and 443 (HTTPS)
EXPOSE 80 443

# Use the default command to run Apache in the foreground
CMD ["apache2-foreground"]
