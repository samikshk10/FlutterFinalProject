import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.press,
    Key? key,
  }) : super(key: key);

  final Function press;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(28.0),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28.0),
        onTap: () => press.call(),
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 52,
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.0),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF939CF5),
                Color(0xFF636CEF),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
