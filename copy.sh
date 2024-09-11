#!/bin/bash

# Create the necessary directories if they don't exist
mkdir -p /home/datakiin/wp-gen/source
mkdir -p /home/datakiin/wp-gen/source/var-www-html

# Copy the files to the new source folder
cp -r /home/datakiin/wp-gen/wp-gen/config/wp-gen.cnf /home/datakiin/wp-gen/source/wp-gen.cnf
cp -r /home/datakiin/wp-gen/wp-gen /home/datakiin/wp-gen/source/
cp -r /etc/hosts /home/datakiin/wp-gen/source/hosts
cp -r /etc/wordpress /home/datakiin/wp-gen/source/wordpress
cp /var/www/html/wp-config.php /home/datakiin/wp-gen/source/var-www-html/wp-config.php
cp -r /var/lib/projects /home/datakiin/wp-gen/source/var-lib-projects
cp -r /etc/apache2/sites-available /home/datakiin/wp-gen/source/apache2-sites-available

echo "Files copied to /home/datakiin/wp-gen/source/"
