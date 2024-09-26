<?php
define('DB_NAME', 'html');
define('DB_USER', 'root');
define('DB_PASSWORD', 'password');
define('DB_HOST', 'wordpress_db');
define('WP_CONTENT_DIR', '/var/lib/projects/html/wp-content');
define('WP_DEFAULT_THEME', 'minimal');
define('WP_AUTO_UPDATE_CORE', true);
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
// Disable display of errors and warnings
define( 'WP_DEBUG_DISPLAY', false );
@ini_set( 'display_errors', 0 );
// Use dev versions of core JS and CSS files (only needed if you are modifying these core files)
define( 'SCRIPT_DEBUG', true );
define('WP_HOME', 'https://datakiin');
define('WP_SITEURL', 'https://datakiin');
?>
