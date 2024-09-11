local M = {}
local utils = require("utils")


-- MySQL command to update the WordPress user's password
local function update_password(db_name, wp_user, hash)
    local update_password_command = string.format(
        "mysql --silent --skip-column-names -e 'USE %s; UPDATE wp_users SET user_pass=\"%s\" WHERE user_login=\"%s\";' 2>/dev/null",
        db_name, hash, wp_user
    )
    utils.exec_command(update_password_command, nil, 'Error: update_password(db_name, wp_user, hash)')

end

-- Function to reset the WordPress user password
function M.start(globals)
    local db_name = globals.db_name
    io.write("Enter WP user name: ")
    local wp_user = io.read()
    io.write("Enter new password: ")
    local new_password = io.read()

    -- Generate the MD5 hash using the Python script
    local hash_command = string.format("python3 %slib/hash_generator.py %s",globals.creator_dir, new_password)
    local handle = io.popen(hash_command)
    local hash = handle:read("*a"):gsub("\n", "")
    local success, _, code = handle:close()
    
    update_password(db_name, wp_user, hash)

    return true, wp_user
end
return M
