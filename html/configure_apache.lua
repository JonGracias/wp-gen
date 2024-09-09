local configure_apache = {}
local utils = require("utils")

function configure_apache.configureApache(globals)
    local apache_config = globals.apache_config
    local apache_ssl_config = globals.apache_ssl_config
    local wp_install_dir = globals.wp_base
    local wp_content_dir = globals.wp_content
    local project_name = globals.project_name
    local url = globals.site_url
    local success, message = false, "Default Message"

    -- Create Apache configuration content
    local apache_content = string.format([[
<VirtualHost *:80>
    DocumentRoot /var/www/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
]], project_name, wp_install_dir, wp_install_dir, wp_content_dir)

    -- Create Apache configuration content
    local apache_ssl_content = string.format([[
<IfModule mod_ssl.c>
<VirtualHost _default_:443>
    ServerAdmin datakiin@datakiin
    DocumentRoot /var/www/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateFile /etc/ssl/private/ssl-cert-snakeoil.key

    <FilesMatch "\.(cgi|shtml|phtml|php$")>
        SSLOptions +StdEnvVars
    </FilesMatch>
    <Directory /usr/lib/cgi-bin>
        SSLOptions +StdEnvVars
    </Directory>

    BrowseMatch "MSIE [2-6]" \
        nokeepalive ssl-unclean-shutdown \
        downgrade-1.0 force-response-1.0
    #MSIE 7 and newer should be able to use keepaline
    BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
</VirtualHost>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
]], project_name, wp_install_dir, wp_install_dir, wp_content_dir)
    
    -- Create content file
    utils.create_file(apache_content, apache_config)
    utils.create_file(apache_ssl_content, apache_ssl_config)
    -- Enable the site and reload Apache
    local enableSiteCommand = "a2ensite 000-default"
    local enableSSLSiteCommand = "a2ensite default-ssl"
    local reloadApacheCommand = "systemctl reload apache2"
    utils.exec_command(enableSiteCommand, nil, 'Error: enableSiteCommand')
    utils.exec_command(enableSSLSiteCommand, nil, 'Error: enableSSLSiteCommand')
    utils.exec_command(reloadApacheCommand, nil, 'Error: reloadApacheCommand')

    return true
end

return configure_apache
