import 'package:flutter/material.dart';

Widget customFormField({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword = false,
  required String? Function(String?) validate,
  required String label,
  IconData? prefix,
  bool readonly = false,
  String? errorText,
  IconData? suffix,
  int? maxLines,
  Function()? suffixPressed,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword && maxLines == 1, // Only obscure if single line
      validator: validate,
      readOnly: readonly,
      maxLines: maxLines,
      decoration: InputDecoration(
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(18),
        labelText: label,
        prefixIcon: prefix != null
            ? Icon(
                prefix,
                color: Color(0xFFD4D4D4),
              )
            : null,
        enabled: !readonly,
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                  color: Color(0xFFD4D4D4),
                ),
              )
            : null,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Color(0xFFD4D4D4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFF939CF5)),
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF939CF5),
        ),
        labelStyle: const TextStyle(color: Color(0xFFD4D4D4)),
      ),
    );
