import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/services/auth.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  ResetPassword({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late String email;
  TextEditingController _emailController = TextEditingController();

  void handleResetPassword() async {
    AuthMethods authMethods = AuthMethods();
    authMethods
        .sendPasswordResetEmail(this.email)
        .then((value) => {print("password reset succesfuly")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Center(
                  child: Text(
                    'Reset Password',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Email',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: customFormField(
                  controller: _emailController,
                  type: TextInputType.text,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return "Please enter email";
                    }
                    return null;
                  },
                  label: 'Enter Email to Reset Password',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    child: Text(
                      "Send",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      handleResetPassword();
                    },
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
