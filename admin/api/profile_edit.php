<?php
error_reporting(0);

include('../config/config.php');

$email = $_GET['email'];

// Check if the form is submitted via POST method
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get user details from the POST data
    $username = $_POST["username"];
    $email_id = $_POST["email_id"];
    $location = $_POST["location"];
    $contact = $_POST["contact"];

    // Check if the new username, email, or contact already exists for other users
    $stmt_check = $conn->prepare("SELECT * FROM user WHERE (username=? OR email_id=? OR contact=?) AND email_id <> ?");
    $stmt_check->bind_param("ssss", $username, $email_id, $contact, $email_id);
    $stmt_check->execute();
    $result_check = $stmt_check->get_result();

    if ($result_check->num_rows > 0) {
        // If there are existing users with the same username, email, or contact, return an error response
        $existingFields = array();
        while ($row_check = $result_check->fetch_assoc()) {
            if ($row_check['username'] == $username) {
                $existingFields[] = 'Username';
            }
            if ($row_check['email_id'] == $email_id) {
                $existingFields[] = 'Email';
            }
            if ($row_check['contact'] == $contact) {
                $existingFields[] = 'Contact';
            }
        }
        $response = array("status" => "Error", "message" => "User already exists. Please change the " . implode(', ', $existingFields));
    } else {
        // If no conflicts are found, proceed with updating the user record in the database

        $stmt_get_profile_picture = $conn->prepare("SELECT profile_picture FROM user WHERE email_id = ?");
        $stmt_get_profile_picture->bind_param("s", $email); // Assuming $email holds the user's email
        $stmt_get_profile_picture->execute();
        $result_get_profile_picture = $stmt_get_profile_picture->get_result();
        if ($result_get_profile_picture->num_rows > 0) {
            $row = $result_get_profile_picture->fetch_assoc();
            $oldprofile_picture = $row['profile_picture'];
        }
        $stmt_get_profile_picture->close();

        // Check if a new profile picture is uploaded
        if (!empty($_FILES["profile_picture"]["name"])) {
            // Get the extension of the uploaded file
            $file_extension = pathinfo($_FILES["profile_picture"]["name"], PATHINFO_EXTENSION);
            // Generate a unique filename to avoid conflicts
            $newfilename = uniqid() . '.' . $file_extension;
            // Move the uploaded file to the directory
            $target_dir = "../admin/user_profile_picture/";
            $target_file = $target_dir . $newfilename;

            if (move_uploaded_file($_FILES["profile_picture"]["tmp_name"], $target_file)) {
                // Delete the old profile picture if it exists
                if (!empty($oldprofile_picture) && file_exists("../admin/user_profile_picture/" . $oldprofile_picture)) {
                    unlink("../admin/user_profile_picture/" . $oldprofile_picture);
                }
                // Update old profile picture with the new filename
                $oldprofile_picture = $newfilename;
            } else {
                // Return error message if file upload failed
                $response = array("status" => "Error", "message" => "Failed to upload profile picture");
                echo json_encode($response);
                exit;
            }
        }
        //  else {
        //     // No new profile picture uploaded, retain the existing profile picture
        //     $stmt_get_profile_picture = $conn->prepare("SELECT profile_picture FROM user WHERE email_id = ?");
        //     $stmt_get_profile_picture->bind_param("s", $email);
        //     $stmt_get_profile_picture->execute();
        //     $result_get_profile_picture = $stmt_get_profile_picture->get_result();
        //     $row = $result_get_profile_picture->fetch_assoc();
        //     $oldprofile_picture = $row['profile_picture'];
        //     $stmt_get_profile_picture->close();
        // }

        // Update the user record in the database
        $stmt_update = $conn->prepare("UPDATE user SET username=?, email_id=?, profile_picture=?, location=?, contact=? WHERE email_id=?");
        $stmt_update->bind_param("ssssss", $username, $email_id, $oldprofile_picture, $location, $contact,$email);

        // Execute the update statement
        if ($stmt_update->execute()) {
            // Return success message
            $response = array("status" => "Success", "message" => "User updated successfully");
        } else {
            // Return error message
            $response = array("status" => "Error", "message" => "Failed to update user");
        }

        // Close the update statement
        $stmt_update->close();
    }

    // Close the check statement
    $stmt_check->close();
} else {
    // If the form is not submitted via POST method, return an error response
    $response = array("status" => "Error", "message" => "Invalid request method");
}

// Close connection
$conn->close();

// Return JSON response
echo json_encode($response);
?>
