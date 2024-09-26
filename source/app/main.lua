-- main.lua
print('hello from main.lua')
-- Set the path of the script to /home/<usr>/wordpress
local function get_script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end

-- Make sure the path '.' holds the 'app' folder
local script_path = './app/'
package.path = package.path .. ";" .. script_path .. "?.lua"

-- Load the required modules
local child = require("globals")
local utils = require("utils")
local globals = {}
local new_apache_wordpress = require("models.apache_wordpress")


-- Command Line Arguments ---------------------------------------------------------------------
-- Check if a project name was passed as a command-line argument
if not arg[1] then
    utils.log("Usage: wordpress <project_name>", true)
    os.exit(1)
end

-- Initialize the project name 
local project_name = arg[1]
-- Initialize the globals
globals = child.init(project_name, script_path)

-- Handle verbose mode
if arg[2] == 'true' or arg[3] == 'true' then
    utils.set_verbose(true)
end

-- Init logging file 
-- Currently not possible have to add SUDO COMMAND can use as test
local create_log_dir = "mkdir -p  /etc/wp-gen/"
local init_data = string.format("CURRENT PROJECT: %s %s Verbose: %s", os.date("%Y-%m-%d %H:%M:%S"), project_name, utils.verbose)
utils.project = project_name
local success = utils.exec_command(create_log_dir, init_data, "Error creating '/etc/wp-gen'")

-- Check for the second command-line argument and handle menu options
if arg[2] and arg[2] ~= "true" then
    utils.log("Starting Menu", true)
    local menu = require("menu.menu")
    menu.options(arg[2], globals)
    os.exit(0)
end

-- New WordPress Installation ----------------------------------------------

local success = new_apache_wordpress.start(globals)
if success then
    local url = globals.site_url
    local site_ready = "Site can be reach at " .. url
    utils.log(site_ready, true)
end
