local download_wordpress = {}
local utils = require("utils")

function download_wordpress.downloadAndInstall(globals)
    local project_name = globals.project_name
    local wp_base = globals.wp_base
    local wp_config = globals.wp_config
    local wp_latest_url = "https://wordpress.org/latest.tar.gz"

    -- Check if WordPress is already installed  
    if utils.doesDirectoryExist(wp_base) then
        utils.log(string.format("WordPress is already installed at %s.", wp_base))
    else
        -- Download the latest WordPress archive
        utils.log("Downloading WordPress")
        local downloadCommand = string.format("wget -O /tmp/latest.tar.gz %s > /dev/null 2>&1", wp_latest_url)
        utils.exec_command(downloadCommand, nil, 'Error: download_wordpress')

        -- Extract the archive to the desired location
        utils.log("Extracting WordPress")
        local extractCommand = string.format("sudo tar -xzvf /tmp/latest.tar.gz -C /var/www/ > /dev/null 2>&1")
        utils.exec_command(extractCommand, nil, 'Error: download_wordpress')

        -- Move the extracted WordPress files to the project directory
        utils.log(string.format("Moving WordPress to %s", wp_base))
        local moveCommand = string.format("sudo mv /var/www/wordpress %s", wp_base)
        utils.exec_command(moveCommand, nil, 'Error: download_wordpress')

        -- Remove the downloaded archive
        utils.log("Removing download archive")
        local removeCommand = "rm /tmp/latest.tar.gz"
        utils.exec_command(removeCommand, nil, 'Error: download_wordpress')
    end

    local wp_config_content = string.format([[
<?php
/***
 * WordPress's Debianised default master config file
 * Please do NOT edit and learn how the configuration works in
 * /usr/share/doc/wordpress/README.Debian
 ***/

/* Look up a host-specific config file in
 * /etc/wordpress/config-%s.php or /etc/wordpress/config-<domain>.php
 */
$debian_file = '/etc/wordpress/config-%s.php';

if (file_exists($debian_file)) {
    require_once($debian_file);
    define('DEBIAN_FILE', $debian_file);
} else {
    header("HTTP/1.0 404 Not Found");
    echo "<b>$debian_file</b> could not be found. <br/> Ensure it exists, is readable by the webserver, and contains the right password/username.";
    exit(1);
}

/* Switch off automatic updates (should be done by package update) */
if (!defined('wp_auto_update_core'))
    define( 'wp_auto_update_core', false );

/* Default value for some constants if they have not yet been set
   by the host-specific config files */
if (!defined('ABSPATH'))
    define('ABSPATH', '/usr/share/wordpress/');
if (!defined('WP_AUTO_UPDATE_CORE'))
    define('WP_AUTO_UPDATE_CORE', false);
if (!defined('WP_ALLOW_MULTISITE'))
    define('WP_ALLOW_MULTISITE', true);
if (!defined('DB_NAME'))
    define('DB_NAME', 'wordpress');
if (!defined('DB_USER'))
    define('DB_USER', 'wordpress');
if (!defined('DB_HOST'))
    define('DB_HOST', 'localhost');
if (!defined('WP_CONTENT_DIR') && !defined('DONT_SET_WP_CONTENT_DIR'))
    define('WP_CONTENT_DIR', '/var/lib/wordpress/wp-content');

/* Default value for the table_prefix variable so that it doesn't need to
   be put in every host-specific config file */
if (!isset($table_prefix)) {
    $table_prefix = 'wp_';
}

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
    $_SERVER['HTTPS'] = 'on';

require_once(ABSPATH . 'wp-settings.php');
define('FS_METHOD', 'direct');
?>
]], project_name, project_name)
    utils.create_file(wp_config_content, wp_config)

    -- Setting permissions
    local set_permissions = require("models.set_permissions")
    set_permissions.setAllPermissions(wp_base)

    return true
end

return download_wordpress
