import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/auth/forgotpassword/forgotpassword.dart';
import 'package:flutterprojectfinal/screens/auth/signup/signup_screen.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/screens/customWidgets/googleSignInButton.dart';
import 'package:flutterprojectfinal/services/auth.dart';
import 'package:flutterprojectfinal/ui/homepage/page_render.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:flutterprojectfinal/validators/authValidators.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = true;
  String emailError = "";
  String passwordError = "";
  final _formKey = GlobalKey<FormState>();

  void handleLogin(BuildContext dialogcontext) async {
    try {
      String email = _emailController.text.toString().trim();
      String pass = _passwordController.text.toString().trim();
      var response = await AuthMethods.loginWithEmailAndPassword(email, pass);
      if (response == "success") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PageRender(),
          ),
        );
      } else {
        toastification.show(
          context: context,
          title: Text(response),
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.code + "this is code");
      print(e.message);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'invalid-credential') {
        print('Wrong password provided for that user.');
      }
    }
  }

  handleGoogleSignIn(BuildContext context) async {
    var response = await AuthMethods.signInWithGoogle();
    print(response);
    if (response == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PageRender(),
        ),
      );
    }
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
                "Login",
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
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text("Don't have an account?", style: TextStyle(fontSize: 20),),
              CustomButton(
                  label: 'SignUp',
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  }),
              Text('Or continue with:'),
              SizedBox(height: 10),
              GoogleSignInButton(
                onPressed: () {
                  handleGoogleSignIn(context);
                },
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPassword(
                          email: _emailController.text.toString().trim()),
                    ),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 24),
              CustomButton(
                label: 'Login',
                press: () {
                  if (_formKey.currentState!.validate()) {
                    handleLogin(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
