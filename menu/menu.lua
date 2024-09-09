-- lib/menu.lua

-- Require the menu options
local backup = require("menu.menu_options.backup")
local reset_password = require("menu.menu_options.reset_password")
local purge = require("menu.menu_options.purge")
local restore = require("menu.menu_options.restore")
local clone = require("menu.menu_options.clone")
local utils = require("utils")

local M = {}

function M.options(option, globals)
    local project_name = globals.project_name
    local success = false
    if option == "backup" then
        utils.log("Starting backup " .. project_name, true)
        success = backup.start(globals)
        if success then
            utils.log("Database setup completed.", true)
        end

    elseif option == "restore" then
        utils.log("Restoring " .. project_name, true)
        success = restore.start(globals)
        if success then
            utils.log("Restore completed.", true)
        end

    elseif option == "purge" then
        utils.log("Purging " .. project_name, true)
        success = purge.start(globals)
        if success then
            utils.log("Purge complete.", true)
        end

    elseif option == "clone" then
        utils.log("Cloning " .. project_name, true)
        success = clone.start(globals)
        if success then
            utils.log("Cloning completed.", true)
        end

    elseif option == "reset_password" then
        utils.log("Reseting password for " .. project_name, true)
        local reset_password_success, wp_user = reset_password.start(globals)
        if reset_password_success then
            utils.log("Password updated successfully for user" .. wp_user, true)
        end
    else
        utils.log("Invalid option. Please provide a valid option: backup, restore, purge, clone, or reset_password.")
    end
end

return M
