<?php include_once('redirect.php') ?>

<!doctype html>
<html lang="en" dir="ltr">
    
	<?php include('layout/head.php') ?>

	<body class="app sidebar-mini ltr light-mode">
  
    <?php
		include("../config/config.php");
        error_reporting(0);
        $result = mysqli_query($conn,"SELECT * FROM user");
    ?>
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
									<h1 class="page-title">Users</h1>
									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="javascript:void(0);">APPS</a></li>
										<li class="breadcrumb-item active" aria-current="page">Users</li>
									</ol>
								</div>
							</div>
							<!-- PAGE-HEADER END -->
                            <!-- start page title -->
                            <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <div class="row">
                                        <div class="col md-10">
                                            <h4 class="card-title">Users Details</h4>
                                        </div>
                                        <div class="col md-2" style="display:flex; justify-content:right;">
                                            <button type="button" class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#exampleModal" style="padding: 2px;">
                                                Create New Users
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">

                                    <!-- Modal -->
                                    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="exampleModalLabel">Create New Users</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <form action="" method="POST" enctype="multipart/form-data">

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label"> User Name</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="User Name" name="username" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Email Id</label>
                                                            <!-- <textarea class="form-control" id="editor" rows="3" name="text" required></textarea> -->
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Email Id" name="email_id" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Password</label>
                                                            <!-- <textarea class="form-control" id="editor" rows="3" name="text" required></textarea> -->
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Password" name="password" required>
                                                        </div>

                                                        <label for="exampleFormControlInput1" class="form-label">Profile Picture</label>

                                                        <div class="input-group mb-3">
                                                            <input type="file" class="form-control" id="inputGroupFile02" name="profile_picture" accept="image/*">
                                                            <label class="input-group-text" for="inputGroupFile02">Upload</label>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Location</label>
                                                            <textarea type="text" class="form-control" id="exampleFormControlInput1" placeholder="Location" name="location" ></textarea>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label">Contact</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Contact" name="contact" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label">Feedback</label>
                                                            <textarea type="text" class="form-control" id="exampleFormControlInput1" placeholder="Feedback" name="feedback" ></textarea>
                                                        </div>

                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                            <button type="submit" class="btn btn-primary">Save changes</button>
                                                        </div>
                                                    </form>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                    <?php
                            if (mysqli_num_rows($result) > 0) {
                            ?>
                                    <table id="datatable" class="table table-bordered dt-responsive  nowrap w-100" style="text-align: center;">

                                        <thead>
                                            <tr>
                                                <th>No.</th> 
                                                <th> User Id </th>
                                                <th>User Name</th>
                                                <th>Email Id</th>
                                                <th>Password</th>
                                                <th>Profile Picture</th>
                                                <th>Location</th>
                                                <th>Contact</th>
                                                <th>Feedback</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php

                                            $i = 1;
                                            while ($row = mysqli_fetch_array($result)) {
                                            ?>


                                                <tr>
                                                    <td style="width: 10px;"><?php echo $i++; ?></td>
                                                    <td><?php echo $row["user_id"]; ?></td>
                                                    <td><?php echo $row["username"]; ?></td>
                                                    <td><?php echo $row["email_id"]; ?></td>
                                                    <td><?php echo $row["password"]; ?></td>
                                                    <td style="width: 100px;"> <img src="user_profile_picture/<?php echo $row["profile_picture"]; ?>" height="100px" width="100px"><br></td>
                                                    <td><?php echo $row["location"]; ?></td>
                                                    <td><?php echo $row["contact"]; ?></td>
                                                    <td><?php echo $row["feedback"]; ?></td>
                                                    <td>
                                                    <a href="user_update.php?user_id=<?php echo $row["user_id"]; ?>">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-edit">
                                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                                            </svg>
                                                        </a>
                                                        <a class="text-danger" href="delete_user.php?user_id=<?php echo $row["user_id"]; ?>">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-delete">
                                                                <path d="M21 4H8l-7 8 7 8h13a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2z"></path>
                                                                <line x1="18" y1="9" x2="12" y2="15"></line>
                                                                <line x1="12" y1="9" x2="18" y2="15"></line>
                                                            </svg>
                                                        </a>

                                                     
                                                    </td>
                                                </tr>
                                            <?php
                                                // $i++;
                                            }
                                            ?>
                                        </tbody>
                                    </table>

                                <?php
                            } else {
                                echo "No result found";
                            }

                                ?>

                                </div>
                            </div>
                        </div> <!-- end col -->
                    </div> <!-- end row -->


                    <?php
                    if ($_SERVER["REQUEST_METHOD"] == "POST") {
                    // if (isset($_POST["submit"])) {

                    move_uploaded_file($_FILES["profile_picture"]["tmp_name"], "user_profile_picture/" . $_FILES["profile_picture"]["name"]);
                    $username = $_POST["username"];
                    $email_id = $_POST["email_id"];
                    $password = $_POST["password"];
                    $profile_picture = $_FILES["profile_picture"]["name"];
                    $location = $_POST["location"];
                    $contact = $_POST["contact"];
                    $feedback = $_POST["feedback"];



                    $sql = "INSERT INTO user (username,email_id,password,profile_picture,location,contact,feedback) VALUES('$username','$email_id','$password','$profile_picture','$location','$contact','$feedback')";


                    $data = mysqli_query($conn, $sql);
                    if ($data) {
                        echo "<script>alert('User Created Successfully.'); window.location.href='user.php';</script>";
                    } else {
                        echo "<script>alert('Failed.')</script>";
                    }
                }

                ?>

                </div>
                <!-- CONTAINER CLOSED -->
            </div>
        </div>
        <!-- APP-CONTENT CLOSED -->
    </div>
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
        </script>
        <script>
            $(document).ready(function() {
                var note = document.querySelector('#editor1')
                CKEDITOR.replace(editor1);
            });
            $(document).ready(function() {
                var note = document.querySelector('#editor2')
                CKEDITOR.replace(editor2);
            });
            $(document).ready(function() {
                var note = document.querySelector('#editor3')
                CKEDITOR.replace(editor3);
            });
            $(document).ready(function() {
                var note = document.querySelector('#editor4')
                CKEDITOR.replace(editor4);
            });
        </script>

	</body>
</html>