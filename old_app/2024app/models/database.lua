-- lib/database.lua
local db = {}
local utils = require("utils")
-- Use globals for database name, user, and password

-- Function to create a new database
function db.create_database(db_name)
    local command = string.format(
        "mysql  -e \"CREATE DATABASE IF NOT EXISTS %s\"",
         db_name
    )
    local success = string.format("%s database is ready",db_name)
    local error = string.format("%s has a problem: ",db_name)
    utils.exec_command(command, success, error)
end

-- Function to check if MySQL user exists
function db.create_user(username, password)
    local checkUserCommand = string.format("mysql -e \"SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '%s')\"", username)
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
        local createUserCommand = string.format("mysql -e \"%s\"", createUser)
        local success_msg = string.format("%s user created successfully", username)
        local error_msg = string.format("%s user could not be created", username)
        utils.exec_command(createUserCommand, success_msg, error_msg)
    end
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

return db
