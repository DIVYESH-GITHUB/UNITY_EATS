import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

errorSnackBar(BuildContext context, String message) {
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      textAlign: TextAlign.start,
      textStyle: const TextStyle(
        letterSpacing: 1,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      message: message,
    ),
  );
}
