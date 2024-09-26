document.addEventListener('DOMContentLoaded', function () {
    const button = document.getElementById('sendProjectData');
    
    if (button) {
        button.addEventListener('click', function () {
            fetch(projectButton.ajax_url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: new URLSearchParams({
                    action: 'send_project_data',
                    security: projectButton.nonce
                })
            })
            .then(response => {
                console.log(response);  // Log the response to see what's happening
                return response.json();  // Attempt to parse it as JSON
            })
            .then(data => {
                if (data.success) {
                    console.log('Success:', data.message);
                } else {
                    console.error('Error:', data.message);
                }
            })
            .catch(error => console.error('AJAX Error:', error));
        });
    }
});
