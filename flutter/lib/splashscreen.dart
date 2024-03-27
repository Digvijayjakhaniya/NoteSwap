import 'package:flutter/material.dart';
import 'package:noteswap/screens/authentication/login.dart';
import 'package:noteswap/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          bool isLoggedIn =
              snapshot.data != null ? snapshot.data as bool : false;
          return isLoggedIn ? Home() : LoginScreen();
        }
      },
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('email_id');
  }
}
