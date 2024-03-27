<?php
include("../config/config.php");
error_reporting(0);

// if (isset($_GET['id'])) {
	$category_id = $_GET['category_id'];
	$sql = "DELETE FROM category WHERE category_id=$category_id";
	$data=mysqli_query($conn,$sql);
	if($data){
		echo "<script>alert('Record Deleted'); window.location.href='category.php';</script>";
		
	}else{
		echo "<script>alert('Failed To Deleted');</script>";
	}
    