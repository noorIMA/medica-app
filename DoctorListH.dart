// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/Doctor_Profile.dart';
import 'package:medica_app/model/doctor_model.dart';
import 'package:http/http.dart' as http;
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class DoctorListH extends StatefulWidget {
  final String specializationId;
  final String hospitalId;
  final double distance;
  final double sLatitude;
  final double sLongitude;

  const DoctorListH(
      {required this.specializationId,
      required this.hospitalId,
      required this.distance,
      required this.sLatitude,
      required this.sLongitude});
  @override
  _DoctorListHState createState() => _DoctorListHState();
}

class _DoctorListHState extends State<DoctorListH> {
  final Map<String, double> _distances = {};
  final Map<String, String> _errors = {};
  bool _fetchingDistances = false;

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.localeString;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Hospitals')
          .doc(widget.hospitalId)
          .collection('Specializations')
          .doc(widget.specializationId)
          .collection('Doctors')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Text('No data available');
        }

        List<DoctorModel> doctors = [];
        snapshot.data!.docs.forEach((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey('Mobile Number')) {
            doctors.add(DoctorModel(
                name_en: doc['Name_en'],
                name_ar: doc['Name_ar'],
                phoneNumber: doc['Mobile Number'],
                Latitude: doc['Latitude'],
                Longitude: doc['Longitude'],
                rating: doc['Rating'],
                experience: doc['Experience'],
                gender: doc['Gender'],
                description: doc['Description'],
                email: doc['Email'],
                photoUrl: doc['Picture'],
                specialization: doc['sName_$locale'],
                hospital: doc['hName_$locale'],
                did: doc.id));
          }
        });

        if (!_fetchingDistances) {
          _fetchingDistances = true;
          for (var doctor in doctors) {
            if (!_distances.containsKey(doctor.did) &&
                !_errors.containsKey(doctor.did)) {
              _fetchDistance(
                widget.sLatitude,
                widget.sLongitude,
                doctor.Latitude,
                doctor.Longitude,
                doctor.did,
              );
            }
          }
          _fetchingDistances = false;
        }

        doctors.sort((a, b) {
          double distanceA = _distances[a.did] ?? double.infinity;
          double distanceB = _distances[b.did] ?? double.infinity;
          return distanceA.compareTo(distanceB);
        });

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            final distance = _distances[doctor.did];
            final error = _errors[doctor.did];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorProfile(
                        doctorId: doctor.did,
                        distance: distance ?? double.infinity,
                        sLatitude: widget.sLatitude,
                        sLongitude: widget.sLongitude,
                      ),
                    ),
                  );
                },
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
                            ? EdgeInsets.only(right: 10)
                            : EdgeInsets.only(left: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            doctor.photoUrl,
                            fit: BoxFit.cover,
                            height: 110,
                            width: 110,
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
                            locale == "en"
                                ? Text(
                                    '${AppLocalizations.of(context)?.translate('dr')} ${doctor.name_en}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 58, 139, 148),
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    '${AppLocalizations.of(context)?.translate('dr')} ${doctor.name_ar}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 58, 139, 148),
                                        fontWeight: FontWeight.bold),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              doctor.specialization,
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              '+${doctor.experience.toString()} ${AppLocalizations.of(context)?.translate('exp')}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              '${AppLocalizations.of(context)?.translate('rating')}: ${doctor.rating.toString()}',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            widget.sLatitude == 0 && widget.sLongitude == 0
                                ? Text("")
                                : distance != null
                                    ? RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${distance.toString()}${AppLocalizations.of(context)?.translate('km')} ',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 239, 29, 6),
                                              ),
                                            ),
                                            TextSpan(
                                                text:
                                                    '${AppLocalizations.of(context)?.translate('away')}'),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        error != null
                                            ? '${AppLocalizations.of(context)?.translate('dnotfound')}'
                                            : '${AppLocalizations.of(context)?.translate('dcalc')}',
                                        style: TextStyle(
                                          color: error != null
                                              ? Colors.red
                                              : Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                          ],
                        ),
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

  Future<void> _fetchDistance(
    double sLatitude,
    double sLongitude,
    double dLatitude,
    double dLongitude,
    String doctorId,
  ) async {
    try {
      final String apiKey = "AIzaSyC3heZ71W5sKf-_zUL5KNs38lkFL9lanEY";
      final String url = 'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=$sLatitude,$sLongitude'
          '&destination=$dLatitude,$dLongitude'
          '&mode=driving&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          double distance =
              (data['routes'][0]['legs'][0]['distance']['value']).toDouble() /
                  1000;
          if (mounted) {
            setState(() {
              _distances[doctorId] = distance;
              _errors.remove(doctorId);
            });
          }
        } else if (data['status'] == 'ZERO_RESULTS') {
          if (mounted) {
            setState(() {
              _errors[doctorId] = 'No route found';
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _errors[doctorId] = 'Error fetching directions';
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _errors[doctorId] = 'Failed to fetch directions';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errors[doctorId] = 'Distance not found';
        });
      }
    }
  }
}
