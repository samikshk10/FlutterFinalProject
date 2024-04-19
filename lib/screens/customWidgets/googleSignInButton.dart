import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 52,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google-logo.png',
              height: 24.0,
            ),
            SizedBox(width: 18),
            Expanded(
              child: Text(
                'Google',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.0),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white,
              Color(0xFF636CEF),
            ],
          ),
        ),
      ),
    );
  }
}
