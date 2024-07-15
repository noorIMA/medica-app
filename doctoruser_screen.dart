// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/Screens/SignInA_Screen.dart';
import 'package:medica_app/Screens/Welcome_Screen.dart';
import 'package:medica_app/Screens/Welcome_Screen2.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class DoctorUserScreen extends StatefulWidget {
  const DoctorUserScreen({super.key});

  @override
  State<DoctorUserScreen> createState() => _DoctorUserScreenState();
}

class _DoctorUserScreenState extends State<DoctorUserScreen> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              children: [
                Container(
                  alignment: localeProvider.locale.languageCode == 'ar'
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 58, 139, 148),
                      ),
                    ),
                    onPressed: () {
                      Locale currentLocale = localeProvider.locale;

                      Locale newLocale = currentLocale.languageCode == 'en'
                          ? Locale('ar')
                          : Locale('en');

                      localeProvider.setLocale(newLocale);
                    },
                    child: Text(
                      localeProvider.locale.languageCode == 'en'
                          ? 'العربية'
                          : 'English',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Image.asset(
                  "lib/images/medica.jpg",
                ),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "${AppLocalizations.of(context)?.translate('choose')}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
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
                                      builder: (context) => Welcome2(),
                                    ));
                              },
                              child: Text(
                                '${AppLocalizations.of(context)?.translate('doctorr')}',
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
                                      builder: (context) => Welcome(),
                                    ));
                              },
                              child: Text(
                                '${AppLocalizations.of(context)?.translate('user')}',
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
                    SizedBox(height: 20,),
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
                                      builder: (context) => SignInAScreen(),
                                    ));
                              },
                              child: Text(
                                '${AppLocalizations.of(context)?.translate('itAdmin')}',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
