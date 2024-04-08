import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/auth/login/authMethods.dart';
import 'package:flutterprojectfinal/screens/customWidgets/circuledButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/divider.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import statement

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
    /*Future<dynamic> Login(String email, String password) async {
      try {
        auth.UserCredential result = await auth.FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await firestore
                .collection(usersCollection)
                .doc(result.user?.uid ?? '')
                .get();
        User? user;
        if (documentSnapshot.exists) {
          user = User.fromJson(documentSnapshot.data() ?? {});
        }
        return user;
      } on auth.FirebaseAuthException catch (exception, s) {
        debugPrint('$exception$s');
        switch ((exception).code) {
          case 'invalid-email':
            return 'Email address is malformed.';
          case 'wrong-password':
            return 'Wrong password.';
          case 'user-not-found':
            return 'No user corresponding to the given email address.';
          case 'user-disabled':
            return 'This user has been disabled.';
          case 'too-many-requests':
            return 'Too many attempts to sign in as this user.';
        }
        return 'Unexpected firebase error, Please try again.';
      } catch (e, s) {
        debugPrint('$e$s');
        return 'Login failed, Please try again.';
      }
    } */

    void setstring() {
      _passwordController.text = txt2;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                        children: <Widget>[
                          circuledButton(
                              pic: pics.teacherGreyPic,
                              text: 'teacher',
                              background: gradientColor2,
                              icontextcolor: gray,
                              press: () {
                                setState(() {
                                  admin = false;
                                  teacher = true;
                                  student = false;
                                  parent = false;
                                });
                              }),
                          circuledButton(
                              pic: pics.studentGreyPic,
                              text: 'student',
                              background: gradientColor2,
                              icontextcolor: gray,
                              press: () {
                                setState(() {
                                  admin = false;
                                  teacher = false;
                                  student = true;
                                  parent = false;
                                });
                              }),
                          circuledButton(
                              pic: pics.parentGreyPic,
                              text: 'admin',
                              background: gradientColor2,
                              icontextcolor: gray,
                              press: () {
                                setState(() {
                                  admin = false;
                                  teacher = false;
                                  student = false;
                                  parent = true;
                                });
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    parent == false
                        ? Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Column(children: [
                                customFormField(
                                  controller: _emailController,
                                  label: 'Email',
                                  prefix: Icons.email,
                                  onChange: (String val) {
                                    print(_emailController.text);
                                    // _emailController.text=val;
                                  },
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
                                  onChange: (String val) {
                                    txt2 = _passwordController.text;
                                    //  _passwordController.text=val;
                                  },
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
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 32,
                              ),
                              Text(
                                "Choose Account",
                                style: TextStyle(fontSize: 12, color: blue),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              const DividerParent(
                                text: "Update your account",
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                    if (parent == false)
                      SizedBox(
                        height: 32,
                      ),
                    if (parent == false)
                      CustomButton(label: 'Log in', press: () {} //Login,
                          ),
                    if (parent == false)
                      SizedBox(
                        height: 32,
                      ),

                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
