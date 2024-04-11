import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/auth/login/authState.dart';
import 'package:flutterprojectfinal/screens/customWidgets/circuledButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/divider.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/services.dart/auth.dart';
import 'package:flutterprojectfinal/ui/homepage/home_page.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Add this import statement

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool student = false;
    bool teacher = false;
    bool admin = false;
    bool _isLoading = false;
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    bool isPassword = true;
    String txt1 = "", txt2 = "";
    Pics pics = Pics();
    bool parent = false;

    void setstring() {
      _passwordController.text = txt2;
    }

    void handleLogin(BuildContext dialogcontext) async {
      try {
        String email = _emailController.text.toString().trim();
        String pass = _passwordController.text.toString().trim();
        var response = await AuthMethods.loginWithEmailAndPassword(email, pass);
        if (response == "success") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          Fluttertoast.showToast(
              msg: response,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/login-background-squares.png",
              ),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 72,
                  ),
                  // const Loginlabel(),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  Text(
                    "I am",
                    style: TextStyle(fontSize: 24, color: gray),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  // parent == false
                  //     ?
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(children: [
                        customFormField(
                          controller: _emailController,
                          label: 'Email',
                          prefix: Icons.email,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'email must not be empty';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        customFormField(
                          controller: _passwordController,
                          label: 'Password',
                          prefix: Icons.lock,
                          suffix: isPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          isPassword: isPassword,
                          suffixPressed: () {
                            setState(() {
                              isPassword = !isPassword;
                              print(txt2);
                              setstring;
                            });
                          },
                          type: TextInputType.visiblePassword,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'password is too short';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                    ),
                  ),
                  CustomButton(
                    label: 'Log in',
                    press: () {
                      handleLogin(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
