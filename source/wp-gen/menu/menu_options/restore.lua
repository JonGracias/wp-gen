local M = {}
local utils = require("utils")
local backup_list = {}
local selection = nil

local function list_backups(globals)
    local _ = false
    local sql_command = string.format(
        "mysql -e 'USE backup_records_db; SELECT id, comment, backup_date, files_backup_location, database_backup_location FROM backups WHERE project_name=\"%s\"'",
        globals.project_name
    )
    -- Execute the SQL command
    local handle = io.popen(sql_command)
    local result = handle:read("*a")
    local success, _, code = handle:close()
    utils.log(result)
    backup_list = result
    return true
end

local function prompt_user_for_backup_selection()
    utils.log("Available backups:")
    local backups = {}
    for line in backup_list:gmatch("[^\r\n]+") do
        table.insert(backups, line)
    end

    -- If there are no backups other than the header line
    if #backups <= 1 then
        utils.log_error("No backups found for the project.")
    end

    -- Skip the header line and start displaying backups with only the comment and date
    for i = 2, #backups do
        local backup_details = {}
        for value in backups[i]:gmatch("[^\t]+") do
            table.insert(backup_details, value)
        end

        utils.log(string.format("[%d] %s - %s", i - 1, backup_details[2], backup_details[3]))
    end

    io.write("Enter the number corresponding to the backup you want to restore: ")
    local choice = tonumber(io.read())
    
    if choice and choice > 0 and choice <= (#backups - 1) then
        selection = backups[choice + 1]
    else
        utils.log("Invalid selection. Please try again.")
        prompt_user_for_backup_selection()
    end
end

local function restore_backup(globals)
    -- Parse the selected backup details
    local backup_details = {}
    for value in selection:gmatch("[^\t]+") do
        table.insert(backup_details, value)
    end

    local files_backup_location = backup_details[4]
    local database_backup_location = backup_details[5]
    utils.create_database(globals.db_name)

    -- Restore the database
    local db_restore_command = string.format("mysql %s < %s", globals.db_name, database_backup_location)
    utils.log("Restoring database")
    utils.exec_command(db_restore_command, nil, 'Error: restore_backup(globals)')


    -- Restore the files
    local files_restore_command = string.format("tar -xzf %s -C /", files_backup_location)
    utils.log("Restoring files")
    utils.exec_command(files_restore_command, nil, 'Error: restore_backup(globals)')

    -- Make sure .conf is enable
    local configure_apache = require("models.configure_apache")
    configure_apache.configureApache(globals)
end

function M.start(globals)
    list_backups(globals)
    prompt_user_for_backup_selection(backup_list)
    restore_backup(globals)
    return true
end
return M
