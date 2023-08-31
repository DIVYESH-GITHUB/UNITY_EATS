// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unity_eats/auth/email_verfication_screen.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
// import 'package:unity_eats/auth/email_verfication_screen.dart';
import 'package:unity_eats/models/ngo_model.dart';
import 'package:unity_eats/screens/user/home_screen.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';

class NgoSignIn {
  BuildContext context;
  NgoModel ngoModel;
  String password;
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  NgoSignIn({
    required this.ngoModel,
    required this.password,
    required this.context,
  });

  signUp() async {
    try {
      final data = await _db.collection('ngo').doc(ngoModel.email).get();
      if (data.data() != null) {
        if (data.data()!['isEmailVerified'] == true) {
          errorSnackBar(context, 'Ngo is already registered');
          return;
        } else {
          Get.to(const EmailVerificationScreen());
          return;
        }
      } else {
        try {
          await _auth.createUserWithEmailAndPassword(
            email: ngoModel.email.toString(),
            password: password,
          );
          await _db.collection('ngo').doc(ngoModel.email).set(ngoModel.toMap());
          Get.to(const HomeScreen());
        } on FirebaseAuthException catch (e) {
          errorSnackBar(context, e.message.toString());
          return;
        } catch (e) {
          errorSnackBar(context, e.toString());
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      errorSnackBar(context, e.message.toString());
      return;
    } catch (e) {
      errorSnackBar(context, e.toString());
      return;
    }
  }
  
}
