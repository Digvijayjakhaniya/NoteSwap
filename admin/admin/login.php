<?php
session_start();
include("../config/config.php");
$email_idErr = $passwordErr = "";
$email_id = $password = "";

if($_SERVER["REQUEST_METHOD"] =="POST")
	{
		if(empty($_POST["email_id"]))
		{
			$email_idErr='<div class="alert alert-danger" role="alert">Email is required.</div>';
		}
		else
				{
					$email_id=$_POST["email_id"];
					if(!preg_match("/^[a-zA-Z0-9._]+@[a-zA_Z0-9._]+\.[a-zA_Z]{2,4}$/",$email_id))
				{
				$email_idErr = '<div class="alert alert-danger" role="alert">Invalid email format.</div>';
				}
				}
				
				
			if(empty($_POST["password"]))
			{
				$passwordErr='<div class="alert alert-danger" role="alert">password is required.</div>';
			}
			else
				{
					$password=$_POST["password"];
				if(!preg_match("/^[a-zA-Z0-9]{8}$/",$password))
				{
				$passwordErr = '<div class="alert alert-danger" role="alert">please enter 8 digit password</div>';
				}
				}
		
	if(isset($_POST["email_id"]) && isset($_POST["password"]))
	{
	  
	   
		$email_id = $_POST["email_id"];
		$password = $_POST["password"];
		
	
		
		if($email_id !='' && $password !='')
		{
			$sql="select admin_id,email_id,password,admin_name from admin where email_id='".$email_id."'
			and password='".$password."'";
      
			$result = mysqli_query($conn,$sql);
			if($row = mysqli_fetch_assoc($result))
			{
				session_start();
				$_SESSION["admin_id"] = $row['admin_id'];
				header('location:index.php');
				}
				else
				{
				echo " <script>
													  alert('invalid password');
													  window.location='login.php';
													  </script>";
					
				}	
			}
		}
}		
?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, shrink-to-fit=no" name="viewport">
  <title>Digvijay - login</title>
  <link rel="shortcut icon" type="image/png" href="..\assets\images\favicon.PNG" />
  <!-- General CSS Files -->
  <link rel="stylesheet" href="assets/css/app.min.css">
  <link rel="stylesheet" href="assets/bundles/bootstrap-social/bootstrap-social.css">
  <!-- Template CSS -->
  <link rel="stylesheet" href="assets/css/style.css">
  <link rel="stylesheet" href="assets/css/components.css">
  <!-- Custom style CSS -->
  <link rel="stylesheet" href="assets/css/custom.css">
  
</head>

<body>
  <div class="loader"></div>
  <div id="app">
    <section class="section">
      <div class="container mt-5">
        <div class="row">
          <div class="col-12 col-sm-8 offset-sm-2 col-md-6 offset-md-3 col-lg-6 offset-lg-3 col-xl-4 offset-xl-4">
            <div class="card card-primary">
              <div class="card-header">
                <h4>Login</h4>
              </div>
              <div class="card-body">
                <form method="POST" action="#">
				
				<span class="error"> <?php echo $email_idErr; ?>  </span>
                <span class="error"> <?php echo $passwordErr; ?>  </span>
                
				<div class="form-group">
                    <label for="email">Email</label>
                    <input id="email" type="email" class="form-control" name="email_id">
                    
                  </div>
                  <div class="form-group">
                    <div class="d-block">
                      <label for="password" class="control-label">Password</label>
                      
                    </div>
                    <input id="password" type="password" class="form-control" name="password">
                  
                  </div>
                
                  <div class="form-group">
                    <button type="submit" class="btn btn-primary btn-lg btn-block" tabindex="4">
                      Login
                    </button>
                  </div>
                </form>
               </div>
            </div>
           </div>
        </div>
      </div>
    </section>
  </div>
  <!-- General JS Scripts -->
  <script src="assets/js/app.min.js"></script>
  <!-- JS Libraies -->
  <!-- Page Specific JS File -->
  <!-- Template JS File -->
  <script src="assets/js/scripts.js"></script>
  <!-- Custom JS File -->
  <script src="assets/js/custom.js"></script>
</body>

</html>