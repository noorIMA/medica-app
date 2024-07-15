// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medica_app/model/hospital_model.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/widgets/Specialization_List.dart';
import 'package:provider/provider.dart';

class HospitalList extends StatefulWidget {
  final String searchText;
  final double sLatitude;
  final double sLongitude;

  const HospitalList({
    required this.searchText,
    required this.sLatitude,
    required this.sLongitude,
  });

  @override
  _HospitalListState createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  final Map<String, double> _distances = {};
  final Map<String, String> _errors = {};
  List<hospitalModel> _hospitals = [];

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
  }

  void _fetchHospitals() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Hospitals').get();
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.localeString;
    List<hospitalModel> hospitals = snapshot.docs.map((doc) {
      return hospitalModel(
        name: doc['Name_$locale'],
        phoneNumber: doc['Phone Number'],
        Latitude: doc['Latitude'],
        Longitude: doc['Longitude'],
        day: "Mon-Sun",
        time: "10:00 AM-10:00 PM",
        location: doc['Location_$locale'],
        photoUrl: doc['Picture'],
        hId: doc.id,
      );
    }).toList();

    setState(() {
      _hospitals = hospitals;
    });

    for (var hospital in hospitals) {
      _fetchDistance(
        widget.sLatitude,
        widget.sLongitude,
        hospital.Latitude,
        hospital.Longitude,
        hospital.hId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    _hospitals = _hospitals.where((hospital) {
      String name = hospital.name.toLowerCase();
      return name.contains(widget.searchText.toLowerCase());
    }).toList();
    List<hospitalModel> sortedHospitals = List.from(_hospitals);
    sortedHospitals.sort((a, b) {
      double distanceA = _distances[a.hId] ?? double.infinity;
      double distanceB = _distances[b.hId] ?? double.infinity;
      return distanceA.compareTo(distanceB);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sortedHospitals.length,
      itemBuilder: (context, index) {
        final hospital = sortedHospitals[index];
        final distance = _distances[hospital.hId];
        final error = _errors[hospital.hId];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpecializationList(
                    hospitalId: hospital.hId,
                    hospitalName: hospital.name,
                    distance: distance ?? double.infinity,
                    sLatitude: widget.sLatitude,
                    sLongitude: widget.sLongitude,
                  ),
                ),
              );
            },
            child: Container(
              height: 180,
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
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: localeProvider.locale.languageCode == 'ar'
                        ? EdgeInsets.only(right: 10)
                        : EdgeInsets.only(left: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        hospital.photoUrl,
                        fit: BoxFit.cover,
                        height: 120,
                        width: 110,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          hospital.name,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 58, 139, 148),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          hospital.location,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
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
                                              '${distance.toString()} ${AppLocalizations.of(context)?.translate('km')}',
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 239, 29, 6),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchDistance(
    double sLatitude,
    double sLongitude,
    double dLatitude,
    double dLongitude,
    String hospitalId,
  ) async {
    try {
      final String apiKey = "AIzaSyC3heZ71W5sKf-_zUL5KNs38lkFL9lanEY";
      final String url = 'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=$sLatitude,$sLongitude'
          '&destination=$dLatitude,$dLongitude'
          '&mode=driving&key=$apiKey';

      print('Fetching distance for hospital ID: $hospitalId');
      print('URL: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          double distance =
              (data['routes'][0]['legs'][0]['distance']['value']).toDouble() /
                  1000;
          if (mounted) {
            setState(() {
              _distances[hospitalId] = distance;
              _errors.remove(hospitalId);
            });
          }
        } else if (data['status'] == 'ZERO_RESULTS') {
          throw Exception('No route found between the specified locations.');
        } else {
          throw Exception('Error fetching directions: ${data['status']}');
        }
      } else {
        throw Exception('Failed to fetch directions');
      }
    } catch (e) {
      print('Error fetching distance for hospital ID: $hospitalId: $e');
      if (mounted) {
        setState(() {
          _errors[hospitalId] = 'Distance not found';
        });
      }
    }
  }
}
