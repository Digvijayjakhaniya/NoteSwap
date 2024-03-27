<?php
error_reporting(0);

include('../config/config.php');

// Check if the email parameter is provided in the URL
if (!isset($_GET['email'])) {
    echo json_encode(array("status" => "Error", "message" => "Email parameter is missing"));
    exit;
}

$email = $_GET['email'];

// Function to add a product
function addProduct($conn, $title, $category, $price, $description, $email, $product_image)
{
    // Get seller_id from user table using email_id
    $sellerQuery = "SELECT user_id FROM user WHERE email_id = '$email'";
    $sellerResult = $conn->query($sellerQuery);

    if ($sellerResult->num_rows > 0) {
        $sellerData = $sellerResult->fetch_assoc();
        $sellerId = $sellerData['user_id'];

        // Convert product images array into string
        $product_images_str = implode(",", $product_image);

        // Insert product information into product table
        $insertQuery = "INSERT INTO product (title, product_image, category, price, description, location, seller_id) VALUES ('$title', '$product_images_str', '$category', '$price', '$description', (SELECT location FROM user WHERE email_id = '$email'), '$sellerId')";
        $result = $conn->query($insertQuery);

        if ($result) {
            return true; // Product added successfully
        } else {
            return false; // Failed to add product
        }
    } else {
        return false; // Seller not found
    }
}

// Example usage
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve product data from request
    $title = $_POST["title"];
    $category = $_POST["category"];
    $price = $_POST["price"];
    $description = $_POST["description"];

    // Handle product picture upload
    $product_image = array();
    if (!empty($_FILES["product_image"]["name"])) {
        $target_dir = "../admin/product_picture/";
        foreach ($_FILES["product_image"]["tmp_name"] as $key => $tmp_name) {
            $file_name = $_FILES["product_image"]["name"][$key];
            $file_extension = pathinfo($file_name, PATHINFO_EXTENSION);
            $unique_file_name = uniqid() . '.' . $file_extension; // Generate unique file name
            $file_destination = $target_dir . $unique_file_name;
    
            if (move_uploaded_file($tmp_name, $file_destination)) {
                $product_image[] = $unique_file_name;
            } else {
                echo json_encode(array("success" => false, "message" => "Failed to upload product image"));
                exit;
            }
        }
    } else {
        echo json_encode(array("success" => false, "message" => "No product images provided"));
        exit;
    }


    // Call addProduct function
    $result = addProduct($conn, $title, $category, $price, $description, $email, $product_image);

    // Set response header to JSON
    header('Content-Type: application/json');

    // Encode response as JSON
    if ($result) {
        echo json_encode(array("success" => true, "message" => "Product added successfully"));
    } else {
        echo json_encode(array("success" => false, "message" => "Failed to add product"));
    }
} else {
    // If request method is not POST
    echo json_encode(array("success" => false, "message" => "Only POST requests are allowed"));
}

// Close database connection
$conn->close();
?>
