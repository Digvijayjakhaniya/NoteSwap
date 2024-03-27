<?php
error_reporting(0);

include('../config/config.php');

$sql = "SELECT * FROM category";
$result = $conn->query($sql);

// Check if there are any categories
if ($result->num_rows > 0) {
    // Array to store fetched product data
    $categories = array();

    // Fetch each row of product data and add it to the $categories array
    while ($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }

    // Set response header to JSON
    header('Content-Type: application/json');

    // Encode product data as JSON and output it
    echo json_encode($categories);
} else {
    // If no products are found
    echo json_encode(array("status" => "error", "message" => "No categories found"));
}

// Close database connection
$conn->close();
?>
