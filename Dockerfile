# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set non-interactive mode for apt to prevent prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install required packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y apache2 mysql-server php libapache2-mod-php php-mysql php-cli php-curl php-json php-mbstring php-xml php-zip \
    python3-pip wget curl lua5.4 sudo

# Run the mkdir command as root to create the /etc/wp-gen/ directory
RUN mkdir /etc/wp-gen/

# Add a non-root user (datakiin) and grant sudo without a password
RUN groupadd -r datakiin && useradd -r -g datakiin datakiin && \
    echo 'datakiin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change ownership of Apache log directory so the datakiin user can write logs
RUN chown -R datakiin:datakiin /var/log/apache2/


# Copy wp-gen to the /app directory
COPY ./wp-gen/ /app/

# Install MySQL, configure it to run without a password
RUN echo "mysql-server mysql-server/root_password password ''" | sudo debconf-set-selections && \
echo "mysql-server mysql-server/root_password_again password ''" | sudo debconf-set-selections && \
sudo apt-get install -y mysql-server

# Enable Apache modules for SSL and PHP 8.1
RUN sudo a2enmod ssl && sudo a2enmod php8.1

# Expose port 80 for HTTP and 443 for HTTPS
EXPOSE 80 443

# Start MySQL and Apache services using apachectl
CMD ["apachectl", "-D", "FOREGROUND"]
