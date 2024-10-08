-- main.lua
-- Set the path of the script to /home/<usr>/wordpress
local function get_script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
local script_path = get_script_path()
package.path = package.path .. ";" .. script_path .. "?.lua"

-- Load the required modules
local child = require("globals")
local html = require("html")
local utils = require("utils")
local globals = {}
local new_apache_wordpress = require("models.apache_wordpress")


----- Ensure webmasters -----

-- Commands to execute if checks pass
local create_webmasters = "sudo groupadd webmasters"
local add_current_user_to_webmasters = "sudo usermod -aG webmasters $USER"
local add_www_data_to_webmasters = "sudo usermod -aG webmasters www-data"

-- Check if group 'webmasters' exists
if not utils.group_exists("webmasters") then
    utils.exec_command(create_webmasters, "Created webmasters group", "Error creating webmasters group")
else
    utils.log("Group 'webmasters' already exists.")
end

-- Check if the current user is in the 'webmasters' group
if not utils.user_in_group(os.getenv("USER"), "webmasters") then
    utils.exec_command(add_current_user_to_webmasters, "Added current user to webmasters group", "Error adding current user to webmasters group")
else
    utils.log("Current user is already in 'webmasters' group.")
end

-- Check if 'www-data' user is in the 'webmasters' group
if not utils.user_in_group("www-data", "webmasters") then
    utils.exec_command(add_www_data_to_webmasters, "Added www-data to webmasters group", "Error adding www-data to webmasters group")
else
    utils.log("'www-data' is already in 'webmasters' group.")
end


-- Command Line Arguments ---------------------------------------------------------------------
-- Check if a project name was passed as a command-line argument
if not arg[1] then
    utils.log("Usage: wordpress <project_name>", true)
    os.exit(1)
end

-- Initialize the project name from the command-line argument
local project_name = arg[1]

-- Initialize globals
if project_name == 'html' then
    globals = html.init(script_path)
    new_apache_wordpress = require("html.apache_wordpress")
else
    globals = child.init(project_name, script_path)
    new_apache_wordpress = require("models.apache_wordpress")
end

-- Handle verbose mode
local verbose = false
if arg[2] == '-v' or arg[3] == '-v' then
    verbose = true
    utils.set_verbose(true)
end

-- Init logging file
local create_log_dir = "mkdir -p  /etc/wp-gen/"
local init_data = string.format("CURRENT PROJECT: %s %s Verbose: %s", os.date("%Y-%m-%d %H:%M:%S"), project_name, verbose)
utils.project = project_name
local success = utils.exec_command(create_log_dir, init_data, "Error creating '/etc/wp-gen'")

-- Check for the second command-line argument and handle menu options
if arg[2] and arg[2] ~= "-v" then
    if utils.database_exists(globals.db_name) or (arg[3] == '-f' or arg[4] == '-f') then
        utils.log("Starting Menu", true)
        local menu = require("menu.menu")
        menu.options(arg[2], globals)
        os.exit(0)
    end
    utils.log("Error: Database " .. globals.db_name .. " does not exist.", true)
    os.exit(0)
end

-- New WordPress Installation ----------------------------------------------

local success = new_apache_wordpress.start(globals)
if success then
    local url = globals.site_url
    local site_ready = "Site can be reach at " .. url
    utils.log(site_ready, true)
end
