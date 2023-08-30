import 'package:flutter/material.dart';

textFormField(
    TextEditingController controller,
    TextInputType type,
    Icon icon,
    String hintText,
    bool obscureText,
    bool enableSuggestions,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      style: const TextStyle(
        letterSpacing: 1,
      ),
      decoration: InputDecoration(
        prefixIcon: icon,
        prefixIconColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.85)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
