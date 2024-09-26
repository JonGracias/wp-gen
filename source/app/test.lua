print ("Content-type: text/html\n")
print("Cache-control: no-cache")
print("Pragma: no-cache")

local json = require "lib.dkjson"

-- This function is executed for every request
function handle(r)
    r.content_type = "application/json"
    
    -- Read the request body, assuming it contains JSON
    local request_body = r:requestbody()

    -- Parse the JSON input
    local success, json_data = pcall(json.decode, request_body)
    if not success then
        r:puts(json.encode({error = "Invalid JSON input"}))
        return apache2.HTTP_BAD_REQUEST
    end
    
    -- Extract fields from the JSON input
    local project_name = json_data.project_name or "default_project"
    local command = json_data.command or ""
    local verbose = json_data.verbose or ""

    
    -- Construct the command string with proper formatting
    local cmd = string.format("sudo lua /app/main.lua %s %s %s", project_name, command, verbose)
    
    -- Capture the output of the command using io.popen()
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    result = result or "No output returned"
    local handle_success, exec_type, exit_code = handle:close()

    -- Check if the command executed successfully
    if handle_success then
        -- Respond with JSON data containing the command output
        local response_data = {
            message = "Command executed successfully",
            project_name = project_name,
            command = cmd,
            verbose = verbose,
            output = result,
            exit_code = exit_code or "Unknown"
        }
        r:puts(json.encode(response_data))
    else
        -- Handle command failure
        local error_data = {
            error = "Command execution failed",
            project_name = project_name,
            command = command,
            verbose = verbose,
            output = result,
            exit_code = exit_code or "Unknown"
        }
        r:puts(json.encode(error_data))
    end

    return apache2.OK
end
