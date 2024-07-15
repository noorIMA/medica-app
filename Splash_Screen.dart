// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medica_app/Screens/AdminHome_Screen.dart';
import 'package:medica_app/Screens/DoctorHomeScreen.dart';
import 'package:medica_app/Screens/Home_Screen.dart';
import 'package:medica_app/Screens/doctoruser_screen.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
    Timer(Duration(seconds: 5), () async {
      if (ap.isSignedIn == true) {
      await ap.getDateFroSP().whenComplete(() {
            if (ap.isUser) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (ap.isDoctor) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Doctorhomescreen()),
              );
              }else if (ap.isAdmin) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AdminHomeScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DoctorUserScreen()),
              );
            }
          });
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorUserScreen(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 170),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/medica.jpg',
                height: 300,
                width: 300,
              ),
              Text(
                "MEDICA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 58, 139, 148),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
