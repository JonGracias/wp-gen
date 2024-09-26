<?php
/*
Plugin Name: NHL Schedule
Description: Displays the NHL schedule for the current season.
Version: 1.0
Author: Jon Gracias
*/




//Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}
// Include the controller and views
require_once plugin_dir_path(__FILE__) . 'controllers/NHLController.php';

// Register activation and deactivation hooks
register_activation_hook(__FILE__, 'nhl_schedule_activate');
register_deactivation_hook(__FILE__, 'nhl_schedule_deactivate'); 

function nhl_schedule_activate() {
    // Activation code here
}

function nhl_schedule_deactivate() {
    // Deactivation code here
}

// Create shortcode to display the schedule
function nhl_schedule_shortcode() {
    $nhlController = new NHLController();
    ob_start();
    $nhlController->displaySchedule();
    return ob_get_clean();
}
add_shortcode('nhls', 'nhl_schedule_shortcode');

//--------------------------------Scripts-------------------------------//

// Enqueue the plugin's stylesheet
function nhl_schedule_enqueue_styles() {
    wp_enqueue_style('nhl-schedule-style', plugin_dir_url(__FILE__) . 'assets/css/nhl-style.css');
    wp_enqueue_script('project-button', plugin_dir_url(__FILE__) . 'assets/js/nhl-button.js');
}

add_action('wp_enqueue_scripts', 'nhl_schedule_enqueue_styles');
