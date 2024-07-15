// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/Screens/SignIn_Screen.dart';
import 'package:medica_app/Screens/SignUp_Screen.dart';
import 'package:medica_app/Screens/doctoruser_screen.dart';
import 'package:medica_app/provider/app_localizations.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () =>Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DoctorUserScreen())),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.back,
                            color: Color.fromARGB(255, 58, 139, 148),
                            size: 40,
                          ),
                          Text(
                            "${AppLocalizations.of(context)?.translate('back')}",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 20),
                          )
                        ],
                      ),
                    )),
                Image.asset(
                  "lib/images/medica.jpg",
                ),
                Text(
                  "${AppLocalizations.of(context)?.translate('start') ?? 'Let`s get started'}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "${AppLocalizations.of(context)?.translate('welcome') ?? 'Welcome to Medica App! Easily find hospitals and book appointments with doctors.'}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black38),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 140,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ));
                          },
                          child: Text(
                            '${AppLocalizations.of(context)?.translate('signup') ?? 'Sign Up'}',
                            style: TextStyle(
                              fontSize: 18,
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
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 140,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ));
                          },
                          child: Text(
                            '${AppLocalizations.of(context)?.translate('login') ?? 'Log In'}',
                            style: TextStyle(
                              fontSize: 18,
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
