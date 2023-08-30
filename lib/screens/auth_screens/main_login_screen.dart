import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:text_divider/text_divider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:unity_eats/screens/auth_screens/user_signup_screen.dart';
import 'package:unity_eats/state_management/type_of_user.dart';
import 'package:unity_eats/utils/config.dart';
import 'package:unity_eats/auth/user/user_login.dart';
import 'package:unity_eats/utils/text_form_field.dart';

class MainLoginScreen extends StatefulWidget {
  const MainLoginScreen({super.key});

  @override
  State<MainLoginScreen> createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> {
  final typeOfUser = Get.put(TypeOfUser());

  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPassword = TextEditingController();

  final TextEditingController _ngoEmail = TextEditingController();
  final TextEditingController _ngoPassword = TextEditingController();

  final TextEditingController _adminUsername = TextEditingController();
  final TextEditingController _adminPassword = TextEditingController();

  final RoundedLoadingButtonController _userGoogleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _userLoginController =
      RoundedLoadingButtonController();

  final RoundedLoadingButtonController _ngoGoogleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _ngoLoginController =
      RoundedLoadingButtonController();

  final RoundedLoadingButtonController _adminLoginController =
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
                'assets/images/image1.jpg',
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
                    Center(
                      child: Image.asset(
                        Config.appIcon,
                        height: 280,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 25,
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        isRepeatingAnimation: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Sharing Flavors, Spreading Hope.",
                            textStyle: const TextStyle(fontSize: 16.5),
                          ),
                          TypewriterAnimatedText(
                            "Nourish Together, End Hunger Alone.",
                            textStyle: const TextStyle(fontSize: 16.5),
                          ),
                          TypewriterAnimatedText(
                            "Donate. Share. Uplift. Unite Hunger.",
                            textStyle: const TextStyle(fontSize: 16.5),
                          ),
                          TypewriterAnimatedText(
                            "Fighting Hunger, Building Unity Through Food.",
                            textStyle: const TextStyle(fontSize: 16.5),
                          ),
                          TypewriterAnimatedText(
                            "Empower Hunger Relief with Unity Eats.",
                            textStyle: const TextStyle(fontSize: 16.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ToggleSwitch(
                    initialLabelIndex: 0,
                    customWidths: const [100, 100, 100],
                    totalSwitches: 3,
                    labels: const ['user', 'NGO', 'admin'],
                    activeBgColor: [Colors.green.withOpacity(0.8)],
                    onToggle: (index) {
                      typeOfUser.index?.value = index!;
                    },
                    customTextStyles: const [TextStyle(fontSize: 15)],
                    icons: const [
                      Bootstrap.person,
                      Icons.fastfood,
                      Icons.admin_panel_settings,
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() {
                  if (typeOfUser.index?.value == 0) {
                    return user();
                  } else if (typeOfUser.index?.value == 1) {
                    return ngo();
                  }
                  return adminLogin();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  user() {
    return Form(
      child: Column(
        children: [
          textFormField(
            _userEmail,
            TextInputType.emailAddress,
            const Icon(Icons.email),
            'Email',
            false,
            true,
          ),
          const SizedBox(
            height: 6,
          ),
          textFormField(
            _userPassword,
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
            controller: _userLoginController,
            onPressed: () {
              UserLogIn(
                userLoginController: _userLoginController,
                context: context,
                email: _userEmail.text.trim(),
                password: _userPassword.text.trim(),
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
                  'Login',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Dont have a Account ? ',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.off(const UserSignUpScreen());
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
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
            height: 15,
          ),
          RoundedLoadingButton(
            color: Colors.blueAccent.withOpacity(0.75),
            controller: _userGoogleController,
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
                  'Sign in with Google',
                  style: TextStyle(
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ngo() {
    return Form(
      child: Column(
        children: [
          textFormField(
            _ngoEmail,
            TextInputType.emailAddress,
            const Icon(Icons.mail),
            'Email',
            false,
            true,
          ),
          const SizedBox(
            height: 6,
          ),
          textFormField(
            _ngoPassword,
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
            controller: _ngoLoginController,
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red.shade400),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(
                  width: 7,
                ),
                Text(
                  'Register new NGO',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
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
            height: 10,
          ),
          RoundedLoadingButton(
            color: Colors.blueAccent.withOpacity(0.75),
            controller: _ngoGoogleController,
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
                  'Sign in with Google',
                  style: TextStyle(
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  adminLogin() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _adminUsername,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              prefixIconColor: Colors.white,
              hintText: 'Username',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.85)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          TextFormField(
            controller: _adminPassword,
            decoration: InputDecoration(
              prefixIconColor: Colors.white,
              prefixIcon: const Icon(Icons.key),
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.85)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RoundedLoadingButton(
            color: Colors.green.withOpacity(0.75),
            controller: _adminLoginController,
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.login),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
