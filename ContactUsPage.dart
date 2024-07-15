// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  // Function to launch URLs
  void _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw ' $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contact Us",
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
                    Icons.contact_page,
                    color: Color.fromARGB(255, 58, 139, 148),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Contact Us",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ), 
              Divider(height: 20, thickness: 1),
              SizedBox(height: 20),
              Text(
                "Phone Number",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "+970 59 987 7077",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "medica.App@gmail.com",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "Follow Us",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.facebook, color: Color.fromARGB(255, 58, 139, 148)),
                    onPressed: () {
                      _launchURL('https://www.facebook.com/noor.ibraheem.545?mibextid=LQQJ4d');
                    },
                  ),
                  IconButton(
          icon: FaIcon(FontAwesomeIcons.whatsapp, color: Color.fromARGB(255, 58, 139, 148)),
          onPressed: () {
            _launchURL('https://www.whatsapp.com/');
          },
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.instagram, color: Color.fromARGB(255, 58, 139, 148)),
          onPressed: () {
            _launchURL('https://www.instagram.com/');
          },
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.linkedin, color: Color.fromARGB(255, 58, 139, 148)),
          onPressed: () {
            _launchURL('https://www.linkedin.com/');
          },
        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
