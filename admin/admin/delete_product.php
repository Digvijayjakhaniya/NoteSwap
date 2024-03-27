<?php
include("../config/config.php");
error_reporting(0);

// if (isset($_GET['id'])) {
	$product_id = $_GET['product_id'];
	$sql = "DELETE FROM product WHERE product_id=$product_id";
	$data=mysqli_query($conn,$sql);
	if($data){
		echo "<script>alert('Record Deleted'); window.location.href='product.php';</script>";
		
	}else{
		echo "<script>alert('Failed To Deleted');</script>";
	}
    