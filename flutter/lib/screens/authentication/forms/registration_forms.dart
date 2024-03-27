import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:noteswap/screens/authentication/login.dart';

class RegistrationForm extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const RegistrationForm({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _autoValidate = false;

  Future<void> register() async {
    if (_validateFields()) {
      var url = Uri.parse(
          'https://noteswapxyz.000webhostapp.com/api/registration.php');
      var response = await http.post(url, body: {
        'username': name.text,
        'email_id': email.text,
        'contact': contact.text,
        'password': password.text
      });

      if (response.body.isEmpty) {
        showSnackBar('Error: Empty response body', Colors.red, Icons.error);
        return;
      }

      var data;
      try {
        data = json.decode(response.body);
      } catch (e) {
        print('Error decoding response: $e');
        print('Response body: ${response.body}');
        showSnackBar('Error: $e', Colors.red, Icons.error);
        return;
      }

      if (data['status'] == 'Error') {
        setState(() {
          showSnackBar(data['message'], Colors.red, Icons.error);
        });
      } else {
        setState(() {
          showSnackBar(
              data['message'], Colors.green, Icons.check_circle_rounded);
        });
        Future.delayed(const Duration(seconds: 3), () {
          name.clear();
          email.clear();
          contact.clear();
          password.clear();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        });
      }
    }
  }

  bool _validateFields() {
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        contact.text.isEmpty ||
        password.text.isEmpty) {
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
    return true;
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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog
        bool shouldExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // User wants to exit the app
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    // Close the dialog without taking any action
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            );
          },
        );

        // If the user wants to exit the app, exit
        if (shouldExit == true) {
          // Exit the app
          exit(0);
        }

        // Return whether the app should exit
        return !shouldExit;
      },
      child: Form(
        autovalidateMode:
            _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo-wobg.png',
              width: widget.animationController.value * 200,
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 350, // Adjust the width as needed
              child: Center(
                child: Text(
                  'Join us to explore opportunities in trading currency notes and vintage items.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (_autoValidate && !value.isEmpty) {
                    setState(() {
                      _autoValidate = false;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (_autoValidate && !value.isEmpty) {
                    setState(() {
                      _autoValidate = false;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: contact,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (_autoValidate && !value.isEmpty) {
                    setState(() {
                      _autoValidate = false;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                obscureText: true,
                controller: password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (_autoValidate && !value.isEmpty) {
                    setState(() {
                      _autoValidate = false;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 150,
                    child: FilledButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          register();
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Have an account?",
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Log in'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
