local M = {}

function M.start(globals)
    -- Load additional modules
    local wp_base = globals.wp_base
    local configure_wordpress = require("models.configure_wordpress")
    local configure_apache = require("models.configure_apache")
    local download_wordpress = require("models.download_wordpress")
    local utils = require("utils")
    local success = false

    -- Download and install WordPress
    utils.log("Downloading and installing WordPress...", true)
    success = download_wordpress.downloadAndInstall(globals)
    if success then
        utils.log(string.format("WordPress installed at %s", wp_base), true)
    end

    -- Configure WordPress
    utils.log("Configuring WordPress...", true)
    success = configure_wordpress.configureWordpress(globals)
    if success then
        utils.log("WordPress setup completed", true)
    end

    -- Configure Apache
    utils.log("Configuring Apache...", true)
    success = configure_apache.configureApache(globals)
    if success then
        utils.log("Apache setup completed", true)
    end
    return true
end
return M