// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/Welcome_Screen.dart';
import 'package:medica_app/Utils/Utils.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "970",
    countryCode: "PS",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Palestinian Territory, Occupied",
    example: "Palestinian Territory, Occupied",
    displayName: "Palestinian Territory, Occupied",
    displayNameNoCountryCode: "PS",
    e164Key: "",
  );
  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );
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
        )),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
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
                      height: 25,
                    ),
                    Container(
                      width: 160,
                      height: 160,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 197, 225, 249),
                      ),
                      child: Image.asset('lib/images/register.png'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "${AppLocalizations.of(context)?.translate('login')}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 58, 139, 148),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${AppLocalizations.of(context)?.translate('phonemsg')}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      cursorColor: Color.fromARGB(255, 58, 139, 148),
                      controller: phoneController,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      onChanged: (value) {
                        setState(() {
                          phoneController.text = value;
                        });
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 253, 247, 247),
                          hintText:
                              " ${AppLocalizations.of(context)?.translate('phoneenter')}",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey.shade600),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 58, 139, 148))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                  context: context,
                                  countryListTheme: CountryListThemeData(
                                      bottomSheetHeight: 550),
                                  onSelect: (value) {
                                    setState(() {
                                      selectedCountry = value;
                                    });
                                  },
                                );
                              },
                              child: Text(
                                "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          suffixIcon: phoneController.text.length >= 9
                              ? Container(
                                  height: 30,
                                  width: 30,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green),
                                  child: Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )
                              : null),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => sendPhoneNum(),
                        child: Text(
                          '${AppLocalizations.of(context)?.translate('login')}',
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
                          backgroundColor: Color.fromARGB(255, 58, 139, 148),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNum() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNum = phoneController.text.trim();
    if (phoneNum == "") {
      showSnackBar(
          context, "${AppLocalizations.of(context)?.translate('phoneerr')}");
    } else {
      ap.signInWithPhoneNum(context, "+${selectedCountry.phoneCode}$phoneNum");
    }
  }
}
