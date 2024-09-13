local globals = {}


local function format_db_name(project_name)
    -- Remove non-alphanumeric characters and convert to lowercase
    local formatted_name = project_name:gsub("%W", ""):lower()
    return formatted_name
end

-- Initialize globals
function globals.init(project_name, script_path)
    globals.project_name = project_name
    globals.db_name = format_db_name(project_name)
    globals.base_url = 'http://localhost'
    globals.site_url = string.format("%s/%s", globals.base_url, project_name)
    globals.creator_dir = script_path
    
    -- Parse the .my.cnf file for database credentials
    -- It is neccessary to specify a host for phpmyadmin login
    globals.db_user = "root"
    globals.db_password = "password" 
    globals.db_host = "mysql"
    globals.db_conn = string.format("mysql -h %s -u %s -p%s", db_host, db_user, db_password)

    -- Define paths
    globals.wp_base = string.format("/var/www/%s", project_name)
    globals.wp_content = string.format("/var/lib/projects/%s", project_name)
    globals.etc_config = string.format("/etc/wordpress/config-%s.php", project_name)
    globals.apache_config = string.format("/etc/apache2/sites-available/%s.conf", project_name)
    globals.wp_config = string.format("%s/wp-config.php", globals.wp_base)

    -- Backup paths
    globals.backup_dir = globals.creator_dir .. "backups/" .. globals.project_name .. "/"
    globals.timestamp = os.date("%Y_%m_%d_%I:%M%p")
    globals.date_dir = globals.backup_dir .. globals.timestamp .. "/"
    globals.files_backup_dir = globals.date_dir .. "_files_backup.tar.gz"
    globals.db_backup_file = globals.date_dir .. "_backup.sql"

    return globals
end

return globals
