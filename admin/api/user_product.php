<?php
include('../config/config.php');

// Validate email parameter
if (!isset($_GET['email'])) {
    http_response_code(400); // Bad request
    echo json_encode(array("status" => "error", "message" => "Email parameter is missing"));
    exit;
}

$email = $_GET['email'];

// Fetch user ID based on email
$sellerQuery = "SELECT user_id FROM user WHERE email_id = ?";
$stmt = $conn->prepare($sellerQuery);
$stmt->bind_param("s", $email);
$stmt->execute();
$sellerResult = $stmt->get_result();

if ($sellerResult->num_rows == 0) {
    http_response_code(404); // Not found
    echo json_encode(array("status" => "error", "message" => "User not found"));
    exit;
}

$sellerData = $sellerResult->fetch_assoc();
$sellerId = $sellerData['user_id'];

// Fetch products associated with the user
$sql = "SELECT * FROM product WHERE seller_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $sellerId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $products = array();

    while ($row = $result->fetch_assoc()) {
        $imagePaths = explode(',', $row['product_image']); // Split image paths by comma
        $row['product_image'] = $imagePaths; 
        $products[] = $row;
    }

    // Set response header to JSON
    header('Content-Type: application/json');

    // Encode product data as JSON and output it
    echo json_encode($products);
} else {
    http_response_code(404); // Not found
    echo json_encode(array("status" => "error", "message" => "No products found for the user"));
}

// Close database connection
$stmt->close();
$conn->close();
?>
