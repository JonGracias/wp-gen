local M = {}
local utils = require("utils")

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

-- Function to duplicate the WordPress files
local function duplicate_files(paths, old_project_name, new_project_name)
    for _, path in pairs(paths) do
        local new_path = path:gsub(old_project_name, new_project_name)
        local copy_command = string.format("sudo cp -r %s %s", path, new_path)
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
    local new_db_name = utils.format_db_name(new_project_name)    

    ---------- Duplication -----------------------
    -- Duplicate the database
    utils.log("duplicating database")
    local success = duplicate_database(new_project_name, globals.db_name, new_db_name)
    
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