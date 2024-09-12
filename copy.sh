#!/bin/bash

# Create the necessary directories if they don't exist
mkdir -p /home/datakiin/wp-gen/source


# Copy the files to the new source folder

# wp-gen.cnf
cp -r /home/datakiin/wp-gen/wp-gen/config/wp-gen.cnf /home/datakiin/wp-gen/source/
# wp-gen app
cp -r /home/datakiin/wp-gen/wp-gen /home/datakiin/wp-gen/source/
# hosts
cp -r /etc/hosts /home/datakiin/wp-gen/source/
# wordpress config files
cp -r /etc/wordpress /home/datakiin/wp-gen/source/
# wordpress
cp -r /var/www/html /home/datakiin/wp-gen/source
# projects
cp -r /var/lib/projects /home/datakiin/wp-gen/source/
# apcache2 sites available
cp -r /etc/apache2/sites-available /home/datakiin/wp-gen/source/

echo "Files copied to /home/datakiin/wp-gen/source/"
