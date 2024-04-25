import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.press,
    Key? key,
  }) : super(key: key);

  final Function press;
  final Widget label;

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
          child: Center(child: label),
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
