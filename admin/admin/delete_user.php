<?php
include("../config/config.php");
error_reporting(0);

// if (isset($_GET['id'])) {
	$user_id = $_GET['user_id'];
	$sql = "DELETE FROM user WHERE user_id=$user_id";
	$data=mysqli_query($conn,$sql);
	if($data){
		echo "<script>alert('Record Deleted'); window.location.href='user.php';</script>";
		
	}else{
		echo "<script>alert('Failed To Deleted');</script>";
	}
    