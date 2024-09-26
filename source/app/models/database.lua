-- lib/database.lua
local db = {}
local utils = require("utils")
-- Use globals for database name, user, and password

-- Function to create a new database
function db.create_database(db_name)
    local command = string.format(
        "mysql -h wordpress_db -P 3307 -u root -p'password' -e \"CREATE DATABASE IF NOT EXISTS %s\"",
        db_name
    )
    local success = string.format("%s database is ready",db_name)
    local error = string.format("%s has a problem: ",db_name)
    utils.exec_command(command, success, error)
end

-- Function to check if MySQL user exists
function db.create_user(username, password)
    local checkUserCommand = string.format("mysql -u root -ppassword -e \"SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '%s')\"", username)
    local handle = io.popen(checkUserCommand)
    local result = handle:read("*a")
    local success, _, _ = handle:close()

    -- Check if the user exists by looking for '1' in the result
    local user_exists = result:match("0") == nil

    if success and user_exists then
        utils.log(string.format("User '%s' already exists. Skipping user creation.", username))
    else
        -- Create the database user with the provided password
        local createUser = string.format("CREATE USER '%s'@'localhost' IDENTIFIED BY '%s';", username, password)
        local createUserCommand = string.format("mysql -u root -ppassword -e \"%s\"", createUser)
        local success_msg = string.format("%s user created successfully", username)
        local error_msg = string.format("%s user could not be created", username)
        utils.exec_command(createUserCommand, success_msg, error_msg)
    end
end

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
-------- database -------------------------------------
-- Function to check if the database exists using MySQL command
function M.database_exists(db_name)
    local check_command = string.format("mysql --silent --skip-column-names -e 'SHOW DATABASES LIKE \"%s\";'", db_name)
    local handle = io.popen(check_command)
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

-- Setup database
utils.log("Setting up database...", true)
success = setup_database.setupDatabase(globals)
if success then
    utils.log("Database setup completed.", true)
end

function db.setupDatabase(globals)
    db_name = globals.db_name
    db_user = globals.db_user
    db_password = globals.db_password
    db_host = globals.db_host
    -- Create the database
    db.create_database(db_name)
    -- Check if the user already exists
    -- db.create_user(db_user, db_password)

    -- -- Grant privileges to the user
    -- local grantPrivileges = string.format("GRANT ALL PRIVILEGES ON %s.* TO '%s'@'%s';", db_name, db_user, db_host)
    -- local grantPrivilegesCommand = string.format("mysql -e \"%s\"", grantPrivileges)
    -- utils.exec_command(grantPrivilegesCommand, nil, 'Error: setup_database')

    -- -- Flush the privileges
    -- local flushPrivileges = "FLUSH PRIVILEGES;"
    -- local flushPrivilegesCommand = string.format("mysql -e \"%s\"", flushPrivileges)
    -- utils.exec_command(flushPrivilegesCommand, nil, 'Error: setup_database')
    return true
end

-- Function to duplicate the database
local function duplicate_database(title, old_db_name, new_db_name)
    -- Create the new database
    utils.create_database(new_db_name)

    -- Copy old database into new database
    local duplicate_db_command = string.format(
        "mysqldump  %s | mysql  %s",
         old_db_name,  new_db_name
    )
    utils.exec_command(duplicate_db_command, nil, 'Error: duplicate_database(title, old_db_name, new_db_name)')

    -- Update the site title in the new database
    local update_title_command = string.format(
        "mysql -e \"UPDATE wp_options SET option_value = '%s' WHERE option_name = 'blogname';\" %s",
        title, new_db_name
    )
    utils.exec_command(update_title_command, nil, 'Error: duplicate_database(title, old_db_name, new_db_name)')
end

    -- Delete db if exists
    utils.log("Deleting database")
    local delete_db_command = string.format(
        "mysql %s -e \"DROP DATABASE IF EXISTS %s\"",
        db_creds, db_name
    )
    -- Deleting database
    utils.exec_command(delete_db_command, nil, 'Error: purge.lua')

return db
