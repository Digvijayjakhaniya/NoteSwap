<?php include_once('redirect.php') ?>

<!doctype html>
<html lang="en" dir="ltr">
    
    <?php include('layout/head.php') ?>

	<body class="app sidebar-mini ltr light-mode">
  
    <?php
		include("../config/config.php");
        error_reporting(0);
        $result = mysqli_query($conn,"SELECT * FROM category");
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
									<h1 class="page-title">Category</h1>
									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="javascript:void(0);">APPS</a></li>
										<li class="breadcrumb-item active" aria-current="page">Category</li>
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
                                            <h4 class="card-title">Category Details</h4>
                                        </div>
                                        <div class="col md-2" style="display:flex; justify-content:right;">
                                            <button type="button" class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#exampleModal" style="padding: 2px;">
                                                Add Category
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
                                                    <h5 class="modal-title" id="exampleModalLabel">Add Category</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <form action="" method="POST" enctype="multipart/form-data">

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label"> Category Name</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Category Name" name="category_name" required>
                                                        </div>

                                                        <!-- <div class="mb-3">
                                                            <input type="submit" value="Submit" name="submit" class="btn btn-outline-success">
                                                        </div> -->
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
                            <div style="overflow-x:auto;">
                                    <table id="datatable" class="table table-bordered dt-responsive  nowrap w-100" style="text-align: center;">

                                        <thead>
                                            <tr>
                                                <th>No.</th>
                                                <th>Category Name</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php
                                            $i = 1;
                                            while ($row = mysqli_fetch_array($result)) {
                                            ?>
                                                <tr>
                                                    <td><?php echo $i++; ?></td>
                                                    <td><?php echo $row["category_name"]; ?></td>
                                                    <td>
                                                    <a href="category_update.php?category_id=<?php echo $row["category_id"]; ?>">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-edit">
                                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                                            </svg>
                                                        </a>
                                                        <a class="text-danger" href="delete_category.php?category_id=<?php echo $row["category_id"]; ?>">
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
                                    </div>

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

                    $category_name = $_POST["category_name"];

                    $sql = "INSERT INTO category (category_name) VALUES('$category_name')";
                    $data = mysqli_query($conn, $sql);
                    if ($data) {
                        echo "<script>alert('Category Added Successfully.'); window.location.href='category.php';</script>";
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

	</body>
</html>