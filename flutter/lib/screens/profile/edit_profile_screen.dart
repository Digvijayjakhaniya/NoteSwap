import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:noteswap/screens/profile/user_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email_id;
  final String phone;
  final String location;
  final String profilePicture;

  EditProfileScreen({
    required this.name,
    required this.email_id,
    required this.phone,
    required this.location,
    required this.profilePicture,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController usernameController;
  late TextEditingController email_idController;
  late TextEditingController contactController;
  late TextEditingController locationController;
  String profile_picture = '';

  String? newProfilePicturePath;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.name);
    email_idController = TextEditingController(text: widget.email_id);
    contactController = TextEditingController(text: widget.phone);
    locationController = TextEditingController(text: widget.location);
    profile_picture = widget.profilePicture;
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

  Future<void> _selectNewProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        newProfilePicturePath = pickedFile.path;
        // String i = profile_picture;
        // String imageUrl =
        //     'https://noteswapxyz.000webhostapp.com/admin/user_profile_picture/';

        // imageUrl += i;

        // // Update imageUrl with the new path
        // imageUrl = imageUrl;
      });
    }
  }

  Future<void> _saveChanges() async {
    // Prepare the data to be sent to the PHP API
    FocusScope.of(context).unfocus();

    var formData = {
      'username': usernameController.text,
      'email_id': email_idController.text,
      'contact': contactController.text,
      'location': locationController.text,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? email = await prefs.getString("email_id");
    // Create a multipart request
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://noteswapxyz.000webhostapp.com/api/profile_edit.php?email=${email ?? ""}'));

    // Add form fields
    formData.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add profile picture file to request if profile_picture is not empty
    if (newProfilePicturePath != null && newProfilePicturePath!.isNotEmpty) {
      // Convert the file to bytes
      List<int> imageBytes = await File(newProfilePicturePath!).readAsBytes();
      // Create a multipart file from bytes
      var multipartFile = http.MultipartFile.fromBytes(
        'profile_picture',
        imageBytes,
        filename: profile_picture.split('/').last,
      );
      // Add the file to the request
      request.files.add(multipartFile);
    }

    // Send the HTTP POST request to the PHP API
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      var responseData = jsonDecode(response.body);

      // Check the status from the response
      if (responseData['status'] == 'Success') {
        // Show success message and navigate back
        showSnackBar(
            responseData['message'], Colors.green, Icons.check_circle_rounded);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const UserProfileScreen(),
          ),
        );
      } else {
        // Show error message
        showSnackBar(responseData['message'], Colors.red, Icons.error);
      }
    } else {
      // Show error message if request failed
      showSnackBar('Failed to update user', Colors.red, Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    String i = profile_picture;
    String imageUrl =
        'https://noteswapxyz.000webhostapp.com/admin/user_profile_picture/';

    if (i.isNotEmpty) {
      imageUrl += i;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xffA33DBA),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xffA33DBA),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _selectNewProfilePicture();
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: 60,
                  child: Hero(
                    tag: 'profile_picture_edit_profile_screen',
                    child: ClipOval(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: newProfilePicturePath != null &&
                                newProfilePicturePath!.isNotEmpty
                            ? Image.file(
                                File(newProfilePicturePath!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 60,
                                  );
                                },
                              )
                            : Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 60,
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              Text('click on image for change'),
              const SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              // TextFormField(
              //   controller: email_idController,
              //   decoration: InputDecoration(labelText: 'Email'),
              // ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveChanges(); // Call _saveChanges function
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
