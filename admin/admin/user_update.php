<?php include_once('redirect.php') ?>

<!doctype html>
<html lang="en" dir="ltr">
    
	<?php include('layout/head.php') ?>

    <?php
		include("../config/config.php");
        error_reporting(0);
        $user_id = $_GET['user_id'];
        $record = mysqli_query($conn, "SELECT * FROM user WHERE user_id='$user_id'");
        $row = mysqli_fetch_array($record);
        $oldprofile_picture = $row["profile_picture"];
    ?>

	<body class="app sidebar-mini ltr light-mode">
		<!-- PAGE -->
		<div class="page">
			<div class="page-main">
				
				<?php include('layout/nav.php') ?>

				<!-- APP-CONTENT OPEN -->
				<div class="main-content app-content mt-0">
					<div class="side-app">

						<!-- CONTAINER -->
						<div class="main-container container-fluid">
                            <!-- PAGE-HEADER -->
							<div class="page-header">
								<div>
									<h1 class="page-title">Update User</h1>
									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="javascript:void(0);">APPS</a></li>
										<li class="breadcrumb-item active" aria-current="page">Update User</li>
									</ol>
								</div>
							</div>
							<!-- PAGE-HEADER END -->
                            <!-- start page title -->
                            <div class="row">
        </div>
        <!-- end page title -->
                        <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <!-- Modal -->
                                    <div id="exampleModal" aria-labelledby="exampleModalLabel">
                                        <!-- <div class="modal-dialog"> -->
                                            <!-- <div class="modal-content"> -->
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="exampleModalLabel">Update User</h5>
                                                </div>
                                                    <form action="" method="POST" enctype="multipart/form-data">

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label"> User Name</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="User name" name="username" value="<?php echo $row["username"]; ?>">
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea2" class="form-label">Email Id</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Email Id" name="email_id" value="<?php echo $row["email_id"]; ?>">
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Password</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Password" name="password" value="<?php echo $row["password"]; ?>" >
                                                        </div>

                                                        <label for="exampleFormControlInput1" class="form-label">Profile Picture</label><br>
                                                        <img class="img-fluid" style="height: 100px; width: 100px;" src="user_profile_picture/<?php echo $row["profile_picture"]; ?>">
                                                        <div class="input-group mb-3">
                                                            <input type="file" class="form-control" id="inputGroupFile02" name="profile_picture" value="<?php echo $row["profile_picture"]; ?>" accept="image/*">
                                                            <label class="input-group-text" for="inputGroupFile02">Upload</label>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Location</label>
                                                            <textarea type="text" class="form-control" id="exampleFormControlInput1" placeholder="Location" name="location" ><?php echo $row["location"];?></textarea>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label">Contact</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Contact" name="contact" value="<?php echo $row["contact"];?>">
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label">Feedback</label>
                                                            <textarea type="text" class="form-control" id="exampleFormControlInput1" placeholder="Feedback" name="feedback" ><?php echo $row["feedback"];?></textarea>
                                                        </div>

                                                        <div class="modal-footer">
                                                            <input type="submit"  name="submit" class="btn btn-primary" value="Save changes">
                                                            <!-- <button type="submit" name="submit" class="btn btn-primary">Save changes</button> -->
                                                        </div>
                                                    </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div> <!-- end col -->
                    </div> <!-- end row -->
						</div>
						<!-- CONTAINER CLOSED -->
					</div>
				</div>
				<!-- APP-CONTENT CLOSED -->
			</div>

            <?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Check if the form is submitted
    if (isset($_POST["submit"])) {
        // Get user details from the form
        $username = $_POST["username"];
        $email_id = $_POST["email_id"];
        $password = $_POST["password"];
        $location = $_POST["location"];
        $contact = $_POST["contact"];
        $feedback = $_POST["feedback"];

        // Get the user's old profile picture
        $oldprofile_picture = $row["profile_picture"];

        // Check if a new profile picture is uploaded
        if (!empty($_FILES["profile_picture"]["name"])) {
            // Delete the old profile picture
            if (!empty($oldprofile_picture) && file_exists("user_profile_picture/" . $oldprofile_picture)) {
                unlink("user_profile_picture/" . $oldprofile_picture);
            }

            // Move the new profile picture to the folder
            move_uploaded_file($_FILES["profile_picture"]["tmp_name"], "user_profile_picture/" . $_FILES["profile_picture"]["name"]);

            // Update the profile_picture variable with the new file name
            $oldprofile_picture = $_FILES["profile_picture"]["name"];
        }

        // Update the user record in the database
        $sql = "UPDATE user SET username='$username', email_id='$email_id', password='$password', profile_picture='$oldprofile_picture', location='$location', contact='$contact', feedback='$feedback' WHERE user_id='$user_id'";
        $data = mysqli_query($conn, $sql);

        // Check if the update was successful
        if ($data) {
            echo "<script>alert('User Updated'); window.location.href='user.php';</script>";
        } else {
            echo "<script>alert('Failed');</script>";
        }
    }
}
?>

			<?php include('layout/footer.php') ?>

		</div>

				
		<!-- BACK-TO-TOP -->
		<a href="#top" id="back-to-top"><i class="fa fa-angle-up"></i></a>

		<?php include('layout/script.php') ?>
        <script src="https://cdn.ckeditor.com/4.16.0/full/ckeditor.js"></script>
        <script>
            $(document).ready(function() {
                var note = document.querySelector('#editor')
                CKEDITOR.replace(editor);
            });
            $(document).ready(function() {
                var note = document.querySelector('#editor2')
                CKEDITOR.replace(editor2);
            });$(document).ready(function() {
                var note = document.querySelector('#editor3')
                CKEDITOR.replace(editor3);
            });$(document).ready(function() {
                var note = document.querySelector('#editor4')
                CKEDITOR.replace(editor4);
            });$(document).ready(function() {
                var note = document.querySelector('#editor5')
                CKEDITOR.replace(editor5);
            });
        </script>

	</body>
</html>