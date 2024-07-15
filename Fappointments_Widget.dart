// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/Screens/Booking_Screen.dart';
import 'package:medica_app/model/appointments_model.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class FAppointmentsWidget extends StatelessWidget {
  final List<appointmentModel> appointments;
  const FAppointmentsWidget({required this.appointments});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.localeString;
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
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
              child: Container(
                height: 170,
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
                child: Row(
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
                          Row(
                            children: [
                              Column(
                                children: [
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
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookingScreen(
                                          doctorId: appointment.doctorId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                          localeProvider.locale.languageCode ==
                                                  'ar'
                                              ? EdgeInsets.only(left: 5)
                                              : EdgeInsets.only(right: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              Color.fromARGB(255, 58, 139, 148),
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Text(
                                        '${AppLocalizations.of(context)?.translate('bookagain')}',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 58, 139, 148),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
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
}
