local M = {}
local utils = require("utils")
local db = require("models.database")

local function create_backups_table_if_not_exists()
    -- Ensure the backup_records_db exists
    db.create_database("backup_records_db")
    -- SQL command to create or update the backups table with a comment column
    local sql_command = 
        [[
        mysql -e "
        USE backup_records_db;
        CREATE TABLE IF NOT EXISTS backups (
            id INT AUTO_INCREMENT PRIMARY KEY,
            project_name VARCHAR(255) NOT NULL,
            backup_date DATETIME NOT NULL,
            files_backup_location VARCHAR(1024) NOT NULL,
            database_backup_location VARCHAR(1024) NOT NULL,
            comment TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        "]]
    -- Execute the SQL command
    utils.exec_command(sql_command, nil, 'Error: create_backups_table_if_not_exists()')
end

local function backup_database(globals)
    -- Backup database
    local db_name = globals.db_name
    local db_backup_file = globals.db_backup_file
    local db_backup_command = string.format("mysqldump %s > %s 2>/dev/null", db_name, db_backup_file)
    utils.exec_command(db_backup_command, nil, 'Error: backup_database(globals)')
end

local function backup_files(globals)
    -- Backup files
    local wp_base = globals.wp_base
    local wp_content = globals.wp_content
    local etc_config = globals.etc_config
    local apache_config = globals.apache_config
    local files_backup_dir = globals.files_backup_dir
    local tar_command = string.format([[tar -czf %s -C / %s %s %s %s 2>/dev/null]]
    ,files_backup_dir, wp_base, wp_content, etc_config, apache_config)
    utils.exec_command(tar_command, nil, 'Error: backup_files(globals)')
end

local function insert_backup_record(globals)
    local project_name = globals.project_name
    local files_backup_dir = globals.files_backup_dir
    local db_backup_file = globals.db_backup_file

    -- Ask the user for a comment about the backup
    io.write("Enter a comment or note for this backup: ")
    local comment = io.read()

    -- Insert into the backup_records_db
    local sql_command = string.format([[
        mysql -e "USE backup_records_db;
        INSERT INTO backups (project_name, backup_date, files_backup_location, database_backup_location, comment) 
        VALUES ('%s', NOW(), '%s', '%s', '%s');"
        ]], project_name, files_backup_dir, db_backup_file, comment)
        
    -- Execute the SQL command
    utils.exec_command(sql_command, nil, 'Error: insert_backup_record(globals)')
end

function M.start(globals)
    -- Ensure the backup directory exists
    utils.log("Initiliazing back up database")
    local create_backup_dir_command = "mkdir -p " .. globals.date_dir
    local success = utils.exec_command(create_backup_dir_command, nil, 'Error: backup.lua')

    -- Ensure the backups table exists
    utils.log("Ensuring the 'backups' table exists")
    local success = create_backups_table_if_not_exists(globals)

    -- Perform database backup
    utils.log("Backing up database")
    local success = backup_database(globals)

    -- Perform WordPress files backup
    utils.log("Copying WordPress files")
    local success = backup_files(globals)

    -- Insert into backup database
    utils.log(" Saving backup record ")
    local success = insert_backup_record(globals)
    return true
end

return M
