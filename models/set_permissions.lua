-- lib/set_permissions.lua
local set_permissions = {}
local utils = require("utils")

-- Function to set permissions and ownership for files
function set_permissions.setPermissions(files, dirs)
    -- Set permissions and ownership for files
    if files and #files > 0 then
        for _, file in ipairs(files) do
            local chmodCommand = string.format("sudo chmod 644 %s", file)
            utils.exec_command(chmodCommand, 'set_permissions.setPermissions(files, dirs)', 'Error: set_permissions.setPermissions(files, dirs)')

            local chownCommand = string.format("sudo chown www-data:webmasters %s", file)
            utils.exec_command(chownCommand, 'set_permissions.setPermissions(files, dirs)', 'Error: set_permissions.setPermissions(files, dirs)')
        end
    end

    -- Set permissions and ownership for directories
    if dirs and #dirs > 0 then
        for _, dir in ipairs(dirs) do
            local chmodCommand = string.format("sudo chmod 755 %s", dir)
            utils.exec_command(chmodCommand, 'set_permissions.setPermissions(files, dirs)', 'Error: set_permissions.setPermissions(files, dirs)')

            local chownCommand = string.format("sudo chown -R www-data:webmasters %s", dir)
            utils.exec_command(chownCommand, 'set_permissions.setPermissions(files, dirs)', 'Error: set_permissions.setPermissions(files, dirs)')
        end
    end
    
    return true
end

-- Function to set permissions and ownership for all files and directories recursively
function set_permissions.setAllPermissions(dir)
    local chmodCommand = string.format("sudo chmod -R 755 %s", dir)
    utils.exec_command(chmodCommand, 'set_permissions.setAllPermissions(dir)', 'Error: set_permissions.setAllPermissions(dir)')

    local chownCommand = string.format("sudo chown -R www-data:webmasters %s", dir)
    utils.exec_command(chownCommand, 'set_permissions.setAllPermissions(dir)', 'Error: set_permissions.setAllPermissions(dir)')

    return true
end
return set_permissions
