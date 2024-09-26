local M = {}
local utils = require("utils")
local json = require("lib.dkjson")

local file_path = "wp-backups.json"

-- Function to read JSON file and return the data
local function read_json_file(file_path)
    local file = io.open(file_path, "r")
    if not file then
        -- If the file doesn't exist, return an empty table
        return {}
    end
    local content = file:read("*a")
    file:close()
    return json.decode(content) or {}
end

-- Function to write data to JSON file
local function write_json_file(file_path, data)
    local file = io.open(file_path, "w")
    if not file then
        error("Error: Unable to open file " .. file_path .. " for writing")
    end
    file:write(json.encode(data, { indent = true }))
    file:close()
end

local function backup_files(globals)
    -- Backup files
    local wp_base = globals.wp_base
    local wp_content = globals.wp_content
    local etc_config = globals.etc_config
    local apache_config = globals.apache_config
    local files_backup_dir = globals.files_backup_dir
    local tar_command = string.format([[tar -czf %s -C / %s %s %s %s 2>/dev/null]], 
        files_backup_dir, wp_base, wp_content, etc_config, apache_config)
    utils.exec_command(tar_command, nil, 'Error: backup_files(globals)')
end

local function insert_backup_record(globals)
    local project_name = globals.project_name
    local files_backup_dir = globals.files_backup_dir
    local db_backup_file = globals.db_backup_file

    -- Ask the user for a comment about the backup
    io.write("Enter a comment or note for this backup: ")
    local comment = io.read()

    -- Read existing backups from the JSON file
    local backups_data = read_json_file(file_path)

    -- Create a new backup entry
    local new_record = {
        project_name = project_name,
        backup_date = os.date("%Y-%m-%d %H:%M:%S"),  -- Current timestamp
        files_backup_location = files_backup_dir,
        database_backup_location = db_backup_file,
        comment = comment
    }

    -- Add the new record to the backups data
    table.insert(backups_data, new_record)

    -- Write the updated data back to the JSON file
    write_json_file(file_path, backups_data)

    print("Backup record successfully inserted into JSON file.")
end

function M.start(globals)
    -- Ensure the backup directory exists
    utils.log("Initializing backup directory")
    local create_backup_dir_command = "mkdir -p " .. globals.date_dir
    local success = utils.exec_command(create_backup_dir_command, nil, 'Error: backup.lua')

    -- Perform database backup
    utils.log("Backing up database")
    local success = backup_database(globals)

    -- Perform WordPress files backup
    utils.log("Copying WordPress files")
    local success = backup_files(globals)

    -- Insert into backup JSON file
    utils.log("Saving backup record to JSON")
    local success = insert_backup_record(globals)
    
    return true
end

return M
