import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:text_divider/text_divider.dart';
import 'package:unity_eats/auth/user/store_food_details.dart';
import 'package:unity_eats/utils/error_snack_bar.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  RoundedLoadingButtonController getLocation = RoundedLoadingButtonController();
  RoundedLoadingButtonController donate = RoundedLoadingButtonController();

  TextEditingController foodSource = TextEditingController();
  TextEditingController foodDescription = TextEditingController();
  TextEditingController totalPersonCanFeed = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController address = TextEditingController();

  String date = '';
  String time = '';
  File? _image;
  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final tempImage = File(image.path);
    setState(() {
      _image = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donate Food',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Food Description',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: foodDescription,
                maxLines: 3,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Give description of the food Eg. dish name',
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                  fillColor: Colors.white10,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Preparation Date',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DateTimeFormField(
                lastDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.white70),
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon:
                      const Icon(Icons.calendar_month, color: Colors.blue),
                  hintText: 'Date',
                ),
                mode: DateTimeFieldPickerMode.date,
                autovalidateMode: AutovalidateMode.always,
                validator: (e) =>
                    (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  setState(() {
                    date = '${value.day}-${value.month}-${value.year}';
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Total person can feed',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: totalPersonCanFeed,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.person,
                    size: 25,
                    color: Colors.yellowAccent,
                  ),
                  isDense: true,
                  hintText: 'Minimum 10 Persons',
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                  fillColor: Colors.white10,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Preparation Time',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              DateTimeFormField(
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.white70),
                  errorStyle: const TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(
                    Bootstrap.clock_fill,
                    color: Colors.blue,
                  ),
                  hintText: 'Time',
                ),
                mode: DateTimeFieldPickerMode.time,
                autovalidateMode: AutovalidateMode.always,
                validator: (e) =>
                    (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  final formattedTime = DateFormat.jm().format(value);
                  setState(() {
                    time = formattedTime;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Food weight',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: weight,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Weight of Food in Kg',
                  suffixIcon: const Icon(
                    IonIcons.bag,
                    size: 22,
                    color: Colors.yellowAccent,
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                  fillColor: Colors.white10,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 17,
                    letterSpacing: 1,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RoundedLoadingButton(
                height: 40,
                controller: getLocation,
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IonIcons.location,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      'Get Current Location',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 9,
              ),
              const TextDivider(
                text: Text('OR'),
                thickness: 3,
                color: Colors.white30,
              ),
              const SizedBox(
                height: 9,
              ),
              TextField(
                controller: address,
                maxLines: 3,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Address',
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                  fillColor: Colors.white10,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Food Source',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomDropdown(
                fillColor: Colors.white10,
                hintStyle: const TextStyle(
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
                hintText: 'Select food source',
                items: const [
                  'Marriage Function',
                  'family gathering',
                  'Hostel mess',
                  'Other mess',
                  'freshly prepared',
                  'Other',
                ],
                controller: foodSource,
                fieldSuffixIcon: const Icon(
                  Icons.arrow_drop_down_circle,
                  size: 26,
                ),
                listItemStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Food Image',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 1,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _image == null
                  ? ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll(
                          Colors.yellow,
                        ),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Bootstrap.camera_fill,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            'Pick an image',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        getImage(ImageSource.camera);
                      },
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 6,
                      ),
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                ),
                              ),
                            ],
                          ),
                          Image.file(
                            _image!,
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
                color: Colors.white70,
              ),
              const SizedBox(
                height: 10,
              ),
              RoundedLoadingButton(
                color: Colors.green,
                height: 50,
                controller: donate,
                onPressed: () async {
                  if (_image == null) {
                    errorSnackBar(context, 'Please select an image');
                    donate.reset();
                    return;
                  }
                  await StoreFoodDetails(
                    image: _image!,
                    foodDescription: foodDescription.text.trim(),
                    date: date,
                    time: time,
                    totalPersonCanFeed: totalPersonCanFeed.text.trim(),
                    weight: weight.text.trim(),
                    address: address.text.trim(),
                    foodSource: foodSource.text.trim(),
                    context: context,
                    controller: donate,
                  ).validate();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Donate',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image(
                      image: AssetImage(
                        'assets/images/heart.png',
                      ),
                      height: 27,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
