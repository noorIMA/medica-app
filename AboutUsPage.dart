// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 58, 139, 148),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  Icon(
                    Icons.web,
                    color: Color.fromARGB(255, 58, 139, 148),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "About Us",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Medica app is a Palestinian-based medical app. Its main purpose is to easily schedule and book your hospital and clinic appointments in the West Bank. It mainly facilitates the process of finding the best nearby hospitals and doctors to book appointments with them."
                "\n\nMedica goes beyond just providing users with a booking system, it also integrates other technologies to ensure the best user experience. It is a user-friendly app that offers a chatting system between patients and doctors, a search bar to find doctors, specializations, and hospitals, as well as a rating system to allow patients to review a doctor. Moreover, a routing system will be provided to guide patients to the hospital or clinic specified. The routing system implements the A* algorithm, which is an algorithm used in AI to find the shortest path for a certain destination."
                "\n\nOur app will be a breakthrough in the healthcare sector as it is the first Palestinian app built to serve a complete hospital booking system with other outstanding features that make it one of a kind.",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
