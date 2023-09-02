import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:unity_eats/auth/user/edit_user_profile.dart';
import 'package:unity_eats/state_management/user_gender_edit_profile.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  File? _image;
  final userGender = Get.put(UserGenderEditProfile());
  final RoundedLoadingButtonController save = RoundedLoadingButtonController();

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final tempImage = File(image.path);
    setState(() {
      _image = tempImage;
    });
  }

  void showImagePickerDialog(BuildContext context) {
    Alert(
      context: context,
      title: "SELECT SOURCE",
      closeIcon: const Icon(
        IonIcons.close,
        color: Colors.black,
      ),
      desc: "select an option to pick an image",
      style: const AlertStyle(
        backgroundColor: Colors.white,
      ),
      buttons: [
        DialogButton(
          onPressed: () async {
            Navigator.pop(context);
            final PermissionStatus permissionStatus =
                await Permission.camera.request();
            if (permissionStatus == PermissionStatus.granted) {
              await getImage(ImageSource.camera);
              return;
            } else if (permissionStatus == PermissionStatus.denied) {
              await openAppSettings();
              return;
            } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
              await openAppSettings();
              return;
            }
          },
          color: const Color.fromRGBO(0, 179, 134, 1.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Bootstrap.camera,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "CAMERA",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        DialogButton(
          onPressed: () async {
            Navigator.pop(context);
            getImage(ImageSource.gallery);
          },
          color: const Color.fromARGB(255, 63, 153, 217),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Bootstrap.image),
              SizedBox(
                width: 5,
              ),
              Text(
                "GALLERY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController userName = TextEditingController();
    final TextEditingController firstName = TextEditingController();
    final TextEditingController middleName = TextEditingController();
    final TextEditingController lastName = TextEditingController();
    final TextEditingController address = TextEditingController();
    int imageStatus = 0;
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 55,
                height: 55,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            );
          }
          Map<String, dynamic>? userDetails = snapshot.data?.data();
          userName.text = userDetails?['userName'];
          firstName.text = userDetails?['firstName'];
          middleName.text = userDetails?['middleName'];
          lastName.text = userDetails?['lastName'];
          address.text = userDetails?['address'];

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 15,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _image == null
                            ? CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.grey,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                    '${userDetails?['imageUrl']}',
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.grey,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(_image!),
                                ),
                              ),
                        Container(
                          margin: const EdgeInsets.only(
                            right: 8,
                          ),
                          width: 35,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: IconButton(
                            iconSize: 20,
                            onPressed: () async {
                              showImagePickerDialog(context);
                            },
                            icon: const Icon(
                              Icons.edit,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  text('username'),
                  const SizedBox(
                    height: 8,
                  ),
                  textField(
                    1,
                    userName,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  text('First name'),
                  const SizedBox(
                    height: 8,
                  ),
                  textField(
                    1,
                    firstName,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  text('Middle name'),
                  const SizedBox(
                    height: 8,
                  ),
                  textField(
                    1,
                    middleName,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  text('Last name'),
                  const SizedBox(
                    height: 8,
                  ),
                  textField(
                    1,
                    lastName,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  text('Gender'),
                  const SizedBox(
                    height: 14,
                  ),
                  SizedBox(
                    child: ToggleSwitch(
                      initialLabelIndex:
                          userDetails?['gender'] == 'male' ? 0 : 1,
                      dividerColor: Colors.white,
                      labels: const ['Male', 'Female'],
                      icons: const [
                        Bootstrap.gender_male,
                        Bootstrap.gender_female,
                      ],
                      radiusStyle: true,
                      customWidths: const [
                        120,
                        120,
                      ],
                      activeBgColors: [
                        [Colors.blue.withOpacity(0.7)],
                        [Colors.pink.withOpacity(0.7)]
                      ],
                      customTextStyles: const [TextStyle(letterSpacing: 1)],
                      inactiveBgColor: Colors.white12,
                      onToggle: (index) {
                        userGender.gender?.value = index!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  text('Address'),
                  const SizedBox(
                    height: 8,
                  ),
                  textField(
                    2,
                    address,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedLoadingButton(
                    controller: save,
                    onPressed: () {
                      if (_image != null) {
                        imageStatus = 1;
                      }
                      EditUserProfile(
                        userName: userName.text.trim(),
                        firstName: firstName.text.trim(),
                        middleName: middleName.text.trim(),
                        lastName: lastName.text.trim(),
                        gender:
                            userGender.gender?.value == 0 ? 'male' : 'female',
                        address: address.text.trim(),
                        context: context,
                        controller: save,
                        imageStatus: imageStatus,
                        image: _image,
                      ).validate();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.done,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Text text(String field) {
    return Text(
      field,
      style: const TextStyle(
        color: Colors.green,
        fontSize: 18,
        letterSpacing: 1,
      ),
    );
  }

  TextField textField(
      int maxLines, TextEditingController textEditingController) {
    return TextField(
      style: const TextStyle(
        letterSpacing: 1,
      ),
      controller: textEditingController,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black.withOpacity(0.15),
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
    );
  }
}
