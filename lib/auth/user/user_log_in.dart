// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:unity_eats/screens/auth_screens/user_complete_profile.screen.dart';
import 'package:unity_eats/screens/user/home_screen.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';

class UserLogIn {
  BuildContext context;
  String email;
  String password;
  RoundedLoadingButtonController userLoginController;

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  UserLogIn({
    required this.email,
    required this.password,
    required this.context,
    required this.userLoginController,
  });

  logIn() async {
    try {
      await _db.collection('users').doc(email).get().then(
        (value) async {
          if (value.data() == null) {
            errorSnackBar(context, 'User not found');
            userLoginController.reset();
            return;
          }
          if (!value.data()?['emailVerified']) {
            errorSnackBar(
                context, 'Email is not verified! please Signup again.');
            userLoginController.reset();
            return;
          } else {
            try {
              await _auth.signInWithEmailAndPassword(
                email: email,
                password: password,
              );
              if (value.data()?['profileCompleted'] == false) {
                userLoginController.reset();
                Get.off(() => const UserCompleteProfileScreen());
                return;
              }
              userLoginController.reset();
              Get.off(() => const HomeScreen());
              return;
            } on FirebaseAuthException catch (e) {
              errorSnackBar(context, e.message.toString());
              userLoginController.reset();
              return;
            } catch (e) {
              errorSnackBar(context, 'Login Error! please try again');
              userLoginController.reset();
              return;
            }
          }
        },
      );
    } catch (e) {
      errorSnackBar(context, e.toString());
      userLoginController.reset();
      return;
    }
  }

  validate() {
    if (email.isEmpty || password.isEmpty) {
      errorSnackBar(context, 'Some of the fields are empty!');
      userLoginController.reset();
    } else {
      logIn();
    }
  }
}
