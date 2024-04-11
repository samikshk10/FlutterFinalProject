import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/circuledButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/divider.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/screens/customWidgets/googleSignInButton.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:flutterprojectfinal/services.dart/auth.dart';
import 'package:flutterprojectfinal/validators/authValidators.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  final _formKey = GlobalKey<FormState>();
  void handleSignUP() {
    // Implement SignUp
    AuthMethods.signupEmailandPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    ).then((value) async {
      Fluttertoast.showToast(
          msg: value,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
                key: _formKey,
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
                          final errors =
                              userSchema.catchErrors({"email": value});
                          return errors["email"];
                        
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
                           final errors =
                              userSchema.catchErrors({"password": value});
                          return errors["password"];
                        },
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
              CustomButton(
                label: 'SignUp',
                press: () {
                  if (_formKey.currentState!.validate()) {
                    handleSignUP;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
