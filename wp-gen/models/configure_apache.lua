local configure_apache = {}
local utils = require("utils")

function configure_apache.configureApache(globals)
    local apache_config = globals.apache_config
    local wp_install_dir = globals.wp_base
    local wp_content_dir = globals.wp_content
    local project_name = globals.project_name
    local url = globals.site_url
    local success, message = false, "Default Message"

    -- Create Apache configuration content
    local apache_content = string.format([[
Alias /%s %s
<Directory %s>
    Options FollowSymLinks
    AllowOverride Limit Options FileInfo
    DirectoryIndex index.php
    Order allow,deny
    Allow from all
</Directory>

<Directory %s>
    Options FollowSymLinks
    Order allow,deny
    Allow from all
</Directory>

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
]], project_name, wp_install_dir, wp_install_dir, wp_content_dir)
    utils.create_file(apache_content, apache_config)

    -- Enable the site and reload Apache
    local enableSiteCommand = string.format("a2ensite %s.conf", project_name)
    local reloadApacheCommand = "systemctl reload apache2"
    utils.exec_command(enableSiteCommand, nil, 'Error: enableSiteCommand')
    utils.exec_command(reloadApacheCommand, nil, 'Error: reloadApacheCommand')

    return true
end

return configure_apache
