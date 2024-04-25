import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/events/add_events/add_events.dart';
import 'package:flutterprojectfinal/screens/auth/forgotpassword/forgotpassword.dart';
import 'package:flutterprojectfinal/screens/auth/signup/signup_screen.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/screens/customWidgets/googleSignInButton.dart';
import 'package:flutterprojectfinal/services/auth.dart';
import 'package:flutterprojectfinal/ui/homepage/page_render.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:flutterprojectfinal/validators/authValidators.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPassword = true;
  String emailError = "";
  String passwordError = "";
  bool isSwitched = false;
  final _formKey = GlobalKey<FormState>();

  void handleLogin(BuildContext dialogcontext) async {
    try {
      String email = _emailController.text.toString().trim();
      String pass = _passwordController.text.toString().trim();
      var response;
      response = await AuthMethods.loginWithEmailAndPassword(
          dialogcontext, email, pass);
      if (isSwitched) {
        response = await AuthMethods.checkOrganiser(email);
      }
      if (response == "success") {
        if (isSwitched) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventScreen(),
            ),
          );
        }
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
    } catch (error) {
      print(error);
    }
  }

  void handleGoogleSignIn(BuildContext context) async {
    var response = await AuthMethods.signInWithGoogle();
    print("thissss>>>>>> $response");

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
              Container(
                margin: EdgeInsets.only(left: 25),
                child: ListTile(
                  leading: Text(
                    'Login as Organizer',
                    style: TextStyle(fontSize: 12),
                  ),
                  title: Transform.translate(
                    offset: Offset(-80, 0),
                    child: Transform.scale(
                      scale: 0.7, // Adjust the scale factor as needed
                      child: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = !isSwitched;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
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
                        maxLines: 1,
                        isPassword: isPassword,
                        suffix: isPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        suffixPressed: () {
                          setState(() {
                            isPassword = !isPassword;
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
              Text(
                "Don't have an account?",
                style: TextStyle(fontSize: 20),
              ),
              CustomButton(
                  label: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
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
                label: Text(
                  "Login",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                press: () {
                  if (_formKey.currentState!.validate()) {
                    handleLogin(context);
                  }
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
