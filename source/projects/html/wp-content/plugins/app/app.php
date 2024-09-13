<?php
/*
Plugin Name: Wordpress Generator    
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

// Function to output content via a shortcode
function my_simple_plugin_shortcode() {
    return '<h2>Hello, this is my first WordPress plugin!</h2>';
}

// Register the shortcode
function my_simple_plugin_register_shortcode() {
    add_shortcode('simple_greeting', 'my_simple_plugin_shortcode');
}
add_action('init', 'my_simple_plugin_register_shortcode');

?>
