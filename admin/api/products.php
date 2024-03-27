<?php
error_reporting(0);

include('../config/config.php');

// $sql = "SELECT * FROM product";
$sql = "SELECT product.*, user.contact AS seller_contact 
        FROM product 
        INNER JOIN user ON product.seller_id = user.user_id";
$result = $conn->query($sql);

// Check if there are any products
if ($result->num_rows > 0) {
    // Array to store fetched product data
    $products = array();

    // Fetch each row of product data and add it to the products array
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
    // If no products are found
    echo json_encode(array("status" => "error", "message" => "No products found"));
}

// Close database connection
$conn->close();
?>
