import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/circuledButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/divider.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/screens/customWidgets/googleSignInButton.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:flutterprojectfinal/services.dart/auth.dart';
import 'package:toastification/toastification.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool isPasswordVisible = true;

  void handleSignUP() {
    // Implement SignUp
    AuthMethods.signupEmailandPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    ).then((value) async {
      toastification.show(
        context: context,
        title: Text(value),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }).catchError((error) {
      toastification.show(
        context: context,
        title: Text(error.toString()),
        autoCloseDuration: const Duration(seconds: 5),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/login-background-squares.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 72),
              Text(
                "SignUp",
                style: TextStyle(fontSize: 24, color: gray),
              ),
              SizedBox(height: 32),
              Form(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      customFormField(
                        controller: _emailController,
                        label: 'Email',
                        prefix: Icons.email,
                        type: TextInputType.emailAddress,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Email must not be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      customFormField(
                        controller: _passwordController,
                        label: 'Password',
                        prefix: Icons.lock,
                        isPassword: isPasswordVisible,
                        suffix: isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        suffixPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        type: TextInputType.visiblePassword,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Password is too short';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              GoogleSignInButton(
                onPressed: () {
                  // Implement Google Sign In
                },
              ),
              SizedBox(height: 32),
              CustomButton(label: 'SignUp', press: handleSignUP),
            ],
          ),
        ),
      ),
    );
  }
}
