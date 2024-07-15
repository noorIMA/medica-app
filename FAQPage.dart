// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

// Model class for FAQ items
class FAQItem {
  final String question;
  final String answer;

  FAQItem(this.question, this.answer);
}

class FAQPage extends StatelessWidget {
  // List of FAQ items
  final List<FAQItem> faqItems = [
    FAQItem("What is Medica App?",
        "Medica is the first Palestinian medical search app designed to modernize and enhance booking services in the healthcare sector of the West Bank. It provides a user-friendly interface for Android users, offering innovative features to simplify medical services."),
    FAQItem("What functionalities does Medica offer?",
        "Medica offers a range of ingenious functionalities, including a convenient booking system, an efficient routing system utilizing A* algorithm for shortest path to hospitals, a secure communication system ensuring privacy of patient information, a review system for feedback on doctors, and a search functionality to explore doctors, hospitals, and specializations."),
    FAQItem("How does Medica improve the healthcare sector in the West Bank?",
        "Medica integrates technology into healthcare facilities, providing efficient booking services and enhancing user experience for both patients. It addresses the lack of technological integration in the West Bank's healthcare sector by offering modern solutions for booking, rescheduling, and canceling appointments."),
    FAQItem("Who can benefit from using Medica?",
        "Medica caters to patients. Patients can easily book appointments, provide feedback, and navigate to hospitals and edit their profiles for increased flexibility and usability."),
    FAQItem("Is Medica easy to use for non-tech-savvy users?",
        "Yes, Medica is designed to be simple and clear for all users, regardless of their level of expertise in technology. The app's intuitive interface ensures ease of use for everyone."),
    FAQItem("How can I search for doctors and hospitals on Medica?",
        "You can search for doctors, hospitals, and specializations by typing in the search bar, tapping on specialization icons, or accessing a list of nearby hospitals based on your location."),
    FAQItem("Is my sensitive information safe on Medica?",
        "Yes, Medica ensures the privacy and security of patients' sensitive information through a reliable communication system and adherence to strict privacy protocols."),
    FAQItem(
        "How does Medica contribute to the overall performance of the healthcare sector?",
        "Medica serves as a milestone in the medical sector by providing technology-driven solutions that enhance efficiency, responsiveness, and user experience. It offers a range of features beyond basic booking services to boost the overall performance of the app."),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FAQ",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 58, 139, 148),
        leading: IconButton(
          onPressed: () {
            // Navigate back to the previous page
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
                    Icons.question_answer,
                    color: Color.fromARGB(255, 58, 139, 148),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Frequently Asked Questions",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 20),
              // Display FAQ items
              ...faqItems.map((item) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      item.question,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      item.answer,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
