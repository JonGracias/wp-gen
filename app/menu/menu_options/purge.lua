local M = {}

local utils = require("utils")
function M.start(globals)
    local project_name = globals.project_name
    local db_name = globals.db_name
    local wp_base = globals.wp_base
    local wp_content = globals.wp_content
    local wp_config = globals.etc_config
    local apache_config = globals.apache_config
    local logs = "/etc/wp-gen/" .. utils.project .. ".log"

    -- Delete db if exists
    utils.log("Deleting database")
    local delete_db_command = string.format(
        "mysql  -e \"DROP DATABASE IF EXISTS %s\"",
        db_name
    )
    -- Deleting database
    utils.exec_command(delete_db_command, nil, 'Error: purge.lua')

    -- Disable the Apache site
    utils.log("Disabling Apache site...")
    local command = string.format("a2dissite %s.conf",project_name)
    local handle = io.popen(command)
    local result = handle:read("*a"):gsub("\n", " "):gsub("%s+", " "):sub(1, 200)
    local exec_success, _, code = handle:close()

    -- NO SYSTEMCTL RELOAD DOCKER INSTEAD
    -- -- Reload Apache configuration
    -- utils.log("Reloading Apache configuration...")
    -- utils.exec_command("systemctl reload apache2", nil, 'Error: purge.lua')

    -- Remove directories and files
    utils.log("Removing directories and files")
    local paths_to_remove = {wp_base, wp_content, wp_config, apache_config}
    utils.delete_directories_and_files(paths_to_remove)
    return true
end

return M
