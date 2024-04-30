import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/validators/authValidators.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';

class ChangePasswordAdmin extends StatefulWidget {
  const ChangePasswordAdmin({super.key});

  @override
  State<ChangePasswordAdmin> createState() => _ChangePasswordAdminState();
}

class _ChangePasswordAdminState extends State<ChangePasswordAdmin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _changePassword(String password, String newPassword) async {
    CollectionReference admin = FirebaseFirestore.instance.collection('admin');

    final adminSnapshot = await FirebaseFirestore.instance
        .collection('admin')
        .where('email', isEqualTo: "admin@gmail.com")
        .get();

    if (!adminSnapshot.isNullOrEmpty) {
      final adminData = adminSnapshot.docs.first.data();
      print(adminData["password"]);

      if (adminData["password"] != password) {
        FlashMessage.show(context, message: "Incorrect old Password");
        return;
      } else {
        admin
            .doc(adminSnapshot.docs.first.id)
            .update({"password": newPassword});
        FlashMessage.show(context,
            message: "Password Changed Successfully", isSuccess: true);
        _resetForm();
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
                            _newPasswordController.text);
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
