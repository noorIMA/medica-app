// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context)?.translate('lang')}",
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
                    Icons.language,
                    color: Color.fromARGB(255, 58, 139, 148),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${AppLocalizations.of(context)?.translate('lang')}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Divider(height: 20, thickness: 1),
              SizedBox(height: 30),
              ListTile(
                title: Text(
                  localeProvider.locale.languageCode == 'en'
                      ? 'العربية'
                      : 'English',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Switch(
                  value: localeProvider.locale.languageCode == 'ar',
                  activeColor: Colors.white,
                  activeTrackColor: Color.fromARGB(255, 58, 139, 148),
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                  onChanged: (bool value) {
                    Locale newLocale = value ? Locale('ar') : Locale('en');
                    localeProvider.setLocale(newLocale);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
