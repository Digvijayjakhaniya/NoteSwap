<?php include_once('redirect.php') ?>

<!doctype html>
<html lang="en" dir="ltr">
    
	<?php include('layout/head.php') ?>

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
									<h1 class="page-title">Products</h1>
									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="javascript:void(0);">APPS</a></li>
										<li class="breadcrumb-item active" aria-current="page">Products</li>
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
                                            <h4 class="card-title">Products Details</h4>
                                        </div>
                                        <div class="col md-2" style="display:flex; justify-content:right;">
                                            <button type="button" class="btn btn-outline-success" data-bs-toggle="modal" data-bs-target="#exampleModal" style="padding: 2px;">
                                                Create New Products
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
                                                    <h5 class="modal-title" id="exampleModalLabel">Create New Products</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <form action="" method="POST" enctype="multipart/form-data">

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label">Product Name</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Product Name" name="title" required>
                                                        </div>

                                                        
                                                        <label for="exampleFormControlInput1" class="form-label">Product Images</label>

                                                        <div class="input-group mb-3">
                                                            <input type="file" class="form-control" id="inputGroupFile02" name="product_image[]" accept="image/*" multiple>
                                                            <label class="input-group-text" for="inputGroupFile02">Upload</label>
                                                        </div>
                                                        
                                                        <?php
                                                            include("../config/config.php");
                                                            error_reporting(0);
                                                            $result = mysqli_query($conn,"SELECT * FROM category");
                                                            if (mysqli_num_rows($result) > 0) {
                                                        ?>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Category</label>
                                                            <div class="form-control">
                                                                <select name="category" >
                                                                    <option value="" disabled selected>Category</option>
                                                                <?php
                                                                $i = 1;
                                                                while ($row = mysqli_fetch_array($result)) {
                                                                ?>
                                                                    <option value="<?php echo $row["category_name"]; ?>"><?php echo $row["category_name"]; ?></option>
                                                                <?php } ?></select>
                                                            </div>
                                                        </div>
                                                        <?php
                                                            }
                                                            else{
                                                                echo "No result found";
                                                            }
                                                        ?>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Price</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Price" name="price" required>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Description</label>
                                                            <textarea type="text" class="form-control" id="exampleFormControlInput1" placeholder="Description" name="description" ></textarea>
                                                        </div>


                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Location</label>
                                                            <textarea type="text" class="form-control" id="exampleFormControlInput1" placeholder="Location" name="location" ></textarea>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label">Seller Id</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Seller Id" name="seller_id" >
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
                                        include("../config/config.php");
                                        error_reporting(0);
                                        $result = mysqli_query($conn,"SELECT * FROM product");
                                    ?>
                                    <?php
                            if (mysqli_num_rows($result) > 0) {
                            ?>
                                    <table id="datatable" class="table table-bordered dt-responsive  nowrap w-100" style="text-align: center;">

                                        <thead>
                                            <tr>
                                                <th>No.</th> 
                                                <th>Product Id </th>
                                                <th>Product Name</th>
                                                <th>Product Images</th>
                                                <th>Category</th>
                                                <th>Price</th>
                                                <th>Description</th>
                                                <th>Location</th>
                                                <th>Post Date</th>
                                                <th>Seller Id</th>
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
                                                    <td><?php echo $row["product_id"]; ?></td>
                                                    <td><?php echo $row["title"]; ?></td>
                                                    <td style="width: 100px;">
                                                        <?php
                                                        // Explode the comma-separated image names into an array
                                                        $image_names = explode(',', $row["product_image"]);

                                                        // Loop through the array and display each image
                                                        foreach ($image_names as $image_name) {
                                                            echo '<img src="product_picture/' . $image_name . '" ><br>';
                                                        }
                                                        ?>
                                                    </td>
                                                    <td><?php echo $row["category"]; ?></td>
                                                    <td><?php echo $row["price"]; ?></td>
                                                    <td><?php echo $row["description"]; ?></td>
                                                    <td><?php echo $row["location"]; ?></td>
                                                    <td><?php echo $row["postdate"]; ?></td>
                                                    <td><?php echo $row["seller_id"]; ?></td>
                                                    <td>
                                                    <a href="product_update.php?product_id=<?php echo $row["product_id"]; ?>">
                                                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-edit">
                                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                                            </svg>
                                                        </a>
                                                        <a class="text-danger" href="delete_product.php?product_id=<?php echo $row["product_id"]; ?>">
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

                    // Check if files are uploaded
                    if (!empty($_FILES["product_image"]["name"])) {
                        $file_names = [];

                        $file_count = count($_FILES["product_image"]["name"]);

                        // Loop through each file
                        for ($i = 0; $i < $file_count; $i++) {
                            $tmp_file = $_FILES["product_image"]["tmp_name"][$i];
                            $file_name = $_FILES["product_image"]["name"][$i];

                            // Move the file to the destination folder
                            move_uploaded_file($tmp_file, "product_picture/" . $file_name);

                            // Store the file name in the array
                            $file_names[] = $file_name;
                        }

                        // Combine file names into a comma-separated string
                        $product_image = implode(',', $file_names);
                    }

                    // Other form data processing
                    $title = $_POST["title"];
                    $category = $_POST["category"];
                    $price = $_POST["price"];
                    $description = $_POST["description"];
                    $location = $_POST["location"];
                    $seller_id = $_POST["seller_id"];

                    // Perform database insertion with other form data and image names
                    $sql = "INSERT INTO product (title, product_image, category, price, description, location, seller_id) VALUES ('$title', '$product_image', '$category', '$price', '$description', '$location', '$seller_id')";

                    $data = mysqli_query($conn, $sql);

                    // Handle success or failure
                    if ($data) {
                        echo "<script>alert('Product Created Successfully.'); window.location.href='product.php';</script>";
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

	</body>
</html>