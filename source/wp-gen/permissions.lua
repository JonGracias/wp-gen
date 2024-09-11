-- lib/permissions.lua
local permissions = {}
local utils = require("utils")

-- Function to set permissions and ownership for files
function permissions.setPermissions(files, dirs)
    -- Set permissions and ownership for files
    if files and #files > 0 then
        for _, file in ipairs(files) do
            local chmodCommand = string.format("chmod 644 %s", file)
            utils.exec_command(chmodCommand, 'permissions.setPermissions(files, dirs)', 'Error: permissions.setPermissions(files, dirs)')

            local chownCommand = string.format("chown www-data:www-data %s", file)
            utils.exec_command(chownCommand, 'permissions.setPermissions(files, dirs)', 'Error: permissions.setPermissions(files, dirs)')
        end
    end

    -- Set permissions and ownership for directories
    if dirs and #dirs > 0 then
        for _, dir in ipairs(dirs) do
            local chmodCommand = string.format("chmod 755 %s", dir)
            utils.exec_command(chmodCommand, 'permissions.setPermissions(files, dirs)', 'Error: permissions.setPermissions(files, dirs)')

            local chownCommand = string.format("chown -R www-data:www-data %s", dir)
            utils.exec_command(chownCommand, 'permissions.setPermissions(files, dirs)', 'Error: permissions.setPermissions(files, dirs)')
        end
    end
    
    return true
end

-- Function to set permissions and ownership for all files and directories recursively
function permissions.setAllPermissions(dir)
    local chmodCommand = string.format("chmod -R 755 %s", dir)
    utils.exec_command(chmodCommand, 'permissions.setAllPermissions(dir)', 'Error: permissions.setAllPermissions(dir)')

    local chownCommand = string.format("chown -R www-data:www-data %s", dir)
    utils.exec_command(chownCommand, 'permissions.setAllPermissions(dir)', 'Error: permissions.setAllPermissions(dir)')

    return true
end
return permissions
