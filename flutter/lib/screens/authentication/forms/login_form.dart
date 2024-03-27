// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:noteswap/controllers/login_controller.dart';
import 'package:noteswap/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../forgot_password.dart';
import '../register.dart';

class LoginForm extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const LoginForm({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _autoValidate = false;

  Future<void> login() async {
    if (_validateFields()) {
      var url =
          Uri.parse('https://noteswapxyz.000webhostapp.com/api/login.php');
      var response = await http.post(url, body: {
        'email_id': email.text,
        'password': password.text,
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
          password.clear();
        });
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email_id', email.text);

        setState(() {
          showSnackBar(
              data['message'], Colors.green, Icons.check_circle_rounded);
        });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        });
      }
    }
  }

  bool _validateFields() {
    if (email.text.isEmpty || password.text.isEmpty) {
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: popupcolor,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final formKey = GlobalKey<FormState>();

    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmation'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            );
          },
        );
        if (shouldExit == true) {
          exit(0);
        }
        return !shouldExit;
      },
      child: Form(
        autovalidateMode:
            _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-wobg.png',
              width: widget.animationController.value * 200,
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
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
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
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
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 150,
                    child: FilledButton(
                      child: const Text('LogIn'),
                      onPressed: () async {
                        login();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
