// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/AboutUsPage.dart';
import 'package:medica_app/Screens/ContactUsPage.dart';
import 'package:medica_app/Screens/FAQPage.dart';
import 'package:medica_app/Screens/LanguagePage.dart';
import 'package:medica_app/Screens/PrivacyAndSecurityPage.dart';
import 'package:medica_app/provider/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool valueNotificatin_1 = false;
  bool valueNotificatin_2 = false;

  onChangeFunction_1(bool newValue_1) {
    setState(() {
      valueNotificatin_1 = newValue_1;
    });
  }

  onChangeFunction_2(bool newValue_2) {
    setState(() {
      valueNotificatin_2 = newValue_2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context)?.translate('settings')}",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 58, 139, 148),
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
                    Icons.person,
                    color: Color.fromARGB(255, 58, 139, 148),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${AppLocalizations.of(context)?.translate('account')}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ), // Added comma here
              Divider(height: 20, thickness: 1),
              SizedBox(height: 10),
              buidAccountOption(context, "${AppLocalizations.of(context)?.translate('lang')}"),
              buidAccountOption(context, "${AppLocalizations.of(context)?.translate('privacy')}"),
              SizedBox(height: 40),
              Row(
                children: [
                  Icon(Icons.notifications,
                      color: Color.fromARGB(255, 58, 139, 148)),
                  SizedBox(width: 10),
                  Text("${AppLocalizations.of(context)?.translate('notification')}",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(height: 20, thickness: 1),
              SizedBox(height: 10),

              buildNotificationOption(
                  "${AppLocalizations.of(context)?.translate('pause')} ", valueNotificatin_2, onChangeFunction_2),
              SizedBox(height: 40),
              Row(
                children: [
                  Icon(
                    Icons.support,
                    color: Color.fromARGB(255, 58, 139, 148),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${AppLocalizations.of(context)?.translate('support')}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Divider(height: 20, thickness: 1),
              SizedBox(height: 10),
              buidSupportOption(context, "${AppLocalizations.of(context)?.translate('contact')}"),
              buidSupportOption(context, "${AppLocalizations.of(context)?.translate('faq')}"),
              buidSupportOption(context, "${AppLocalizations.of(context)?.translate('about')}"),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildNotificationOption(
      String title, bool value, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600])),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Color.fromARGB(255, 58, 139, 148),
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ))
      ]),
    );
  }

  GestureDetector buidAccountOption(BuildContext context, String title) {
    return GestureDetector(
        onTap: () {
          if (title == "${AppLocalizations.of(context)?.translate('lang')}") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LanguagePage()),
            );
          } else if (title == "${AppLocalizations.of(context)?.translate('privacy')}") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyAndSecurityPage()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600])),
              Icon(Icons.arrow_forward_ios, color: Colors.grey)
            ],
          ),
        ));
  }

  GestureDetector buidSupportOption(BuildContext context, String title) {
    return GestureDetector(
        onTap: () {
          if (title == "${AppLocalizations.of(context)?.translate('contact')}") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactUsPage()),
            );
          } else if (title == "${AppLocalizations.of(context)?.translate('faq')}") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FAQPage()),
            );
          } else if (title == "${AppLocalizations.of(context)?.translate('about')}") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUsPage()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600])),
              Icon(Icons.arrow_forward_ios, color: Colors.grey)
            ],
          ),
        ));
  }
}
