import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:noteswap/screens/product/add_products.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  int productId;
  String name;
  double price;
  List<String> imageUrls;
  String description;
  String selectedCategory;

  Product(this.productId, this.name, this.price, this.imageUrls,
      this.description, this.selectedCategory);
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchCategories();
  }

  List<Map<String, dynamic>> category = [];

  Future<void> fetchCategories() async {
    final url = 'https://noteswapxyz.000webhostapp.com/api/category.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> categoriesJson = jsonDecode(response.body);
      setState(() {
        category.clear();
        category.addAll(List<Map<String, dynamic>>.from(categoriesJson));
      });
    } else {
      // Handle errors
      print('Failed to load categories: ${response.statusCode}');
    }
  }

  Future<void> fetchProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString("email_id");

      // Make HTTP GET request to fetch products
      final response = await http.get(Uri.parse(
          'https://noteswapxyz.000webhostapp.com/api/user_product.php?email=${email ?? ""}'));

      if (response.statusCode == 200) {
        // Parse JSON response

        List<dynamic> data = jsonDecode(response.body);
        // Convert JSON data to Product objects
        if (data != null && data.isNotEmpty) {
          List<Product> fetchedProducts = data.map((item) {
            // Check for null values in the data before constructing the Product object
            int productId = item['product_id'];
            String name = item['title'] ?? '';
            double price = (item['price'] is String)
                ? double.tryParse(item['price'] ?? '0.0') ?? 0.0
                : (item['price'] ?? 0.0).toDouble();
            List<String> imageUrls =
                List<String>.from(item['product_image'] ?? []);
            String description = item['description'] ?? '';
            String selectedCategory = item['category'] ?? '';

            return Product(
              productId,
              name,
              price,
              imageUrls,
              description,
              selectedCategory,
            );
          }).toList();

          // Update state with fetched products
          setState(() {
            products = fetchedProducts;
          });
        } else {
          // Handle case where data is empty or null
          print('Data is empty or null');
        }
      } else {
        // Handle error response
        print('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      print('Error fetching products: $e');
    }
  }

  void showSnackBar(String message, Color popupcolor, IconData popupicon) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            popupicon,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16, // Adjust font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: popupcolor,
      duration: Duration(seconds: 3), // Show for 3 seconds
    ));
  }

  void _addProduct(Product product) {
    setState(() {
      products.add(product);
    });
  }

  // void _deleteProduct(int index) {
  //   setState(() {
  //     products.removeAt(index);
  //   });
  // }
  void deleteProduct(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteProduct(index); // Call the delete function
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) async {
    try {
      final productId = products[index].productId;
      final response = await http.get(Uri.parse(
          'https://noteswapxyz.000webhostapp.com/api/delete_product.php?product_id=$productId'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        bool success = data['success'] ?? false;
        if (success) {
          showSnackBar(
            data['message'],
            Colors.green,
            Icons.check_circle_rounded,
          );
          setState(() {
            products.removeAt(index);
          });
        } else {
          showSnackBar(
            data['message'],
            Colors.red,
            Icons.error,
          );
        }
      } else {
        print('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void _updateProduct(int index, Product updatedProduct) {
    setState(() {
      products[index] = updatedProduct;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Products',
          style: TextStyle(
            color: Color(0xffA33DBA),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xffA33DBA),
        ),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Product product = products[index];
          String firstImage =
              product.imageUrls.isNotEmpty ? product.imageUrls[0] : '';
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: ListTile(
              title: Text(
                product.name.isNotEmpty ? product.name : '',
                maxLines: 1,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.0),
                  Text(
                    product.description.isNotEmpty ? product.description : '',
                    maxLines: 2,
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    product.selectedCategory.isNotEmpty
                        ? product.selectedCategory
                        : '',
                    style: TextStyle(color: Colors.green),
                  ),
                  Text('\₹${product.price.toStringAsFixed(2)}',
                      style: TextStyle(color: Color(0xffA33DBA))),
                ],
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.black12,
                radius: 30,
                child: ClipOval(
                  child: product.imageUrls.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Image.network(
                            'https://noteswapxyz.000webhostapp.com/admin/product_picture/$firstImage',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Placeholder(),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.green,
                    onPressed: () async {
                      Product? updatedProduct = await showDialog<Product>(
                        context: context,
                        builder: (BuildContext context) {
                          return _buildUpdateDialog(product);
                        },
                      );

                      if (updatedProduct != null) {
                        _updateProduct(index, updatedProduct);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      deleteProduct(index);
                      // _deleteProduct(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Product? newProduct = await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );

          if (newProduct != null) {
            _addProduct(newProduct);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildUpdateDialog(Product product) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _priceController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    List<XFile> selectedImages = []; // Define selectedImages here

    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _descriptionController.text = product.description;

    String selectedCategory = product.selectedCategory;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        Future<void> _pickImages() async {
          try {
            List<XFile>? pickedImages =
                await ImagePicker().pickMultiImage(imageQuality: 50);

            if (pickedImages != null) {
              setState(() {
                if (pickedImages.isNotEmpty) {
                  // Clear existing images if new images are picked
                  selectedImages.clear();
                  // Add newly picked images
                  selectedImages.addAll(pickedImages);
                }
                // Print paths of selected images
                List<String> imagePaths =
                    selectedImages.map((image) => image.path).toList();
                print(imagePaths);
              });
            }
          } catch (e) {
            print('Error picking images: $e');
          }
        }

        List<String> imagePaths = [];
        for (var file in selectedImages) {
          imagePaths.add(file.path);
        }
        Future<bool> _updateProductAPI(
          int productId,
          Product updatedProduct,
          List<XFile> selectedImages,
        ) async {
          try {
            final url =
                'https://noteswapxyz.000webhostapp.com/api/edit_product.php';

            var request = http.MultipartRequest('POST', Uri.parse(url));

            request.fields['product_id'] = productId.toString();
            request.fields['title'] = updatedProduct.name;
            request.fields['category'] = updatedProduct.selectedCategory;
            request.fields['price'] = updatedProduct.price.toString();
            request.fields['description'] = updatedProduct.description;

            // Add images to the request only if new images are selected
            if (selectedImages.isNotEmpty) {
              for (var i = 0; i < selectedImages.length; i++) {
                var image = selectedImages[i];
                var stream = http.ByteStream(image.openRead());
                var length = await image.length();

                var multipartFile = http.MultipartFile(
                  'product_image[$i]', // Adjust the field name as per your server's requirements
                  stream,
                  length,
                  filename: image.path.split('/').last,
                );

                request.files.add(multipartFile);
                print('file name : ${multipartFile.filename}');
              }
            }

            var response = await request.send();

            if (response.statusCode == 200) {
              var responseData = await response.stream.bytesToString();
              var data = jsonDecode(responseData);
              bool success = data['success'] ?? false;
              if (success) {
                showSnackBar(
                  data['message'],
                  Colors.green,
                  Icons.check_circle_rounded,
                );
                return true;
              } else {
                showSnackBar(
                  data['message'],
                  Colors.red,
                  Icons.error,
                );
                return false;
              }
            } else {
              print('Failed to update product: ${response.statusCode}');
              return false;
            }
          } catch (e) {
            print('Error updating product: $e');
            return false;
          }
        }

        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Update Product'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Product Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Product Description'),
                  maxLines: 3,
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    }
                  },
                  items: category.map<DropdownMenuItem<String>>((category) {
                    return DropdownMenuItem<String>(
                      value: category['category_name'],
                      child: Text(category['category_name']),
                    );
                  }).toList(),
                  hint: Text('Select Category'),
                ),
                ElevatedButton(
                  onPressed: _pickImages, // Handle image picking
                  child: Text('Update Images'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Images:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        // Display network images if selectedImages is empty
                        if (selectedImages.isEmpty)
                          ...product.imageUrls.map((url) => Image.network(
                                'https://noteswapxyz.000webhostapp.com/admin/product_picture/$url',
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )),
                        // Display newly selected images
                        ...selectedImages.map((image) => Image.file(
                              File(image.path),
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (selectedImages.isNotEmpty || selectedImages.isEmpty) {
                    bool success = await _updateProductAPI(
                      product.productId,
                      Product(
                        product.productId,
                        _nameController.text,
                        double.tryParse(_priceController.text) ?? 0.0,
                        selectedImages.map((image) => image.path).toList(),
                        _descriptionController.text,
                        selectedCategory,
                      ),
                      selectedImages,
                    );
                    if (success) {
                      Navigator.of(context).pop();
                      fetchProducts();
                    } else {
                      print('Error updating product');
                    }
                  } else {
                    // No images selected, proceed with updating other fields
                    bool success = await _updateProductAPI(
                      product.productId,
                      Product(
                        product.productId,
                        _nameController.text,
                        double.tryParse(_priceController.text) ?? 0.0,
                        product
                            .imageUrls, // Use existing image URLs without modifying
                        _descriptionController.text,
                        selectedCategory,
                      ),
                      selectedImages,
                    );
                    if (success) {
                      Navigator.of(context).pop();
                      fetchProducts();
                    } else {
                      print('Error updating product');
                    }
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }
}
