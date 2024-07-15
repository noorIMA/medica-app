// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class AppBarDWidget extends StatefulWidget {
  const AppBarDWidget({super.key});

  @override
  State<AppBarDWidget> createState() => _AppBarDWidgetState();
}

class _AppBarDWidgetState extends State<AppBarDWidget> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.localeString;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              padding: localeProvider.locale.languageCode == 'ar'
                  ? EdgeInsets.only(left: 30)
                  : EdgeInsets.only(right: 30),
              child: Icon(
                CupertinoIcons.bars,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Expanded(
              child: locale == "en"
                  ? Text(
                      "${AppLocalizations.of(context)?.translate('hello')}, ${ap.doctorModel.name_en}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "${AppLocalizations.of(context)?.translate('hello')}, ${ap.doctorModel.name_ar}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
          Expanded(
            child: Container(
              alignment: localeProvider.locale.languageCode == 'ar'
                  ? Alignment.topLeft
                  : Alignment.topRight,
              child: ElevatedButton(
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
                ),
              ),
            ),
          ),
          //  Expanded(
          //   child: InkWell(
          //     onTap: () {},
          //     child: Container(
          //       padding: EdgeInsets.only(left:140),
          //       child: Icon(
          //         Icons.notifications,
          //         color: Colors.white,
          //         size: 35,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
