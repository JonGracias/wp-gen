#!/bin/bash

# Use tee to append the sudoers rule without redirect permission issues
echo 'www-data ALL=(ALL) NOPASSWD: /app/main.lau' | /usr/bin/sudo /usr/bin/tee -a /etc/sudoers.d/custom-script > /dev/null

# Set correct permissions for the new sudoers file
/bin/chmod 440 /etc/sudoers.d/custom-script

