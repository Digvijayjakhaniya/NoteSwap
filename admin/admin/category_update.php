<?php include_once('redirect.php') ?>
<!doctype html>
<html lang="en" dir="ltr">
    
<?php include('layout/head.php') ?>

    <?php
		include("../config/config.php");
        error_reporting(0);
        $category_id = $_GET['category_id'];
        $record = mysqli_query($conn, "SELECT * FROM category WHERE category_id='$category_id'");
        $row = mysqli_fetch_array($record);
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
									<h1 class="page-title">Update Category</h1>
									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="javascript:void(0);">APPS</a></li>
										<li class="breadcrumb-item active" aria-current="page">Update Category</li>
									</ol>
								</div>
							</div>
							<!-- PAGE-HEADER END -->
                        <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <!-- Modal -->
                                    <div id="exampleModal" aria-labelledby="exampleModalLabel">
                                        <!-- <div class="modal-dialog"> -->
                                            <!-- <div class="modal-content"> -->
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="exampleModalLabel">Update Category</h5>
                                                </div>
                                                    <form action="" method="POST" enctype="multipart/form-data">

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label">Category Name</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Category Name" name="category_name" required value="<?php echo $row["category_name"]; ?>">
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
    // if (isset($_POST["submit"])) {

        $category_name = $_POST["category_name"];

    $sql = "UPDATE category SET category_name='$category_name' WHERE category_id='$category_id'";


    $data = mysqli_query($conn, $sql);
    if ($data) {
        echo "<script>alert('Category Updated'); window.location.href='category.php';</script>";
    } else {
        echo "<script>alert('Failed');</script>";
    }
}

?>
			<?php include('layout/footer.php') ?>

		</div>

				
		<!-- BACK-TO-TOP -->
		<a href="#top" id="back-to-top"><i class="fa fa-angle-up"></i></a>

		<?php include('layout/script.php') ?>

	</body>
</html>