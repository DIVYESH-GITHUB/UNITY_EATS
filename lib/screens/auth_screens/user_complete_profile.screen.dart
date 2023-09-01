// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:text_divider/text_divider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:unity_eats/auth/user/complete_user_profile.dart';
import 'package:unity_eats/state_management/user_gender.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';

class UserCompleteProfileScreen extends StatefulWidget {
  const UserCompleteProfileScreen({super.key});

  @override
  State<UserCompleteProfileScreen> createState() =>
      _UserCompleteProfileScreenState();
}

class _UserCompleteProfileScreenState extends State<UserCompleteProfileScreen> {
  File? _image;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final RoundedLoadingButtonController getCurrentAddress =
      RoundedLoadingButtonController();

  final gender = Get.put(UserGender());

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
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/image4.jpg',
            ),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    const Text(
                      'Complete Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _image == null
                          ? const CircleAvatar(
                              radius: 65,
                              backgroundColor: Colors.grey,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage(
                                  'assets/images/user_profile.png',
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
                  height: 30,
                ),
                text('First name'),
                const SizedBox(
                  height: 12,
                ),
                textField(
                  'Divyesh',
                  _firstName,
                  1,
                ),
                const SizedBox(
                  height: 15,
                ),
                text('Middle name'),
                const SizedBox(
                  height: 12,
                ),
                textField(
                  'middle name',
                  _middleName,
                  1,
                ),
                const SizedBox(
                  height: 15,
                ),
                text('Last name'),
                const SizedBox(
                  height: 12,
                ),
                textField(
                  'Pindariya',
                  _lastName,
                  1,
                ),
                const SizedBox(
                  height: 15,
                ),
                text('Address'),
                const SizedBox(
                  height: 12,
                ),
                textField(
                  '',
                  _address,
                  3,
                ),
                const SizedBox(
                  height: 12,
                ),
                const TextDivider(
                  color: Colors.white,
                  thickness: 1,
                  text: Text(
                    'OR',
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                RoundedLoadingButton(
                  height: 45,
                  controller: getCurrentAddress,
                  onPressed: () async {
                    final PermissionStatus permissionStatus =
                        await Permission.location.request();
                    if (permissionStatus ==
                        PermissionStatus.permanentlyDenied) {
                      errorSnackBar(
                        context,
                        'Please Provide location permission',
                      );
                    }
                    getCurrentAddress.reset();
                    return;
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IonIcons.location,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Get current location',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                text('Phone Number'),
                const SizedBox(
                  height: 12,
                ),
                textField(
                  '+91 7984698296',
                  _phoneNumber,
                  1,
                ),
                const SizedBox(
                  height: 15,
                ),
                text('Gender'),
                const SizedBox(
                  height: 12,
                ),
                ToggleSwitch(
                  initialLabelIndex: 0,
                  dividerColor: Colors.white,
                  totalSwitches: 2,
                  labels: const ['Male', 'Female'],
                  icons: const [
                    Bootstrap.gender_male,
                    Bootstrap.gender_female,
                  ],
                  radiusStyle: true,
                  customTextStyles: const [TextStyle(letterSpacing: 1)],
                  activeBgColor: [Colors.green.withOpacity(0.8)],
                  inactiveBgColor: Colors.white12,
                  minWidth: 150,
                  onToggle: (index) {
                    gender.gender?.value = index!;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_image == null) {
                      errorSnackBar(
                        context,
                        'Please select image',
                      );
                      return;
                    }
                    CompleteUserProfile(
                      image: _image!,
                      address: _address.text.trim(),
                      context: context,
                      firstName: _firstName.text.trim(),
                      gender: gender.gender!.value == 0 ? 'male' : 'female',
                      getCurrentAddress: getCurrentAddress,
                      lastName: _lastName.text.trim(),
                      middleName: _middleName.text.trim(),
                    ).validate();
                  },
                  child: const Text(
                    'complete',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  textField(
    String hint,
    TextEditingController controller,
    int maxLines,
  ) {
    return TextField(
      maxLines: maxLines,
      cursorColor: Colors.white,
      controller: controller,
      style: const TextStyle(
        color: Colors.white,
        letterSpacing: 1,
      ),
      decoration: InputDecoration(
        isDense: true,
        fillColor: Colors.white30,
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(
          letterSpacing: 1,
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  text(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ),
    );
  }
}
