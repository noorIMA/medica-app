// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/Home_Screen.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class confirmationScreen extends StatefulWidget {
  final String doctorId;
  final DateTime date;
  final String time;

  const confirmationScreen(
      {required this.doctorId, required this.time, required this.date});

  @override
  State<confirmationScreen> createState() => _confirmationScreenState();
}

class _confirmationScreenState extends State<confirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.localeString;
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collectionGroup('Doctors')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error.toString()}'),
                    );
                  }
                  var doctorDocs = snapshot.data!.docs;
                  var doctorDoc = _findDoctor(doctorDocs, widget.doctorId);

                  if (doctorDoc == null) {
                    return Center(
                      child: Text('Doctor not found'),
                    );
                  }

                  var doctorData = doctorDoc.data() as Map<String, dynamic>;
                  var name = doctorData['Name_$locale'];
                  var hName = doctorData['hName_$locale'];
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Image.asset('lib/images/checked.png'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          '${AppLocalizations.of(context)?.translate('appstmt')} $name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: localeProvider.locale.languageCode == 'ar'
                            ? EdgeInsets.only(right: 8)
                            : EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.building_2_fill,
                              size: 30,
                              color: Color.fromARGB(255, 58, 139, 148),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                hName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: localeProvider.locale.languageCode == 'ar'
                            ? EdgeInsets.only(right: 8)
                            : EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar_today,
                              size: 30,
                              color: Color.fromARGB(255, 58, 139, 148),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                '${widget.date.day.toString()}/${widget.date.month.toString()}/${widget.date.year.toString()}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: localeProvider.locale.languageCode == 'ar'
                            ? EdgeInsets.only(right: 8)
                            : EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.time,
                              size: 30,
                              color: Color.fromARGB(255, 58, 139, 148),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                widget.time,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen())),
                        child: Center(
                          child: Text(
                            "${AppLocalizations.of(context)?.translate('backtohome')}",
                            style: TextStyle(
                                color: Color.fromARGB(255, 58, 139, 148),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  QueryDocumentSnapshot<Map<String, dynamic>>? _findDoctor(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, String doctorId) {
    for (var doc in docs) {
      if (doc.id == doctorId) {
        return doc;
      }
    }
    return null;
  }
}
