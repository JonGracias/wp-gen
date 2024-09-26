local M = {}
local utils = require("utils")

-- Function to duplicate the WordPress files
local function duplicate_files(paths, old_project_name, new_project_name)
    for _, path in pairs(paths) do
        local new_path = path:gsub(old_project_name, new_project_name)
        local copy_command = string.format("cp -r %s %s", path, new_path)
        utils.exec_command(copy_command, nil, 'Error: duplicate_files(paths, old_project_name, new_project_name)')
    end
    return true
end

function M.start(globals)
    local paths = {
        wp_base = globals.wp_base,
        wp_content = globals.wp_content,
    }

    io.write("Enter the new project name: ")
    local new_project_name = io.read()  

    ---------- Duplication -----------------------
    
    -- Duplicate the WordPress files
    utils.log("duplicate WordPress files")
    local success = duplicate_files(paths, globals.project_name, new_project_name)
    
    ----------------- pepare  ---------------------
    -- Initialize new global variabls
    globals.init(new_project_name, globals.creator_dir)

    -- Delete unique project files for new project
    local wp_content_to_delete = string.format("%s/wp-content",globals.wp_base)

    local paths_to_remove = {globals.wp_config, globals.etc_config, wp_content_to_delete}
    utils.delete_directories_and_files(paths_to_remove)

    -- New WordPress Installation ----------------------------------------------
    local new_apache_wordpress = require("models.apache_wordpress")
    new_apache_wordpress.start(globals)
    return true
end
return M