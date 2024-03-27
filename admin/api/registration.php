<?php
error_reporting(0);

include('../config/config.php');

$username = $_POST["username"];
$email_id = $_POST["email_id"];
$password = $_POST["password"];
$contact = $_POST["contact"];
$profile_picture = 'picture_profile.jpeg';
$location = '';

$stmt = $conn->prepare("SELECT * FROM user WHERE username=? OR email_id=? OR contact=?");
$stmt->bind_param("sss", $username, $email_id, $contact);
$stmt->execute();
$result = $stmt->get_result();

// Initialize an array to store fields that already exist
$existingFields = array();

// Loop through the result set to determine which fields already exist
while ($row = $result->fetch_assoc()) {
    if ($row['username'] == $username) {
        $existingFields[] = 'Username';
    }
    if ($row['email_id'] == $email_id) {
        $existingFields[] = 'Email';
    }
    if ($row['contact'] == $contact) {
        $existingFields[] = 'Contact';
    }
}

if (!empty($existingFields)) {
    // If so, return an error response with the list of existing fields
    $response = array("status" => "Error", "message" => "User already exists. Please change the " . implode(', ', $existingFields));
} else {
    // Insert new user
    $stmt = $conn->prepare("INSERT INTO user (username, email_id, contact, password, profile_picture, location) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssss", $username, $email_id, $contact, $password,$profile_picture,$location);

    if ($stmt->execute()) {
        // Registration successful
        $response = array("status" => "Success", "message" => "User registered successfully");
    } else {
        // Registration failed
        $response = array("status" => "Error", "message" => "Failed to register user");
    }
}

// Close statement
$stmt->close();

// Close connection
$conn->close();

// Return JSON response
echo json_encode($response);
?>
