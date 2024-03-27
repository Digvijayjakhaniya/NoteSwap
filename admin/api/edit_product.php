<?php
error_reporting(0);

include('../config/config.php');

// Check if the email parameter is provided in the URL
// if (!isset($_GET['email'])) {
//     echo json_encode(array("status" => "Error", "message" => "Email parameter is missing"));
//     exit;
// }

// $email = $_GET['email'];

// Function to update a product
// Function to update a product
function updateProduct($conn, $productId, $title, $category, $price, $description, $product_image)
{
    // Convert product images array into string
    $product_images_str = '';
    
    if (!empty($product_image)) {
        // New images are uploaded
        $product_images_str = implode(",", $product_image);
        
        // Delete old images from folder
        $deleteQuery = "SELECT product_image FROM product WHERE product_id = '$productId'";
        $deleteResult = $conn->query($deleteQuery);
        
        if ($deleteResult->num_rows > 0) {
            $deleteData = $deleteResult->fetch_assoc();
            $oldImages = explode(",", $deleteData['product_image']);

            foreach ($oldImages as $image) {
                $file_path = "../admin/product_picture/" . $image;
                if (file_exists($file_path)) {
                    unlink($file_path); // Delete old image file
                }
            }
        }
    } else {
        // No new images uploaded, retain old images
        $selectQuery = "SELECT product_image FROM product WHERE product_id = '$productId'";
        $selectResult = $conn->query($selectQuery);
        
        if ($selectResult->num_rows > 0) {
            $selectData = $selectResult->fetch_assoc();
            $product_images_str = $selectData['product_image'];
        }
    }

    // Update product information in product table
    $updateQuery = "UPDATE product SET title = '$title', product_image = '$product_images_str', category = '$category', price = '$price', description = '$description' WHERE product_id = '$productId'";
    $result = $conn->query($updateQuery);

    if ($result) {
        return true; // Product updated successfully
    } else {
        return false; // Failed to update product
    }
}

 


// Example usage
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve product data from request
    $productId = $_POST["product_id"];
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
    }


    // Call updateProduct function
    $result = updateProduct($conn, $productId, $title, $category, $price, $description, $product_image);

    // Set response header to JSON
    header('Content-Type: application/json');

    // Encode response as JSON
    if ($result) {
        echo json_encode(array("success" => true, "message" => "Product updated successfully"));
    } else {
        echo json_encode(array("success" => false, "message" => "Failed to update product"));
    }
} else {
    // If request method is not POST
    echo json_encode(array("success" => false, "message" => "Only POST requests are allowed"));
}

// Close database connection
$conn->close();
?>
