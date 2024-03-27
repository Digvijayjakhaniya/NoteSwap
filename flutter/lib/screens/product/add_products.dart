import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:noteswap/screens/product/user_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<XFile> selectedImages = [];
  String? selectedCategory;

  bool _autoValidate = false;
  String? _errorMessage;

  Future<void> _pickImages() async {
    try {
      List<XFile>? pickedImages =
          await ImagePicker().pickMultiImage(imageQuality: 50);

      if (pickedImages != null) {
        setState(() {
          selectedImages = pickedImages;
        });
      }
    } catch (e) {
      print('Error picking images: $e');
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

  @override
  void initState() {
    super.initState();
    fetchCategories();
    _autoValidate = false; // Set autoValidate to false initially
  }

  Future<void> _saveProduct() async {
    setState(() {
      _autoValidate = true; // Set _autoValidate to true when attempting to save
    });
    if (_validateFields()) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? email = prefs.getString("email_id");

        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://noteswapxyz.000webhostapp.com/api/add_product.php?email=${email ?? ""}'));

        // Add product data
        request.fields['title'] = titleController.text;
        request.fields['category'] = selectedCategory!;
        request.fields['price'] = priceController.text;
        request.fields['description'] = descriptionController.text;

        // Add product images
        for (var image in selectedImages) {
          request.files.add(
              await http.MultipartFile.fromPath('product_image[]', image.path));
        }

        // Send request
        var response = await request.send();

        // Check if request was successful
        if (response.statusCode == 200) {
          // Parse the JSON response
          var responseData = jsonDecode(await response.stream.bytesToString());

          // Check the status from the response
          if (responseData['success']) {
            // Show success message and navigate back
            showSnackBar(responseData['message'], Colors.green,
                Icons.check_circle_rounded);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProductPage(),
              ),
            );
          } else {
            // Show error message
            showSnackBar(responseData['message'], Colors.red, Icons.error);
          }
        } else {
          // Show error message if request failed
          showSnackBar('Failed to add product', Colors.red, Icons.error);
        }
      } catch (e) {
        print('Error adding product: $e');
        // Show error message if an exception occurred
        showSnackBar('An error occurred', Colors.red, Icons.error);
      }
    }
  }

  bool _validateFields() {
    if (_autoValidate &&
        (selectedCategory == null ||
            titleController.text.isEmpty ||
            priceController.text.isEmpty ||
            descriptionController.text.isEmpty ||
            selectedImages.isEmpty)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: TextStyle(
            color: Color(0xffA33DBA), // Text color
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color(0xffA33DBA),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Product Title',
                  errorText: _autoValidate && titleController.text.isEmpty
                      ? 'Please enter a title'
                      : null,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Product Price',
                  errorText: _autoValidate && priceController.text.isEmpty
                      ? 'Please enter a price'
                      : null,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Product Description',
                  errorText: _autoValidate && descriptionController.text.isEmpty
                      ? 'Please enter a description'
                      : null,
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != 'Select Category') {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: 'Select Category',
                    child: Text('Select Category'),
                  ),
                  for (var cat in category)
                    DropdownMenuItem<String>(
                      value: cat['category_name'],
                      child: Text(cat['category_name']),
                    ),
                ],
                hint: Text('Select Category'),
              ),
              if (_autoValidate &&
                  selectedCategory == null) // Check if selectedCategory is null
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please select a category',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text(
                  'Add Images',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Background color
                ),
              ),
              if (_autoValidate && selectedImages.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please select at least one image',
                    style: TextStyle(color: Colors.red),
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
                    children: selectedImages
                        .map((image) => Image.file(
                              File(image.path),
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                  ),
                ],
              ),
              // if (_autoValidate && selectedImages.isEmpty)
              //   Padding(
              //     padding: const EdgeInsets.only(top: 8.0),
              //     child: Text(
              //       'Please select at least one image',
              //       style: TextStyle(color: Colors.red),
              //     ),
              //   ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveProduct, // Call function to save product
                child: Text(
                  'Save Product',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _validateFields()
                      ? Color(0xffA33DBA)
                      : const Color.fromARGB(
                          255, 238, 100, 100), // Background color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
