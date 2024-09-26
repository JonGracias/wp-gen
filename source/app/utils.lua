local M = {}
------------- execution ---------------------------------------------

-- Global flag for verbosity
M.verbose = false

-- Global flag for verbosity
M.project = "project"

-- Function to set verbosity
function M.set_verbose(flag)
    M.verbose = flag
end
-- Function to set verbosity
function M.set_project(name)
    M.project = name
end

local function escape_sql_input(input)
    -- Escape dangerous characters in the input
    return input:gsub("'", "\\'"):gsub('"', '\\"')
end

-- Function to log messages
function M.log(message, print_message)
    -- Ensure M.project is set
    if not M.project then
        error("M.project is nil. Please set the project name before logging.")
    end

    -- Construct the log file path
    local file = "./app/" .. M.project .. ".log"

    -- Try to open the log file for appending
    local log_file, err = io.open(file, "a")
    if not log_file then
        error("Error opening log file: " .. err)
    end

    -- Write the log message to the file
    log_file:write(message .. "\n")
    log_file:close()

    -- Optionally print the message
    if M.verbose or print_message then
        print(message)
    end
end


-- Function to log errors
function M.log_error(message)
    local file = "./app/" .. M.project .. ".error"
    -- Log to the error file
    local error_file = io.open(file, "a")
    error_file:write("ERROR: " .. message .. "\n")
    error_file:close()
    
    -- Also log to the general log file
    M.log("ERROR: " .. message, true)
    
    -- Exit the script
    os.exit(1)
end

-- Function to check if a group exists
function M.group_exists(group)
    local check_group_command = string.format("getent group %s", group)
    local handle = io.popen(check_group_command)
    local result = handle:read("*a")
    local success, _, _ = handle:close()
    return success and result:find(group) ~= nil
end

-- Function to check if a user is in a group
function M.user_in_group(user, group)
    local check_user_command = string.format("groups %s", user)
    local handle = io.popen(check_user_command)
    local result = handle:read("*a")
    local success, _, _ = handle:close()
    return success and result:find(group) ~= nil
end

-- Function to execute shell commands and capture the output
function M.exec_command(command, success_msg, error_msg)
    local handle = io.popen(command)
    local result = handle:read("*a"):gsub("\n", " "):gsub("%s+", " "):sub(1, 200)
    local exec_success, _, code = handle:close()
    local m_success = "success"
    local m_error = "error"

    
    if success_msg ~= nil then 
        m_success = success_msg
    end
    if error_msg ~= nil then
        m_error = error_msg
    end
    
    if exec_success or code == 0 then
        M.log(m_success, false)
    else
        local formatted_error_msg = string.format("%s\nCommand: %s\nExit code: %s\nOutput: %s", m_error, command, code or "N/A", result or "N/A")
        M.log_error(formatted_error_msg, true)
    end
end

-------- files ---------------------------------------------

function M.create_file(content, path)
    if M.doesFileExist(path) then
        M.log(string.format("File '%s' already exists.",path))
    else
        -- Ensure the directory exists
        local dir = path:match("(.*/)")
        local create_directory_command = string.format("mkdir -p %s", dir)
        M.exec_command(create_directory_command, "Directory created.", "Error creating directory: ")

        -- Save the content to the config file
        M.log(string.format("Creating %s",path), true)
        local temp_config_path = "/tmp/config_temp.php"
        local file = io.open(temp_config_path, "w")

        if file then
            file:write(content)
            file:close()
            local command = string.format("mv %s %s", temp_config_path, path)
            local success = string.format("Succesfully created %s.", path)
            local error = string.format("Error creating %s: ", path)
            M.exec_command(command, success, error)
        else
            M.log_error(string.format("%s Does not exist utils.lua:62", temp_config_path))
        end
    end
end

-- Function to check if a directory exists using os.execute
function M.doesDirectoryExist(path)
    local command = string.format("test -d %s", path)
    local result = os.execute(command)
    return result == true or result == 0
end

-- Function to check if a file exists using os.execute
function M.doesFileExist(path)
    local command = string.format("test -f %s", path)
    local result = os.execute(command)
    return result == true or result == 0
end

-- Function to validate the symlink
function M.validateSymlink(link_path, target_path)
    local command = string.format("readlink -e %s", link_path)
    local handle = io.popen(command)
    
    if not handle then
        M.log_error("Error: Failed to execute readlink command.")
        return
    end
    
    local result = handle:read("*a"):gsub("\n", "")
    local success, exit_code = handle:close()

    if success and result ~= "" then
        if result == target_path then
            M.log("Symlink is valid.")
        else
            M.log_error("Error: Symlink does not point to the correct target. Expected: " .. target_path .. ", but got: " .. result)
        end
    else
        M.log_error("Error: Failed to read symlink or symlink is invalid. Exit code: " .. tostring(exit_code) .. ". Command: " .. command)
    end
end

-- Delete files
function M.delete_directories_and_files(paths_to_remove)
    for _, path in ipairs(paths_to_remove) do
        local command = string.format("rm -rf %s", path)
        local success = string.format("Successfully removed %s.", path)
        local error = string.format("Error removing %s: ", path)
        M.exec_command(command, success, error)
    end
end

-- TIME TO HANDLE SQL INJECTIONS!!!! THEN FIX ALL UTILS.EXEC_COMMANDS AND REMOVE ANY CALLS TO VALIDATE
return M
