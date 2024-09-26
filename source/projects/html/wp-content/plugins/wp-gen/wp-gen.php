<?php
/*
Plugin Name: WordPress Generator    
Plugin URI:  http://datakiin.com/wp-gen
Description: A basic plugin example with a shortcode.
Version:     1.0
Author:      Jonatan Gracias
Author URI:  http://datakiin.com
License:     GPL2
*/

// Exit if accessed directly
if (!defined('ABSPATH')) {
    exit;
}

// Register activation and deactivation hooks
register_activation_hook(__FILE__, 'wp_generator_activate');
register_deactivation_hook(__FILE__, 'wp_generator_deactivate');

function wp_generator_activate() {
    // Activation code here
}

function wp_generator_deactivate() {
    // Deactivation code here
}



// Define the shortcode
function render_project_form() {
    // Include the form view
    require_once plugin_dir_path(__FILE__) . '/view.html';
}
add_shortcode('wp-gen', 'render_project_form');

function wp_gen_enqueue_scripts() {
    wp_enqueue_script('wp_gen_custom_script', plugin_dir_url(__FILE__) . 'wp-gen-script.js', array('jquery'));

}
add_action('wp_enqueue_scripts', 'wp_gen_enqueue_scripts');

