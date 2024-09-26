<?php


// db_conn.php
function create_pdo_connection($db_host, $db_user, $db_pass) {
    try {
        // Create a new PDO instance (without specifying a database)
        $dsn = "mysql:host=$db_host;charset=utf8mb4";
        $pdo = new PDO($dsn, $db_user, $db_pass);

        // Set PDO error mode to exception
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // Optionally, set other attributes like default fetch mode
        $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

        return $pdo;

    } catch (PDOException $e) {
        // Handle connection error
        echo "Connection failed: " . $e->getMessage();
        return null;
    }
}


function check_database_exists($pdo, $db_name) {
    if ($pdo) {
        try {
            // Prepare and execute the query to check for database existence
            $stmt = $pdo->prepare("SHOW DATABASES LIKE :dbname");
            $stmt->bindParam(':dbname', $db_name, PDO::PARAM_STR);
            $stmt->execute();

            // Check if any rows were returned
            return $stmt->rowCount() > 0;

        } catch (PDOException $e) {
            echo "Query failed: " . $e->getMessage();
            return false;
        }
    }
    return false;
}

// Handle the POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve the posted JSON data
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (isset($input['db_name'])) {
        $db_name = $input['db_name'];

        // Reuse the PDO connection from db_conn.php
        $db_host = "wordpress_db";
        $db_user = "root";
        $db_pass = "password";

        // Get the PDO connection
        $pdo = create_pdo_connection($db_host, $db_user, $db_pass);

        // Check if the database exists
        if (check_database_exists($pdo, $db_name)) {
            echo "Database exists!";
        } else {
            echo "Database does not exist.";
        }
    } else {
        echo "Database name is required.";
    }
}
