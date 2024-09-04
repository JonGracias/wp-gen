local html = {}

-- Function to parse the .my.cnf file
local function parseMyCnf(file_path)
    local config = {}
    local file = io.open(file_path, "r")

    if not file then
        print("Error: Could not open .my.cnf file.")
        os.exit(1)
    end

    for line in file:lines() do
        local key, value = line:match("^(%w+)%s*=%s*(.+)$")
        if key and value then
            config[key] = value
        end
    end
    
    file:close()
    return config
end

-- Initialize html
function html.init(script_path)
    html.project_name = 'html'
    html.db_name = 'html'
    html.site_url = 'https://datakiin'
    
    -- Parse the .my.cnf file for MySQL credentials
    local cnf_path = "/home/datakiin/.my.cnf"
    local cnf = parseMyCnf(cnf_path)
    
    html.db_user = cnf["user"]
    html.db_password = cnf["password"]
    html.creator_dir = script_path 

    ---------------------------------------- Paths ----------------------------------------------
    html.wp_base = string.format("/var/www/%s", html.project_name)
    html.wp_content = string.format("/var/lib/projects/%s", html.project_name)
    html.etc_config = "/etc/wordpress/config-localhost.php"
    html.apache_config = "/etc/apache2/sites-available/000-default.conf"
    html.apache_ssl_config = "/etc/apache2/sites-available/default-ssl.conf"
    html.wp_config = string.format("%s/wp-config.php", html.wp_base)

    ---------------------------------------- Backup paths ---------------------------------------
    html.backup_dir = html.creator_dir .. "backups/" .. html.project_name .. "/"
    html.timestamp = os.date("%Y_%m_%d_%I:%M%p")
    html.date_dir = html.backup_dir .. html.timestamp .. "/"
    html.files_backup_dir = html.date_dir .. "_files_backup.tar.gz"
    html.db_backup_file = html.date_dir .. "_backup.sql"

    return html
end

return html
