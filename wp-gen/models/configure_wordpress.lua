local configure_wordpress = {}
local utils = require("utils")
local set_permissions = require("models.set_permissions")

function configure_wordpress.configureWordpress(globals)
    local wp_content = globals.wp_content
    local etc_config = globals.etc_config
    local db_name = globals.db_name
    local db_user = globals.db_user
    local db_password = globals.db_password
    local wp_base = globals.wp_base 
    local site_url = globals.site_url

    utils.log("Creating wp_content")
    if not utils.doesDirectoryExist(wp_content) then
        -- Create the wp-content directory and move contents
        utils.exec_command(string.format("sudo mkdir -p %s", wp_content),
            nil, 'Error: configure_wordpress.configureWordpress(globals)')

        set_permissions.setAllPermissions(wp_content)

        utils.exec_command(string.format("sudo mv %s/wp-content %s/", wp_base, wp_content),
            nil, 'Error: configure_wordpress.configureWordpress(globals)')
    end
    
    utils.log("Creating symlink")
    -- Create or recreate the symlink
    utils.exec_command(string.format("sudo ln -sf %s/wp-content %s/wp-content", wp_content, wp_base),
        nil, 'Error: configure_wordpress.configureWordpress(globals)')
    -- Validate the symlink
    utils.validateSymlink(string.format("%s/wp-content", wp_base), string.format("%s/wp-content", wp_content))

    local config_content = string.format([[
<?php
define('DB_NAME', '%s');
define('DB_USER', '%s');
define('DB_PASSWORD', '%s');
define('DB_HOST', 'localhost');
define('WP_CONTENT_DIR', '%s/wp-content');
define('WP_DEFAULT_THEME', 'twentytwentyfour');
define('WP_AUTO_UPDATE_CORE', true);
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);
define('WP_HOME', '%s');
define('WP_SITEURL', '%s');
?>
]], db_name, db_user, db_password, wp_content, site_url, site_url)
    utils.create_file(config_content, etc_config)

    return true
end
return configure_wordpress
