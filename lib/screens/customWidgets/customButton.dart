import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required Function press,
    Key? key,
  })  : _press = press,
        super(key: key);

  final Function _press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _press.call(),
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 52,
        child: Center(
          child: Text(
            'log in',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              28.0,
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF939CF5),
                Color(0xFF636CEF),
              ],
            )),
      ),
    );
  }
}
