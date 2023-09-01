import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unity_eats/screens/auth_screens/main_login_screen.dart';
import 'package:unity_eats/screens/auth_screens/user_complete_profile.screen.dart';
import 'package:unity_eats/state_management/email_verifiaction_timeout.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final emailVerficationTimeout = Get.put(EmailVerficationTimeout());
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Timer? timer;
  int timeOut = 20;
  @override
  void initState() {
    final user = _auth.currentUser;
    if (user != null) {
      user.sendEmailVerification();
    }
    timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (timer) async {
        setState(() {
          --timeOut;
        });

        if (timeOut == 0) {
          Get.off(const MainLoginScreen());
        }
        final user = _auth.currentUser;
        user?.reload();
        if (user!.emailVerified) {
          timer.cancel();
          await _db.collection('users').doc(user.email).update({
            'emailVerified': true,
          });
          Get.off(const UserCompleteProfileScreen());
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/images3.jpg'),
              opacity: 0.7,
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              height: 300,
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.6),
              ),
              child: Column(
                children: [
                  const Text(
                    'Email Verification',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Email is send to',
                    style: TextStyle(
                      fontSize: 21,
                      letterSpacing: 1,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    '${_auth.currentUser!.email}',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  const Text(
                    'Please verify your Email...!',
                    style: TextStyle(
                      fontSize: 19,
                      letterSpacing: 1.1,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Timeout : ',
                        style: TextStyle(
                          fontSize: 19,
                          letterSpacing: 1.1,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$timeOut',
                        style: const TextStyle(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
