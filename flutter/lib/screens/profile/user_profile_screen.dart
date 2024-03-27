// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteswap/screens/authentication/login.dart';
import 'package:noteswap/screens/home/home_screen.dart';
import 'package:noteswap/screens/product/user_product.dart';
import 'package:noteswap/screens/profile/edit_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  String username;
  String email_id;
  String contact;
  String location;
  String profile_picture;

  // Add more fields as needed

  UserData({
    required this.username,
    required this.email_id,
    required this.contact,
    required this.location,
    required this.profile_picture,

    // Add more fields as needed
  }) {}

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      username: json['username'],
      email_id: json['email_id'],
      contact: json['contact'],
      location: json['location'],
      profile_picture: json['profile_picture'],
    );
  }
}

class UserService {
  static Future<UserData> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? email = await prefs.getString("email_id");
    final url =
        'https://noteswapxyz.000webhostapp.com/api/profile.php?email=${email ?? ""}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> userDataJson = jsonDecode(response.body);
      if (userDataJson.isNotEmpty) {
        Map<String, dynamic> userDataMap = userDataJson.first;
        // Convert JSON data to UserData object
        UserData userData = UserData.fromJson(userDataMap);
        return userData;
      } else {
        throw Exception('User data not found');
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load user data');
    }
  }
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      UserData userData = await UserService.fetchUserData();
      setState(() {
        _userData = userData;
      });
    } catch (e) {
      print('Failed to fetch user data: $e');
      // Handle error
    }
  }

  // String username = 'Digvijay';
  // String email_id = 'digvijay@gmail.com';
  // String contact = '9761245211';
  // String location = 'Ahmedabad, Gujarat';
  // String profile_picture = 'assets/images/favicon-wobg.png';

  Future<void> logout() async {
    final response = await http.get(
      Uri.parse(
          'https://noteswapxyz.000webhostapp.com/api/login.php?action=logout'),
    );

    final responseData = json.decode(response.body);
    if (responseData['status'] == 'success') {
      // Remove login state locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('email_id');

      // Navigate back to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Handle logout failure
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Failed'),
            content: Text(responseData['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> _onWillPop() async {
    // Navigate to the home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
    return false; // Prevent default behavior of back button
  }

  @override
  Widget build(BuildContext context) {
    String i = _userData?.profile_picture ?? '';
    String imageUrl =
        'https://noteswapxyz.000webhostapp.com/admin/user_profile_picture/';
    imageUrl += i.toString();
    return Theme(
      data: ThemeData.light(),
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Color(0xffA33DBA),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Color(0xffA33DBA),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Color(0xffA33DBA),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                              name: _userData?.username ?? '',
                              email_id: _userData?.email_id ?? '',
                              phone: _userData?.contact ?? '',
                              location: _userData?.location ?? '',
                              profilePicture: _userData?.profile_picture ?? '',
                            )),
                  ).then((editedData) {
                    // Handle the data returned from the edit screen
                    if (editedData != null) {
                      setState(() {
                        _userData!.username = editedData['name'];
                        _userData!.email_id = editedData['email_id'];
                        _userData!.contact = editedData['phone'];
                        _userData!.location = editedData['location'];
                        _userData!.profile_picture =
                            editedData['profilePicture'];
                      });
                    }
                  });
                },
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              CircleAvatar(
                backgroundColor: Colors.black12,
                radius: 60,
                child: Hero(
                  tag: 'profile_picture_user_profile_screen',
                  child: ClipOval(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: _userData?.profile_picture != null
                          ? Image.network(
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
                            )
                          : Icon(
                              Icons.person,
                              size: 60,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _userData?.username ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5,
                ),
              ),
              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(color: Colors.black12),
              ),
              // Render email if not empty
              if (_userData?.email_id?.isNotEmpty ?? false)
                InfoCard(
                  text: _userData?.email_id ?? '',
                  icon: Icons.email,
                  iconColor: Color(0xffA33DBA),
                  onPressed: () {},
                ),
              // Render contact if not empty
              if (_userData?.contact?.isNotEmpty ?? false)
                InfoCard(
                  text: _userData!.contact,
                  icon: Icons.phone,
                  iconColor: Color(0xffA33DBA),
                  onPressed: () {},
                ),
              // Render location if not empty
              if (_userData?.location?.isNotEmpty ?? false)
                InfoCard(
                  text: _userData?.location ?? '',
                  icon: Icons.location_city,
                  iconColor: Color(0xffA33DBA),
                  onPressed: () {},
                ),
              SizedBox(height: 30),
              InfoCard(
                text: 'My Products',
                icon: Icons.inventory_outlined,
                iconColor: Color(0xffA33DBA),
                backgroundColor: Colors.transparent,
                textColor: Color(0xffA33DBA),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductPage()),
                  );
                },
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextButton.icon(
                    onPressed: () {
                      logout();
                    },
                    icon: const Icon(
                      Icons.exit_to_app,
                      size: 24,
                      color: Color(0xffA33DBA),
                    ),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xffA33DBA),
                      ),
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                        (states) => const Color(0x10A33DBA),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor; // Added property for background color
  final Color? textColor; // Added property for text color
  final Function onPressed;

  const InfoCard({
    Key? key,
    required this.text,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Card(
        color: backgroundColor,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
