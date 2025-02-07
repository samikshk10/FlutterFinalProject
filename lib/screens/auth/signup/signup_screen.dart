import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/services/auth.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:flutterprojectfinal/validators/authValidators.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';
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
  final TextEditingController _usernameController = TextEditingController();
  bool isPasswordVisible = true;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  void handleSignUP() async {
    // Implement SignUp
    setState(() {
      isLoading = true;
    });
    final response = await AuthMethods.signupEmailandPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim());

    if (response == "success") {
      FlashMessage.show(context,
          message: "Signup successfully",
          desc: "Please verify your email",
          isSuccess: true);
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    } else {
      FlashMessage.show(context,
          message: response.toString(),
          desc: "Please try again",
          isSuccess: false);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(""),
      ),
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
                        controller: _usernameController,
                        label: 'Username',
                        prefix: Icons.person,
                        type: TextInputType.text,
                        validate: (String? value) {
                          final errors =
                              userSchema.catchErrors({"username": value});
                          return errors["username"];
                        },
                      ),
                      SizedBox(height: 24),
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
              SizedBox(height: 32),
              CustomButton(
                label: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                press: () {
                  if (_formKey.currentState!.validate()) {
                    print("here");
                    handleSignUP();
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
