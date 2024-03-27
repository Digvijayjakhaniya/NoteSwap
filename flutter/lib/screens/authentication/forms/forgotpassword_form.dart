import 'package:noteswap/controllers/forgot_password_controller.dart';
// import 'package:e_attendance/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteswap/screens/authentication/register.dart';
import 'package:noteswap/screens/authentication/login.dart';

class ForgotPasswordForm extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const ForgotPasswordForm({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo-wobg.png',
            // height: animationController.value * 125,
            width: animationController.value * 200,
          ),
          const SizedBox(height: 40),
          const SizedBox(
            width: 350, // Adjust the width as needed
            child: Center(
              child: Text(
                'Trouble logging in?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  // fontStyle: FontStyle.italic,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(
            width: 350, // Adjust the width as needed
            child: Center(
              child: Text(
                "Enter your email and we'll send you a link to get back into your account.",
                style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontStyle: FontStyle.italic,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          // const Text(
          //   appName,
          //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          // ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: controller.email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Enter Your Email',
              ),
            ),
          ),
          const SizedBox(height: 25),
          FilledButton.icon(
            icon: const Icon(Icons.email),
            label: const Text('Send login link'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // ForgotPasswordController.instance
                // .resetPassword(controller.email.text.trim());
              }
            },
          ),
          const SizedBox(height: 250),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   "Don't have an account? ",
              //   style: TextStyle(color: Colors.black),
              // ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Create new account',
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Text(
              'Back to login',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
