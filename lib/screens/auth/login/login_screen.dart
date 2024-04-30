import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/events/add_events/add_events.dart';
import 'package:flutterprojectfinal/screens/auth/admin/adminPage.dart';
import 'package:flutterprojectfinal/screens/auth/forgotpassword/forgotpassword.dart';
import 'package:flutterprojectfinal/screens/auth/signup/signup_screen.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/screens/customWidgets/googleSignInButton.dart';
import 'package:flutterprojectfinal/services/auth.dart';
import 'package:flutterprojectfinal/services/provider/userCredentialProvider.dart';
import 'package:flutterprojectfinal/ui/homepage/page_render.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:flutterprojectfinal/validators/authValidators.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      response = await AuthMethods.checkAdmin(email, pass);
      if (response == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(),
          ),
        );
      }
      response = await AuthMethods.loginWithEmailAndPassword(
          dialogcontext, email, pass);
      if (isSwitched) {
        response = await AuthMethods.checkOrganiser(email);
      }

      if (response == "success") {
        if (isSwitched) {
          print("here...");
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setBool("isOrganizer", true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PageRender(
                isLoggedInAsOrganizer: true,
              ),
            ),
          );
          return;
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PageRender(
                isLoggedInAsOrganizer: false,
              ),
            ),
          );
          return;
        }
      } else {
        toastification.show(
          context: dialogcontext,
          title: Text(response),
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  void handleGoogleSignIn(BuildContext context) async {
    var response;
    response = await AuthMethods.signInWithGoogle(context);
    if (isSwitched) {
      UserCredential? userCredential =
          Provider.of<UserCredentialProvider>(context, listen: false)
              .userCredential;
      response =
          await AuthMethods.checkOrganiser(userCredential?.user?.email ?? "");
    }

    if (response == "success") {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("isOrganizer", isSwitched);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PageRender(
            isLoggedInAsOrganizer: isSwitched,
          ),
        ),
      );
    } else {
      toastification.show(
        context: context,
        title: Text(response),
        autoCloseDuration: const Duration(seconds: 5),
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
                "Welcome to EventSphere!",
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
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Align(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPassword(
                            email: _emailController.text.toString().trim()),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                label: Text('Login',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                press: () {
                  if (_formKey.currentState!.validate()) {
                    handleLogin(context);
                  }
                },
              ),
              SizedBox(height: 12),
              Text('Or continue with:'),
              SizedBox(height: 10),
              GoogleSignInButton(
                onPressed: () {
                  handleGoogleSignIn(context);
                },
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Transform.translate(
                        offset: Offset(-8, 0),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
