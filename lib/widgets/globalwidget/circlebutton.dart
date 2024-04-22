import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/app/configs/colors.dart';

class CircleButton extends StatelessWidget {
  final Icon icon;
  final Function() onTap;
  const CircleButton({required this.icon, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: icon),
    );
  }
}
