-- lib/setup_database.lua
local setup_database = {}
local utils = require("utils")

function setup_database.setupDatabase(globals)
    -- Use globals for database name, user, and password
    local db_name = globals.db_name
    local db_user = globals.db_user
    local db_password = globals.db_password

    -- Create the database
    utils.create_database(db_name)
    -- Check if the user already exists
    utils.create_user(db_user, db_password)

    -- Grant privileges to the user
    local grantPrivileges = string.format("GRANT ALL PRIVILEGES ON %s.* TO '%s'@'localhost';", db_name, db_user)
    local grantPrivilegesCommand = string.format("sudo mysql -e \"%s\"", grantPrivileges)
    utils.exec_command(grantPrivilegesCommand, nil, 'Error: setup_database')

    -- Flush the privileges
    local flushPrivileges = "FLUSH PRIVILEGES;"
    local flushPrivilegesCommand = string.format("sudo mysql -e \"%s\"", flushPrivileges)
    utils.exec_command(flushPrivilegesCommand, nil, 'Error: setup_database')
    return true
end

return setup_database
