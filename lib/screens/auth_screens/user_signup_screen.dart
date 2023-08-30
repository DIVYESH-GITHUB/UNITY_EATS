import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:text_divider/text_divider.dart';
import 'package:unity_eats/screens/auth_screens/main_login_screen.dart';
import 'package:unity_eats/utils/config.dart';
import 'package:unity_eats/utils/text_form_field.dart';
import 'package:unity_eats/auth/user/user_signin.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final RoundedLoadingButtonController _loginController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _googleController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: Get.height,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.45,
              image: AssetImage(
                'assets/images/image6.jpg',
              ),
            ),
            color: Colors.black,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Positioned(
                      bottom: 180,
                      child: IconButton(
                        onPressed: () {
                          Get.off(const MainLoginScreen());
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 27,
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        Config.appIcon,
                        height: 270,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 27,
                      color: Colors.green.shade400,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textFormField(
                  _userName,
                  TextInputType.name,
                  const Icon(Icons.person),
                  'User name',
                  false,
                  true,
                ),
                const SizedBox(
                  height: 10,
                ),
                textFormField(
                  _email,
                  TextInputType.emailAddress,
                  const Icon(Icons.mail),
                  'Email',
                  false,
                  true,
                ),
                const SizedBox(
                  height: 10,
                ),
                textFormField(
                  _password,
                  TextInputType.visiblePassword,
                  const Icon(Icons.key),
                  'Password',
                  true,
                  false,
                ),
                const SizedBox(
                  height: 10,
                ),
                RoundedLoadingButton(
                  color: Colors.green.withOpacity(0.75),
                  controller: _loginController,
                  onPressed: () {
                    UserSignIn(
                      context: context,
                      email: _email.text.trim(),
                      password: _password.text.trim(),
                      userLoginController: _loginController,
                      userName: _userName.text.trim(),
                    ).validate();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Already have an Account ? ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.off(const MainLoginScreen());
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const TextDivider(
                  color: Colors.white,
                  thickness: 1,
                  text: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                RoundedLoadingButton(
                  color: Colors.blueAccent.withOpacity(0.75),
                  controller: _googleController,
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Logo(
                        Logos.google,
                        size: 27,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
