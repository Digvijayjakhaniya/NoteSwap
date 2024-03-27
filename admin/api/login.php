<?php
session_start(); // Start session

// Check if user is already logged in
function isLoggedIn() {
    return isset($_SESSION['email_id']);
}

// Function to handle user login
function loginUser($email_id, $password) {
    // Perform your authentication logic here (e.g., database lookup)
    // Replace the placeholder with your actual authentication logic
    // For example:
    // $authenticated = authenticateUser($email_id, $password);
    
    // Placeholder for demonstration
    // Check against your database for authentication
    // Assuming you have a database connection $conn
    include('../config/config.php');
    $stmt = $conn->prepare("SELECT * FROM user WHERE email_id=? AND password=?");
    $stmt->bind_param("ss", $email_id, $password);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows == 1) {
        // Authentication successful
        $_SESSION['email_id'] = $email_id; // Store user's email_id in session
        return true;
    } else {
        // Authentication failed
        return false;
    }
}

// Function to handle user logout
function logoutUser() {
    // Unset all session variables
    $_SESSION = array();
    // Destroy the session
    session_destroy();
}

// Example API endpoint to handle login request
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email_id = $_POST["email_id"];
    $password = $_POST["password"];
    
    if (loginUser($email_id, $password)) {
        // Login successful
        echo json_encode(array("status" => "success", "message" => "Login successful"));
    } else {
        // Login failed
        echo json_encode(array("status" => "Error", "message" => "Invalid email or password"));
    }
} else if ($_SERVER["REQUEST_METHOD"] == "GET" && isset($_GET["action"]) && $_GET["action"] == "logout") {
    // Handle logout request
    logoutUser();
    echo json_encode(array("status" => "success", "message" => "Logged out successfully"));
} else {
    // Invalid request
    echo json_encode(array("status" => "Error", "message" => "Invalid request method"));
}
?>
