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
