// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:unity_eats/screens/NGO/ngo_home_screen.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';

class NgoLogIn {
  BuildContext context;
  String email;
  String password;
  RoundedLoadingButtonController ngoLoginController;

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  NgoLogIn({
    required this.email,
    required this.password,
    required this.context,
    required this.ngoLoginController,
  });

  logIn() async {
    try {
      await _db.collection('ngo').doc(email).get().then(
        (value) async {
          if (value.data() == null) {
            errorSnackBar(context, 'Ngo not found');
            ngoLoginController.reset();
            return;
          }
          if (!value.data()?['isEmailVerified']) {
            errorSnackBar(
                context, 'Email is not verified! please Signup again.');
            ngoLoginController.reset();
            return;
          }
          if (!value.data()?['isNgoVerified']) {
            errorSnackBar(
                context, 'Your Ngo is not yet verified by Unity Eats!');
            ngoLoginController.reset();
            return;
          }

          try {
            await _auth.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
            ngoLoginController.reset();
            Get.off(const NgoHomeScreen());
          } on FirebaseAuthException catch (e) {
            errorSnackBar(context, e.message.toString());
            ngoLoginController.reset();
            return;
          } catch (e) {
            errorSnackBar(context, 'Login Error! please try again');
            ngoLoginController.reset();
            return;
          }
        },
      );
    } catch (e) {
      errorSnackBar(context, e.toString());
      ngoLoginController.reset();
    }
  }

  validate() {
    if (email.isEmpty || password.isEmpty) {
      errorSnackBar(context, 'Some of the fields are empty!');
      ngoLoginController.reset();
    } else {
      logIn();
    }
  }
}
