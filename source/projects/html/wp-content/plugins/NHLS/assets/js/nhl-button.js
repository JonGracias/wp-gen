document.addEventListener('DOMContentLoaded', function() {
    console.log('JavaScript is ready');  // Check if script is loading

    // Select the button by its ID and attach a click event listener
    var sendProjectDataButton = document.getElementById('sendProjectData');

    if (sendProjectDataButton) {  // Check if the button exists
        sendProjectDataButton.addEventListener('click', function() {
            console.log('Button clicked!');  // Log to console when the button is clicked
            alert('Button pressed');  // Show the alert
        });
    } else {
        console.log('Button with ID "sendProjectData" not found.');  // Log if the button is not found
    }
});

document.getElementById('refresh-schedule').addEventListener('click', function() {
    fetch('/wp-admin/admin-ajax.php?action=refresh_schedule', { method: 'POST' })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload();
        } else {
            alert('Failed to refresh schedule');
        }
    });
});