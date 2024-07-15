// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Container(
              padding:localeProvider.locale.languageCode == 'ar'
                  ? EdgeInsets.only(left: 30)
                  : EdgeInsets.only(right: 30), 
              child: Icon(
                CupertinoIcons.bars,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          Text(
            "${AppLocalizations.of(context)?.translate('hello')}, ${ap.userModel.firstName}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
