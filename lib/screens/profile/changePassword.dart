import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/validators/authValidators.dart';

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

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      //logic yeha hala mr simik shakyayaaya
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Password has been changed successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Center(
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
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
