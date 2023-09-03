// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';

class StoreFoodDetails {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  String foodDescription;
  String date;
  String time;
  String totalPersonCanFeed;
  String weight;
  String address;
  String foodSource;
  BuildContext context;
  RoundedLoadingButtonController controller;
  File image;
  StoreFoodDetails({
    required this.foodDescription,
    required this.date,
    required this.time,
    required this.totalPersonCanFeed,
    required this.weight,
    required this.address,
    required this.foodSource,
    required this.context,
    required this.controller,
    required this.image,
  });
  validate() async {
    if (foodDescription.isEmpty ||
        date.isEmpty ||
        time.isEmpty ||
        totalPersonCanFeed.isEmpty ||
        weight.isEmpty ||
        address.isEmpty ||
        foodSource.isEmpty) {
      errorSnackBar(context, 'Some of the fields are empty');
      controller.reset();
      return;
    }
    if (!totalPersonCanFeed.isNum || int.parse(totalPersonCanFeed) <= 10) {
      errorSnackBar(context, 'Please enter a valid person count');
      controller.reset();
      return;
    }
    if (!weight.isNum) {
      errorSnackBar(context, 'Please enter a valid weight');
      controller.reset();
      return;
    }
    await storeFoodDetails();
  }

  storeFoodDetails() async {
    try {
      final imageUrl = await uploadImageToStorage(image);

      if (imageUrl == null) {
        controller.reset();
        errorSnackBar(context, 'Image upload failed');
        return;
      }

      await _db
          .collection('users')
          .doc(_auth.currentUser!.email)
          .collection('donations')
          .doc(DateTime.now().toString())
          .set({
        'foodDescription': foodDescription,
        'date': date,
        'time': time,
        'totalPersonCanFeed': totalPersonCanFeed,
        'weight': weight,
        'address': address,
        'foodSource': foodSource,
        'imageUrl': imageUrl,
        'status': 'new',
      });

      controller.reset();
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          textAlign: TextAlign.start,
          textStyle: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          message: "Donation added successfully",
        ),
      );
    } on FirebaseAuthException catch (e) {
      controller.reset();
      errorSnackBar(context, e.message.toString());
    } catch (e) {
      controller.reset();
      errorSnackBar(context, e.toString());
    }
  }

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('food_images/${_auth.currentUser!.email}/${DateTime.now()}');

      final uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => null);

      final downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      return null;
    }
  }
}
