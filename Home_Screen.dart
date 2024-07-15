// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/Screens/Appointments_Screen.dart';
import 'package:medica_app/Screens/HomeBody_Screen.dart';
import 'package:medica_app/Screens/Settings_Screen.dart';
import 'package:medica_app/Screens/UserChatList.dart';
import 'package:medica_app/provider/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> widgetList = [
    HomeBodyScreen(),
    AppointmentsScreen(),
    UserChatListScreen(),
    SettingsScreen(),
  ];
  int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetList.elementAt(myIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        selectedItemColor: Color.fromARGB(255, 58, 139, 148),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: myIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
                color: Colors.black54,
                size: 30,
              ),
              activeIcon: Icon(
                CupertinoIcons.home,
                size: 30,
              ),
              label: "${AppLocalizations.of(context)?.translate('home')}"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined,
                  color: Colors.black54, size: 30),
              activeIcon: Icon(
                Icons.calendar_month,
                size: 30,
              ),
              label:
                  "${AppLocalizations.of(context)?.translate('appointments')}"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_text,
                  color: Colors.black54, size: 30),
              activeIcon: Icon(
                CupertinoIcons.chat_bubble_text_fill,
                size: 30,
              ),
              label: "${AppLocalizations.of(context)?.translate('chat')}"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined,
                  color: Colors.black54, size: 30),
              activeIcon: Icon(
                Icons.settings,
                size: 30,
              ),
              label: "${AppLocalizations.of(context)?.translate('settings')}")
        ],
      ),
    );
  }
}
