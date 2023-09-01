// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:unity_eats/screens/user/home_screen.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CompleteUserProfile {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  BuildContext context;
  String firstName;
  String middleName;
  String lastName;
  String address;
  String gender;
  File image;
  RoundedLoadingButtonController getCurrentAddress;
  CompleteUserProfile({
    required this.context,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.address,
    required this.gender,
    required this.getCurrentAddress,
    required this.image,
  });
  validate() {
    if (firstName.isEmpty ||
        middleName.isEmpty ||
        lastName.isEmpty ||
        address.isEmpty ||
        gender.isEmpty) {
      getCurrentAddress.reset();
      errorSnackBar(context, 'Some of the fields are empty');
      return;
    }
    completeProfile();
  }

  completeProfile() async {
    try {
      final imageUrl = await uploadImageToStorage(image);

      if (imageUrl == null) {
        getCurrentAddress.reset();
        errorSnackBar(context, 'Image upload failed');
        return;
      }

      await _db.collection('users').doc(_auth.currentUser!.email).update({
        'profileCompleted': true,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'address': address,
        'gender': gender,
        'imageUrl': imageUrl, // Add the image URL here
      });

      getCurrentAddress.reset();
      Get.to(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      getCurrentAddress.reset();
      errorSnackBar(context, e.message.toString());
    } catch (e) {
      getCurrentAddress.reset();
      errorSnackBar(context, e.toString());
    }
  }

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      final storageRef =
          firebase_storage.FirebaseStorage.instance.ref().child('user_images/${_auth.currentUser!.email}');

      final uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => null);

      final downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
