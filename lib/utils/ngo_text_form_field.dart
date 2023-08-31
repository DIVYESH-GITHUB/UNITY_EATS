import 'package:flutter/material.dart';

ngoTextFormField(
  TextEditingController controller,
  String hint,
  int maxLines,
  TextInputType inputType,
  bool obscure,
) {
  return TextFormField(
    style: const TextStyle(
      letterSpacing: 1,
    ),
    controller: controller,
    maxLines: maxLines,
    keyboardType: inputType,
    obscureText: obscure,
    decoration: InputDecoration(
      filled: true,
      isDense: true,
      fillColor: Colors.grey.withOpacity(0.15),
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white,
        letterSpacing: 1,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
        ),
      ),
    ),
  );
}
