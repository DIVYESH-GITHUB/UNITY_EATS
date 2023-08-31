import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:unity_eats/screens/admin/admin_home_screen.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';

class AdminLogIn {
  String username;
  String password;
  BuildContext context;
  RoundedLoadingButtonController adminLoginController;
  AdminLogIn({
    required this.context,
    required this.adminLoginController,
    required this.username,
    required this.password,
  });
  logIn() {
    if (username == 'admin' && password == 'admin') {
      Get.off(const AdminHomeScreen());
    }
    else{
      errorSnackBar(context, 'Wrong Credentials');
      adminLoginController.reset();
      return;
    }
  }

  validate() {
    if (password.isEmpty || username.isEmpty) {
      errorSnackBar(context, 'Some of the fields are empty!');
      adminLoginController.reset();
      return;
    }
    logIn();
  }
}
