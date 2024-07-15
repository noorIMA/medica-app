import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/Doctor_pending_Screen.dart';
import 'package:medica_app/Screens/doctoruser_screen.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/widgets/AppBarA_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    CollectionReference doctors =
        FirebaseFirestore.instance.collection('doctors_pending');
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
                    AppBarAWidget(),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: StreamBuilder<QuerySnapshot>(
              stream: doctors.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return Container(
                  padding: EdgeInsets.all(10),
                  width: 200,
                  height: 300,
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorPenScreen(id: document.id),
                            ),
                          );
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text(data['name_$locale']),
                            subtitle: Text(data['email']),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("${ap.adminModel.name}"),
              accountEmail: Text("+${ap.adminModel.phoneNumber}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 58, 139, 148),
                child: Icon(
                  Icons.account_circle,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 58, 139, 148)),
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
