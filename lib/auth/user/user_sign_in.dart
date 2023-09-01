// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:unity_eats/screens/auth_screens/email_verfication_screen.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';

class UserSignIn {
  BuildContext context;
  String userName;
  String email;
  String password;
  RoundedLoadingButtonController userLoginController;
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  UserSignIn({
    required this.userName,
    required this.email,
    required this.password,
    required this.context,
    required this.userLoginController,
  });

  signUp() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      try {
        await _db.collection('users').doc(email).set({
          'userName': userName,
          'email': email,
          'firstName': '',
          'middleName': '',
          'lastName': '',
          'phoneNumber': '',
          'address': '',
          'gender': '',
          'imageUrl': '',
          'totalDonations': 0,
          'completedDonation': 0,
          'rejectedDonation': 0,
          'emailVerified': false,
          'profileCompleted': false,
        });
        userLoginController.reset();
        Get.off(const EmailVerificationScreen());
      } on FirebaseAuthException catch (e) {
        errorSnackBar(context, e.message.toString());
        userLoginController.reset();
        return;
      } catch (e) {
        errorSnackBar(context, e.toString());
        userLoginController.reset();
        return;
      }
    } on FirebaseAuthException catch (e) {
      errorSnackBar(context, e.message.toString());
      userLoginController.reset();
      return;
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
      checkIfUserAlreadyExistButEmailNotVerfied();
    }
  }

  checkIfUserAlreadyExistButEmailNotVerfied() async {
    await _db.collection('users').doc(email).get().then((value) async {
      if (value.data() == null) {
        signUp();
      } else {
        if (value.data()?['emailVerified'] == false) {
          userLoginController.reset();
          Get.to(const EmailVerificationScreen());
        } else {
          userLoginController.reset();
          errorSnackBar(context, 'User already exists');
        }
      }
    });
  }
}
