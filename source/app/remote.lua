-- Lua FastCGI Script with JSON parsing

local json = require("lib.dkjson") -- Optional: If you don't want to use luarocks, consider a lightweight JSON parser

local function handle_request()
    local content_length = tonumber(os.getenv("CONTENT_LENGTH")) or 0
    local input = io.read(content_length) -- Read POST data

    -- Try to parse JSON data
    local data = json.decode(input)
    local project_name = data.project_name or "unknown"
    local command = data.command or "none"

    -- Process based on the command (e.g., "install", "delete")
    -- Add your business logic here

    local response = string.format("Content-Type: text/plain\n\nProcessed command: %s on project: %s\n", command, project_name)
    io.write(response)
end

handle_request()
