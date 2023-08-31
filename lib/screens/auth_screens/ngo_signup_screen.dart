import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:unity_eats/auth/NGO/ngo_sign_in.dart';
import 'package:unity_eats/models/ngo_model.dart';
import 'package:unity_eats/state_management/type_of_ngo.dart';
import 'package:unity_eats/utils/csc.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';
import 'package:unity_eats/utils/ngo_text_form_field.dart';

class NgoSignUpScreen extends StatefulWidget {
  const NgoSignUpScreen({super.key});

  @override
  State<NgoSignUpScreen> createState() => _NgoSignUpScreenState();
}

class _NgoSignUpScreenState extends State<NgoSignUpScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  int _currentStep = 0;
  final typeOfNgo = Get.put(TypeOfNgo());
  final csc = Get.put(CSC());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/images3.jpg',
              ),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Register NGO',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: buildStepper(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ################ STEPPER AND ITS FUNCTIONS ################

  Widget buildStepper() {
    return Stepper(
      connectorColor: const MaterialStatePropertyAll(
        Colors.green,
      ),
      controlsBuilder: customControlsBuilder,
      currentStep: _currentStep,
      onStepTapped: (step) {
        setState(() {
          _currentStep = step;
        });
      },
      onStepContinue: handleStepContinue,
      onStepCancel: handleStepCancel,
      steps: [
        buildPersonalInfoStep(),
        buildAddressStep(),
        buildVerifyStep(),
      ],
    );
  }

  void handleStepContinue() {
    if (_currentStep < 2) {
      if (_currentStep == 0 && !arePersonalInfoFieldsFilled()) {
        errorSnackBar(context, 'Some of the fields are empty');
      } else if (_currentStep == 1 && areAddressFieldsEmpty()) {
        errorSnackBar(context, 'Some of the fields are empty');
      } else {
        setState(() {
          _currentStep++;
        });
      }
    }
  }

  void handleStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Step buildPersonalInfoStep() {
    return Step(
      title: const Text('Personal Info'),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ngoTextFormField(
                    _name, 'Ngo name', 1, TextInputType.name, false),
                const SizedBox(height: 10),
                ngoTextFormField(
                    _mobileNumber, 'Mobile', 1, TextInputType.phone, false),
                const SizedBox(height: 10),
                ngoTextFormField(
                    _email, 'Email', 1, TextInputType.emailAddress, false),
                const SizedBox(height: 10),
                ngoTextFormField(_password, 'Password', 1,
                    TextInputType.visiblePassword, true),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 5,
                  ),
                  child: Text(
                    'Ngo Type',
                    style: TextStyle(
                      fontSize: 16.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                buildNgoTypeToggleSwitch(),
              ],
            ),
          ),
        ),
      ),
      isActive: _currentStep == 0,
      state: _currentStep == 0 ? StepState.editing : StepState.indexed,
    );
  }

  Step buildAddressStep() {
    return Step(
      title: const Text('Address'),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          child: Form(
            child: Column(
              children: [
                ngoTextFormField(
                    _address, 'Address', 3, TextInputType.streetAddress, false),
                const SizedBox(height: 8),
                SelectState(
                  onCountryChanged: (value) {
                    setState(() {
                      csc.countryValue.value = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      csc.stateValue.value = value;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      csc.cityValue.value = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      isActive: _currentStep == 1,
      state: _currentStep == 1 ? StepState.editing : StepState.indexed,
    );
  }

  Step buildVerifyStep() {
    return Step(
      title: const Text('Verify'),
      content: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please Verify the details',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              buildCardWithDetails(),
            ],
          ),
        ),
      ),
      isActive: _currentStep == 2,
      state: _currentStep == 2 ? StepState.editing : StepState.indexed,
    );
  }

  Widget customControlsBuilder(
      BuildContext context, ControlsDetails controlsDetails) {
    if (_currentStep == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 10),
          elevatedButton(
              controlsDetails.onStepContinue, Colors.blue, 'Continue')
        ],
      );
    } else if (_currentStep == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          elevatedButton(
              controlsDetails.onStepContinue, Colors.blue, 'Continue'),
          const SizedBox(width: 16),
          elevatedButton(controlsDetails.onStepCancel, Colors.red, 'Previous'),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          elevatedButton(() {
            final NgoModel ngoModel = NgoModel(
              address: _address.text,
              city: csc.cityValue.value,
              state: csc.stateValue.value,
              country: csc.stateValue.value,
              email: _email.text,
              phoneNumber: _mobileNumber.text,
              isEmailVerified: false,
              isNgoVerified: false,
              name: _name.text,
              ngoType: typeOfNgo.index?.value == 0
                  ? 'Private'
                  : typeOfNgo.index?.value == 1
                      ? 'Government'
                      : 'Semi Government',
            );
            NgoSignIn(
                    context: context,
                    ngoModel: ngoModel,
                    password: _password.text)
                .signUp();
          }, Colors.green, 'Register'),
          const SizedBox(width: 16),
          elevatedButton(controlsDetails.onStepCancel, Colors.red, 'Previous'),
        ],
      );
    }
  }

  bool arePersonalInfoFieldsFilled() {
    return _name.text.isNotEmpty &&
        _mobileNumber.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _password.text.isNotEmpty;
  }

  bool areAddressFieldsEmpty() {
    return _address.text.isEmpty ||
        csc.countryValue.value.isEmpty ||
        csc.stateValue.value.isEmpty ||
        csc.cityValue.value.isEmpty;
  }

  // ################ WIDGETS ################

  ToggleSwitch buildNgoTypeToggleSwitch() {
    return ToggleSwitch(
      initialLabelIndex: 0,
      dividerColor: Colors.white,
      totalSwitches: 3,
      labels: const ['private', 'Government', 'Semi Government'],
      customTextStyles: const [TextStyle(letterSpacing: 1)],
      activeBgColor: [Colors.green.withOpacity(0.8)],
      inactiveBgColor: Colors.grey.withOpacity(0.15),
      minWidth: 150,
      isVertical: true,
      onToggle: (index) {
        typeOfNgo.index?.value = index!;
      },
    );
  }

  Card buildCardWithDetails() {
    return Card(
      elevation: 4,
      color: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(11.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name : ${_name.text}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Phone Number : ${_mobileNumber.text}',
              style: const TextStyle(
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Email : ${_email.text}',
              style: const TextStyle(
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Type of NGO : ${typeOfNgo.index?.value == 0 ? 'Private' : typeOfNgo.index?.value == 1 ? 'Government' : 'Semi Government'}',
              style: const TextStyle(
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Address : ${_address.text}',
              style: const TextStyle(
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Country : ${csc.countryValue.value}',
              style: const TextStyle(
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'State : ${csc.stateValue.value}',
              style: const TextStyle(
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'City : ${csc.cityValue.value}',
              style: const TextStyle(
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton elevatedButton(
      void Function()? onpressed, Color color, String text) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        elevation: 1.5,
        shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: color,
      ),
      child: Text(
        text,
        style: const TextStyle(
          letterSpacing: 1,
        ),
      ),
    );
  }
}
