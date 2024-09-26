-- Adapted for mod_lua

local script_path = '/app/'
package.path = package.path .. ";" .. script_path .. "?.lua"

-- Load required modules
local child = require("globals")
local utils = require("utils")
local new_apache_wordpress = require("models.apache_wordpress")
local json = require("lib.dkjson")
local globals = {}

function handle(r)
    r.content_type = "text/html"
    
    return apache2.OK
end
