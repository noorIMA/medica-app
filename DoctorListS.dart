// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls, file_names, library_private_types_in_public_api

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/Screens/Doctor_Profile.dart';
import 'package:medica_app/model/doctor_model.dart';
import 'package:http/http.dart' as http;
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class DoctorListS extends StatefulWidget {
  final String specializationName;
  final double sLatitude;
  final double sLongitude;

  const DoctorListS({
    required this.specializationName,
    required this.sLatitude,
    required this.sLongitude,
  });

  @override
  _DoctorListSState createState() => _DoctorListSState();
}

class _DoctorListSState extends State<DoctorListS> {
  List<DoctorModel> doctors = [];
  final Map<String, double> _distances = {};
  final Map<String, String> _errors = {};
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedValue = AppLocalizations.of(context)?.translate('All');
      });
    });
  }

  Future<void> fetchDoctors() async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.localeString;
    try {
      final hospitals =
          await FirebaseFirestore.instance.collection('Hospitals').get();
      for (final hospital in hospitals.docs) {
        final specializations = await hospital.reference
            .collection('Specializations')
            .where('Picture', isEqualTo: widget.specializationName)
            .get();
        for (final specialization in specializations.docs) {
          final doctorsData =
              await specialization.reference.collection('Doctors').get();
          for (final doctorDoc in doctorsData.docs) {
            setState(() {
              Map<String, dynamic>? data =
                  doctorDoc.data() as Map<String, dynamic>?;

              if (data != null &&
                  data.containsKey('Mobile Number') &&
                  data.containsKey('Rating') &&
                  data.containsKey('Experience') &&
                  data.containsKey('Gender') &&
                  data.containsKey('Picture') &&
                  data.containsKey('Latitude') &&
                  data.containsKey('Longitude')) {
                doctors.add(DoctorModel(
                    name_en: doctorDoc['Name_en'],
                    name_ar: doctorDoc['Name_ar'],
                    phoneNumber: doctorDoc['Mobile Number'],
                    Latitude: doctorDoc['Latitude'],
                    Longitude: doctorDoc['Longitude'],
                    rating: doctorDoc['Rating'],
                    experience: doctorDoc['Experience'],
                    gender: doctorDoc['Gender'],
                    description: doctorDoc['Description'],
                    email: doctorDoc['Email'],
                    photoUrl: doctorDoc['Picture'],
                    specialization: doctorDoc['sName_$locale'],
                    hospital: doctorDoc['hName_$locale'],
                    did: doctorDoc.id));
              }
            });
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    for (var doctor in doctors) {
      _fetchDistance(
        widget.sLatitude,
        widget.sLongitude,
        doctor.Latitude,
        doctor.Longitude,
        doctor.did,
      );
    }
  }

  List<DoctorModel> filterDoctors(List<DoctorModel> doctors) {
    List<DoctorModel> filteredDoctors;

    if (selectedValue ==
        AppLocalizations.of(context)?.translate('Female Doctors')) {
      filteredDoctors = doctors.where((doctor) {
        return doctor.gender == "Female";
      }).toList();
    } else if (selectedValue ==
        AppLocalizations.of(context)?.translate('Male Doctors')) {
      filteredDoctors = doctors.where((doctor) {
        return doctor.gender == "Male";
      }).toList();
    } else {
      filteredDoctors = List.from(doctors);
    }

    if (selectedValue ==
        AppLocalizations.of(context)?.translate('Highest Rating')) {
      filteredDoctors.sort((a, b) => b.rating.compareTo(a.rating));
    }
    if (selectedValue ==
        AppLocalizations.of(context)?.translate('Most Experience')) {
      filteredDoctors.sort((a, b) => b.experience.compareTo(a.experience));
    }

    return filteredDoctors;
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.localeString;
    List<DoctorModel> sortedDoctors = List.from(doctors);
    sortedDoctors.sort((a, b) {
      double distanceA = _distances[a.did] ?? double.infinity;
      double distanceB = _distances[b.did] ?? double.infinity;
      return distanceA.compareTo(distanceB);
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 58, 139, 148),
        toolbarHeight: 80,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 40,
          ),
        ),
        title: widget.sLatitude == 0 && widget.sLongitude == 0
            ? Text("${AppLocalizations.of(context)?.translate('Specialist')}")
            : Text("${AppLocalizations.of(context)?.translate('Specialists')}"),
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
          Align(
            alignment: localeProvider.locale.languageCode == 'ar'
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedValue,
                      items: [
                        AppLocalizations.of(context)?.translate('All') ?? "",
                        AppLocalizations.of(context)
                                ?.translate('Female Doctors') ??
                            "",
                        AppLocalizations.of(context)
                                ?.translate('Male Doctors') ??
                            "",
                        AppLocalizations.of(context)
                                ?.translate('Highest Rating') ??
                            "",
                        AppLocalizations.of(context)
                                ?.translate('Most Experience') ??
                            "",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                color: value == selectedValue
                                    ? Color.fromARGB(255, 58, 139, 148)
                                    : Colors.black,
                                fontWeight: value == selectedValue
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromARGB(255, 58, 139, 148),
                        size: 30,
                      ),
                      style: TextStyle(
                        color: Color.fromARGB(255, 58, 139, 148),
                        fontSize: 18,
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
          Expanded(
            child: doctors.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filterDoctors(sortedDoctors).length,
                    itemBuilder: (context, index) {
                      final doctor = filterDoctors(sortedDoctors)[index];
                      final distance = _distances[doctor.did];
                      final error = _errors[doctor.did];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
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
                                  padding:
                                      localeProvider.locale.languageCode == 'ar'
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      locale=="en"?
                                      Text(
                                        '${AppLocalizations.of(context)?.translate('dr')} ${doctor.name_en}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 58, 139, 148),
                                            fontWeight: FontWeight.bold),
                                      ): Text(
                                        '${AppLocalizations.of(context)?.translate('dr')} ${doctor.name_ar}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 58, 139, 148),
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
                                      widget.sLatitude == 0 &&
                                              widget.sLongitude == 0
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
                                                            '${distance.toString()} ${AppLocalizations.of(context)?.translate('km')} ',
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
                  ),
          ),
        ],
      ),
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

      print('Fetching distance for hospital ID: $doctorId');
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
              _distances[doctorId] = distance;
              _errors.remove(doctorId);
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
      print('Error fetching distance for hospital ID: $doctorId: $e');
      if (mounted) {
        setState(() {
          _errors[doctorId] = 'Distance not found';
        });
      }
    }
  }
}
