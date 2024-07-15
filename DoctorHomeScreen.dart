import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/DoctorAppointments_Screen.dart';
import 'package:medica_app/Screens/DoctorChatList.dart';
import 'package:medica_app/Screens/EditDoctorProfile_Screen.dart';
import 'package:medica_app/Screens/ScheduleScreen.dart';
import 'package:medica_app/Screens/Settings_Screen.dart';
import 'package:medica_app/Screens/doctoruser_screen.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/widgets/AppBarD_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Doctorhomescreen extends StatefulWidget {
  const Doctorhomescreen({super.key});

  @override
  State<Doctorhomescreen> createState() => _DoctorhomescreenState();
}

class _DoctorhomescreenState extends State<Doctorhomescreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
     final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.localeString;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 58, 139, 148),
                ),
                child: Column(
                  children: [
                    AppBarDWidget(),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DoctorAppointmentsScreen()),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 58, 139, 148),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.calendar_badge_plus,
                                color: Colors.white,
                                size: 80,
                              ),
                              SizedBox(height: 5),
                              Text('${AppLocalizations.of(context)?.translate('appointments')}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: (){
                             Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ScheduleScreen()),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 58, 139, 148),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.table_view,
                                color: Colors.white,
                                size: 80,
                              ),
                              SizedBox(height: 5),
                              Text('${AppLocalizations.of(context)?.translate('schedule')}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 40),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DoctorChatListScreen()),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 58, 139, 148),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.chat_bubble,
                                color: Colors.white,
                                size: 80,
                              ),
                              SizedBox(height: 5),
                              Text('${AppLocalizations.of(context)?.translate('chat')}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: (){
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsScreen()),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 58, 139, 148),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.settings,
                                color: Colors.white,
                                size: 80,
                              ),
                              SizedBox(height: 5),
                              Text('${AppLocalizations.of(context)?.translate('settings')}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: locale=="en"?Text("${ap.doctorModel.name_en}"):Text("${ap.doctorModel.name_ar}"),
              accountEmail: Text("+${ap.doctorModel.phoneNumber}"),
              currentAccountPicture: ap.doctorModel.photoUrl == ""
                  ? CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 58, 139, 148),
                      child: Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(ap.doctorModel.photoUrl),
                    ),
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 58, 139, 148)),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title:
                  Text('${AppLocalizations.of(context)?.translate('profile')}'),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditDoctorProfileScreen(
                            doctor: ap.doctorModel,
                          )),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            //   onTap: () => null,
            // ),
            ListTile(
              leading: Icon(Icons.share),
              title:
                  Text('${AppLocalizations.of(context)?.translate('share')}'),
              onTap: () {
                Share.share(
                    "${AppLocalizations.of(context)?.translate('sharestmt')}");
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title:
                  Text('${AppLocalizations.of(context)?.translate('logout')}'),
              onTap: () {
                ap.userSignOut().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorUserScreen(),
                        ),
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
