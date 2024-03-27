<?php
// Enable error reporting for debugging purposes
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include configuration file
include('../config/config.php');

// Function to delete a product and its associated images
function deleteProduct($conn, $productId)
{
    // Prepare and execute query to fetch product images
    $stmt = $conn->prepare("SELECT product_image FROM product WHERE product_id = ?");
    $stmt->bind_param("i", $productId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $imageData = $result->fetch_assoc();
        $imagesToDelete = explode(",", $imageData['product_image']);

        // Delete images from the product_picture folder
        foreach ($imagesToDelete as $image) {
            $file_path = "../admin/product_picture/" . $image;
            if (file_exists($file_path)) {
                unlink($file_path); // Delete image file
            }
        }
    }

    // Prepare and execute query to delete product
    $stmt = $conn->prepare("DELETE FROM product WHERE product_id = ?");
    $stmt->bind_param("i", $productId);
    $stmt->execute();

    // Check if deletion was successful
    if ($stmt->affected_rows > 0) {
        return true; // Product deleted successfully
    } else {
        return false; // Failed to delete product
    }
}

// Handle DELETE request
if ($_SERVER["REQUEST_METHOD"] == "GET") {
    // Handle POST request
    $productId = $_GET["product_id"] ?? '';

    // Call deleteProduct function
    if (!empty($productId)) {
        $result = deleteProduct($conn, $productId);

        // Set response header to JSON
        header('Content-Type: application/json');

        // Encode response as JSON
        if ($result) {
            http_response_code(200); // OK
            echo json_encode(array("success" => true, "message" => "Product deleted successfully"));
        } else {
            http_response_code(500); // Internal Server Error
            echo json_encode(array("success" => false, "message" => "Failed to delete product"));
        }
    } else {
        http_response_code(400); // Bad Request
        echo json_encode(array("success" => false, "message" => "Product ID is missing"));
    }
} else {
    // If request method is neither DELETE nor POST
    http_response_code(405); // Method Not Allowed
    echo json_encode(array("success" => false, "message" => "Only DELETE or POST requests are allowed"));
}

// Close database connection
$conn->close();
?>
