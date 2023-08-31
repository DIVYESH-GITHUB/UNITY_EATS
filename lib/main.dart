import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:unity_eats/screens/auth_screens/main_login_screen.dart';
// import 'package:unity_eats/screens/auth_screens/ngo_signup_screen.dart';
// import 'package:unity_eats/auth/email_verfication_screen.dart';
// import 'package:unity_eats/screens/auth_screens/main_login_screen.dart';
// import 'package:unity_eats/screens/auth_screens/ngo_signup_screen.dart';
// import 'package:unity_eats/screens/auth_screens/user_signup_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainLoginScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}
