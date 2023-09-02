// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:unity_eats/screens/user/home_screen.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';

class EditUserProfile {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String userName;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String address;
  BuildContext context;
  RoundedLoadingButtonController controller;
  int imageStatus;
  File? image;
  EditUserProfile(
      {required this.userName,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.gender,
      required this.address,
      required this.context,
      required this.controller,
      required this.imageStatus,
      required this.image});
  validate() {
    if (userName.isEmpty ||
        firstName.isEmpty ||
        middleName.isEmpty ||
        lastName.isEmpty ||
        gender.isEmpty ||
        address.isEmpty) {
      errorSnackBar(context, 'Some of the fields are empty');
      controller.reset();
      return;
    }
    editProfile();
  }

  editProfile() {
    if (imageStatus == 1) {
      PanaraConfirmDialog.showAnimatedGrow(
        color: Colors.black26,
        textColor: Colors.black,
        context,
        message: 'Are you sure you want to Update profile ?',
        confirmButtonText: 'Confirm',
        cancelButtonText: 'Cancel',
        onTapConfirm: () async {
          try {
            final imageUrl = await uploadImageToStorage(image!);

            if (imageUrl == null) {
              controller.reset();
              errorSnackBar(context, 'Image upload failed');
              return;
            }

            await _db.collection('users').doc(_auth.currentUser!.email).update({
              'userName': userName,
              'firstName': firstName,
              'middleName': middleName,
              'lastName': lastName,
              'address': address,
              'gender': gender,
              'imageUrl': imageUrl, // Add the image URL here
            });

            controller.reset();
            Get.to(() => const HomeScreen());
          } on FirebaseAuthException catch (e) {
            controller.reset();
            errorSnackBar(context, e.message.toString());
          } catch (e) {
            controller.reset();
            errorSnackBar(context, e.toString());
          }
        },
        onTapCancel: () {
          controller.reset();
          Navigator.of(context).pop();
        },
        panaraDialogType: PanaraDialogType.normal,
        barrierDismissible: false,
      );
    } else {
      PanaraConfirmDialog.showAnimatedGrow(
        color: Colors.black26,
        textColor: Colors.black,
        context,
        message: 'Are you sure you want to Update profile ?',
        confirmButtonText: 'Confirm',
        cancelButtonText: 'Cancel',
        onTapConfirm: () async {
          await _db.collection('users').doc(_auth.currentUser!.email).update({
            'userName': userName,
            'firstName': firstName,
            'middleName': middleName,
            'lastName': lastName,
            'address': address,
            'gender': gender, // Add the image URL here
          });
          PanaraInfoDialog.showAnimatedGrow(
            context,
            message: 'Profile Edited Successfuly',
            textColor: Colors.black,
            buttonText: 'OK',
            onTapDismiss: () {
              controller.reset();
              Get.to(() => const HomeScreen());
            },
            panaraDialogType: PanaraDialogType.success,
            barrierDismissible: false,
          );
        },
        onTapCancel: () {
          controller.reset();
          Navigator.of(context).pop();
        },
        panaraDialogType: PanaraDialogType.normal,
        barrierDismissible: false,
      );
    }
  }

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user_images/${_auth.currentUser!.email}');

      final uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => null);

      final downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      return null;
    }
  }
}
