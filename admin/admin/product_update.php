<?php include_once('redirect.php') ?>

<!doctype html>
<html lang="en" dir="ltr">
    
	<?php include('layout/head.php') ?>

    <?php
		include("../config/config.php");
        error_reporting(0);
        $product_id = $_GET['product_id'];
        $record = mysqli_query($conn, "SELECT * FROM product WHERE product_id='$product_id'");
        $row = mysqli_fetch_array($record);
        $oldproduct_image = $row["product_image"];
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
									<h1 class="page-title">Update Product</h1>
									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="javascript:void(0);">APPS</a></li>
										<li class="breadcrumb-item active" aria-current="page">Update Product</li>
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
                                                    <h5 class="modal-title" id="exampleModalLabel">Update Product</h5>
                                                </div>
                                                    <form action="" method="POST" enctype="multipart/form-data">

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label">Product Name</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Product Name" name="title" value="<?php echo $row["title"];?>">
                                                        </div>

                                                        <label for="exampleFormControlInput1" class="form-label">Product Images</label>

                                                        <?php
                                                        // Explode the comma-separated image names into an array
                                                        $image_names = explode(',', $row["product_image"]);

                                                        // Loop through the array and display each image
                                                        foreach ($image_names as $image_name) {
                                                            echo '<img style="width: 100px;" src="product_picture/' . $image_name . '" >';
                                                        }
                                                        ?>

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
                                                                    <option value="" disabled>Category</option>
                                                                <?php
                                                                $i = 1;
                                                                while ($product = mysqli_fetch_array($result)) {
                                                                ?>
                                                                <option value="<?php echo $product["category_name"]; ?>" <?php if ($product["category_name"] === $row['category']) echo 'selected'; ?>><?php echo $product["category_name"]; ?></option>
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
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Price" name="price" value="<?php echo $row["price"];?>">
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Description</label>
                                                            <textarea type="text" class="form-control" id="exampleFormControlInput1" placeholder="Description" name="description" ><?php echo $row["description"];?></textarea>
                                                        </div>


                                                        <div class="mb-3">
                                                            <label for="exampleFormControlTextarea1" class="form-label">Location</label>
                                                            <textarea type="text" class="form-control" id="exampleFormControlInput1" placeholder="Location" name="location" ><?php echo $row["location"];?></textarea>
                                                        </div>

                                                        <div class="mb-3">
                                                            <label for="exampleFormControlInput1" class="form-label">Seller Id</label>
                                                            <input type="text" class="form-control" id="exampleFormControlInput1" placeholder="Seller Id" name="seller_id" value="<?php echo $row["seller_id"];?>" >
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
        // Get Product details from the form
        $title = $_POST["title"];
        $category = $_POST["category"];
        $price = $_POST["price"];
        $description = $_POST["description"];
        $location = $_POST["location"];
        $seller_id = $_POST["seller_id"];

        $oldproduct_image = $row["product_image"];

        // Check if new files are uploaded
        if (!empty($_FILES["product_image"]["name"][0])) {
            // Delete old files
            $oldImageNames = explode(',', $oldproduct_image);
            foreach ($oldImageNames as $oldFile) {
                if (!empty($oldFile) && file_exists("product_picture/" . $oldFile)) {
                    unlink("product_picture/" . $oldFile);
                }
            }

            // Move new files to the folder
            $newFileNames = [];
            foreach ($_FILES["product_image"]["name"] as $index => $newFileName) {
                $newFileNames[] = $newFileName;
                move_uploaded_file($_FILES["product_image"]["tmp_name"][$index], "product_picture/" . $newFileName);
            }

            // Update the Product record in the database
            $newProductImage = implode(',', $newFileNames);
        } else {
            // No new files uploaded, keep the existing ones
            $newProductImage = $oldproduct_image;
        }

        $sql = "UPDATE product SET title='$title', product_image='$newProductImage', category='$category',price='$price', description='$description',location='$location', seller_id='$seller_id' WHERE product_id='$product_id'";
        $data = mysqli_query($conn, $sql);

        if ($data) {
            echo "<script>alert('Product Updated'); window.location.href='product.php';</script>";
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

	</body>
</html>