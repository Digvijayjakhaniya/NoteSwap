<?php
error_reporting(0);

include('../config/config.php');

// Function to check if the user is logged in
// function isLoggedIn() {
//     return isset($_SESSION['email_id']);
// }

// Check if the user is logged in
// if (isLoggedIn()) {
    // Retrieve the email ID from the session
    $email = $_GET['email']; // Get email ID from the request parameters

    // Prepare and execute SQL query to fetch user data based on the email
    $sql = "SELECT * FROM user WHERE email_id = '$email'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Array to store fetched user data
        $userData = array();

        // Fetch user data and add it to the userData array
        while ($row = $result->fetch_assoc()) {
            $userData[] = $row;
        }

        // Set response header to JSON
        header('Content-Type: application/json');

        // Encode user data as JSON and output it
        echo json_encode($userData);
    } else {
        // If no user is found with the given email
        echo json_encode(array("status" => "error", "message" => "No user found with the provided email"));
    }
// } else {
//     // If the user is not logged in
//     echo json_encode(array("status" => "error", "message" => "User is not logged in"));
// }

// Close database connection
$conn->close();
?>
