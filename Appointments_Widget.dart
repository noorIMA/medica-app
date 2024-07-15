// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/Screens/Home_Screen.dart';
import 'package:medica_app/Screens/Reschedule_Screen.dart';
import 'package:medica_app/model/appointments_model.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class AppointmentsWidget extends StatefulWidget {
  final List<appointmentModel> appointments;
  final String uId;
  const AppointmentsWidget({required this.appointments, required this.uId});

  @override
  State<AppointmentsWidget> createState() => _AppointmentsWidgetState();
}

class _AppointmentsWidgetState extends State<AppointmentsWidget> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.localeString;
    return ListView.builder(
      itemCount: widget.appointments.length,
      itemBuilder: (context, index) {
        final appointment = widget.appointments[index];
        return StreamBuilder(
          stream:
              FirebaseFirestore.instance.collectionGroup('Doctors').snapshots(),
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
            var doctorDoc = _findDoctor(doctorDocs, appointment.doctorId);

            if (doctorDoc == null) {
              return Center(
                child: Text('Doctor not found'),
              );
            }

            var doctorData = doctorDoc.data() as Map<String, dynamic>;
            var name = doctorData['Name_$locale'];
            var hName = doctorData['hName_$locale'];
            var photoUrl = doctorData['Picture'];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
              child: Expanded(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: localeProvider.locale.languageCode == 'ar'
                                ? EdgeInsets.only(right: 10, bottom: 35)
                                : EdgeInsets.only(left: 10, bottom: 35),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                height: 90,
                                width: 90,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  '${AppLocalizations.of(context)?.translate('dr')} $name',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 58, 139, 148),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  hName,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${appointment.date.day.toString()}/${appointment.date.month.toString()}/${appointment.date.year.toString()}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepOrangeAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  appointment.time,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepOrangeAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RescheduleScreen(
                                      doctorId: appointment.doctorId,
                                      date: appointment.date,
                                      time: appointment.time,
                                      aid: appointment.aid),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              width: 90,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color.fromARGB(255, 58, 139, 148),
                                  width: 2.0,
                                ),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                '${AppLocalizations.of(context)?.translate('reschedule')}',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 58, 139, 148),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              removeAppointment(
                                  context,
                                  appointment.aid,
                                  appointment.doctorId,
                                  appointment.date,
                                  appointment.time);
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              width: 90,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Color.fromARGB(255, 58, 139, 148),
                                  width: 2.0,
                                ),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                '${AppLocalizations.of(context)?.translate('cancel')}',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 58, 139, 148),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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

  void removeAppointment(BuildContext context, String aid, String doctorId,
      DateTime date, String time) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uId)
        .collection('appointments')
        .doc(aid)
        .delete();
    var doctorSnapshot =
        await FirebaseFirestore.instance.collectionGroup('Doctors').get();

    QueryDocumentSnapshot<Map<String, dynamic>>? doctorDoc;
    try {
      doctorDoc = doctorSnapshot.docs.firstWhere((doc) => doc.id == doctorId);
    } catch (e) {
      doctorDoc = null;
    }

    if (doctorDoc != null) {
      var selectedDateGMT3 = date.add(Duration(hours: 3));
      var startOfDay = Timestamp.fromDate(DateTime(
          selectedDateGMT3.year, selectedDateGMT3.month, selectedDateGMT3.day));
      var endOfDay = Timestamp.fromDate(DateTime(selectedDateGMT3.year,
          selectedDateGMT3.month, selectedDateGMT3.day, 23, 59, 59));

      var snapshot = await doctorDoc.reference
          .collection('Appointments')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var appointmentDoc = snapshot.docs.first;
        var appointmentData = appointmentDoc.data();
        if (appointmentData != null) {
          var times = List<Map<String, dynamic>>.from(appointmentData['times']);
          for (var i = 0; i < times.length; i++) {
            if (times[i]['time'] == time) {
              times[i]['reserved'] = false;
              times[i]['userId'] = "";

              break;
            }
          }
          await appointmentDoc.reference.update({'times': times}).then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          });
        }
      }
    }
  }
}
