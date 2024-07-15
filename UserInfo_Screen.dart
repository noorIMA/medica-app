// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, sort_child_properties_last, sized_box_for_whitespace, unrelated_type_equality_checks
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/Screens/Home_Screen.dart';
import 'package:medica_app/Screens/Welcome_Screen.dart';
import 'package:medica_app/Utils/Utils.dart';
import 'package:medica_app/model/user_model.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  File? image;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController(text: "Male");
  final List<String> _genders = ["Male", "Female"];
  String _selectedgender = "Male";
  final dateController = TextEditingController();
  final selectController = TextEditingController();
  DateTime _selectedDate = DateTime(2050, 2, 1, 10, 20);
  bool Selected = false;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    genderController.dispose();
    dateController.dispose();
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 222, 238, 250),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 58, 139, 148),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
                  child: Center(
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Welcome())),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.back,
                                    color: Color.fromARGB(255, 58, 139, 148),
                                    size: 40,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)?.translate('back')}",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20),
                                  )
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${AppLocalizations.of(context)?.translate('createaccount')}",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 58, 139, 148),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () => selectImage(),
                          child: image == null
                              ? CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 58, 139, 148),
                                  radius: 50,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${AppLocalizations.of(context)?.translate('choosephoto')}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          margin: EdgeInsets.only(top: 30),
                          child: Column(children: [
                            textField(
                                hintText: "${AppLocalizations.of(context)?.translate('fname')}",
                                icon: Icons.account_circle,
                                inputType: TextInputType.name,
                                maxLines: 1,
                                controller: firstNameController),
                            textField(
                                hintText: "${AppLocalizations.of(context)?.translate('lname')}",
                                icon: Icons.account_circle,
                                inputType: TextInputType.name,
                                maxLines: 1,
                                controller: lastNameController),
                            textField(
                                hintText: "${AppLocalizations.of(context)?.translate('email')}",
                                icon: Icons.email,
                                inputType: TextInputType.emailAddress,
                                maxLines: 1,
                                controller: emailController),
                            Gender(),
                            DatePicker(),
                            CheckBox(
                                text:
                                    "${AppLocalizations.of(context)?.translate('terms')}"),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: ElevatedButton(
                            onPressed: () => storeData(),
                            child: Text(
                              '${AppLocalizations.of(context)?.translate('continue')}',
                              style: TextStyle(
                                fontSize: 22,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor:
                                  Color.fromARGB(255, 58, 139, 148),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget textField({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required TextEditingController controller,
    required int maxLines,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        cursorColor: Color.fromARGB(255, 58, 139, 148),
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 253, 247, 247),
          prefixIcon: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 58, 139, 148),
              ),
              child: Icon(icon, size: 20, color: Colors.white)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 58, 139, 148),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Row Gender() {
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context)?.translate('gender')}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        for (int i = 0; i < _genders.length; i++)
          Row(
            children: [
              Radio(
                value: _genders[i],
                groupValue: _selectedgender,
                onChanged: (value) {
                  setState(() {
                    _selectedgender = value.toString();
                    genderController.text = _selectedgender;
                  });
                },
                activeColor: Color.fromARGB(255, 58, 139, 148),
              ),
              Text(
               "${AppLocalizations.of(context)?.translate(_genders[i])}",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(right: 50.0, top: 50, bottom: 30),
        ),
      ],
    );
  }

  Row CheckBox({
    required String text,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              Selected = !Selected;
              selectController.text = Selected ? "True" : "False";
            });
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 253, 247, 247),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Color(0xFF979797))),
            child: Selected
                ? Icon(
                    Icons.check,
                    size: 17,
                    color: const Color.fromARGB(255, 58, 139, 148),
                  )
                : null,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Text(
            text,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 80),
        ),
      ],
    );
  }

  Padding DatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        cursorColor: Color.fromARGB(255, 58, 139, 148),
        controller: dateController,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 253, 247, 247),
          hintText: "${AppLocalizations.of(context)?.translate('dateofbirth')}",
          suffixIcon: GestureDetector(
            onTap: () {
              selectDate(context);
            },
            child: Icon(Icons.calendar_today),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 58, 139, 148),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
        onTap: () {
          selectDate(context);
        },
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200.0,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedDate = newDate;
                dateController.text =
                    "${newDate.day}/${newDate.month}/${newDate.year}";
              });
            },
          ),
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  //store the data
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        profilePic: "",
        gender: genderController.text.trim(),
        dateOfBirth: dateController.text.trim(),
        createdAt: "",
        phoneNumber: "",
        uid: "");
    if (selectController.text == "True") {
      if (firstNameController.text == "" || lastNameController == "") {
        showSnackBar(context, "${AppLocalizations.of(context)?.translate('nameerr')}");
      } else {
        ap.saveUserDataToFirebase(
            context: context,
            userModel: userModel,
            profilePic: image,
            onSuccess: () {
              //store the data locally
              ap.saveDateToSP().then((value) => ap.setSignIn().then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false)));
            });
      }
    } else {
      showSnackBar(context, "${AppLocalizations.of(context)?.translate('termserr')}");
    }
  }
}
