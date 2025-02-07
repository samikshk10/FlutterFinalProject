import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/validators/authValidators.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _changePassword(String oldPassword, String newPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: oldPassword,
      );
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      // If reauthentication succeeds, update the password
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      FlashMessage.show(context, message: "Password Changed");
      _resetForm();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw Exception('The password provided is too weak.');
        case 'requires-recent-login':
          throw Exception('To change your password, please login again.');
        case 'user-mismatch':
          throw Exception(
              'The old password provided does not match your current password.');
        case 'user-not-found':
          throw Exception('User not found. Please check your credentials.');
        default:
          throw Exception('Failed to change password: ${e.message}');
      }
    }
  }

  void _resetForm() {
    _passwordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Change Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24),
                  customFormField(
                    controller: _passwordController,
                    label: 'Current Password',
                    prefix: Icons.lock,
                    maxLines: 1,
                    isPassword: !_isOldPasswordVisible,
                    suffix: _isOldPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    suffixPressed: () {
                      setState(() {
                        _isOldPasswordVisible = !_isOldPasswordVisible;
                      });
                    },
                    type: TextInputType.visiblePassword,
                    validate: (String? value) {
                      final errors =
                          userSchema.catchErrors({"password": value});
                      return errors["password"];
                    },
                  ),
                  SizedBox(height: 24),
                  customFormField(
                    controller: _newPasswordController,
                    label: 'New Password',
                    prefix: Icons.lock,
                    maxLines: 1,
                    isPassword: !_isNewPasswordVisible,
                    suffix: _isNewPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    suffixPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                    type: TextInputType.visiblePassword,
                    validate: (String? value) {
                      final errors =
                          userSchema.catchErrors({"password": value});
                      return errors["password"];
                    },
                  ),
                  SizedBox(height: 24),
                  customFormField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    prefix: Icons.lock,
                    maxLines: 1,
                    isPassword: !_isConfirmPasswordVisible,
                    suffix: _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    suffixPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                    type: TextInputType.visiblePassword,
                    validate: (String? value) {
                      if (value != _newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      final errors =
                          userSchema.catchErrors({"password": value});
                      return errors["password"];
                    },
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10)),
                      child: Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        _changePassword(_passwordController.text,
                                _newPasswordController.text)
                            .catchError((onError) {
                          FlashMessage.show(context,
                              message: onError.toString());
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
