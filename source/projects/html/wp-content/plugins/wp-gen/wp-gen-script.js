jQuery(document).ready(function($) {
    $('#dataForm').on('submit', function(event) {
        event.preventDefault(); // Prevent the form from submitting the traditional way

        // Get form input values
        var projectName = $('#project_name').val();
        var command = $('#command').val();
        var verbose = $('#verbose').is(':checked');

        // Construct JSON data
        var jsonData = {
            project_name: projectName,
            command: command,
            verbose: verbose
        };

        // Send JSON data via POST request to your Lua script
        $.ajax({
            url: 'https://datakiin/lua/test.lua', // Direct URL to Lua script
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(jsonData),
            success: function(response) {
                // Ensure response is a JSON object
                try {
                    var jsonResponse = typeof response === 'object' ? response : JSON.parse(response);
                    
                    // Display individual fields from the JSON response
                    var output = "<p>Message: " + jsonResponse.message + "</p>";
                    output += "<p>Project Name: " + jsonResponse.project_name + "</p>";
                    output += "<p>Command: " + jsonResponse.command + "</p>";
                    output += "<p>Verbose: " + jsonResponse.verbose + "</p>";
                    output += "<p>Output: " + jsonResponse.output + "</p>";
                    output += "<p>Exit Code: " + jsonResponse.exit_code + "</p>";

                    $('#response').html(output); // Display formatted response
                } catch (e) {
                    $('#response').html('<p>Error parsing JSON response: ' + e.message + '</p>');
                }
            },
            error: function(xhr, status, error) {
                $('#response').html('<p>Error: ' + error + '</p>');
            }
        });
    });
});
