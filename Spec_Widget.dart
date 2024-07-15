// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/model/specialization_model.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/widgets/DoctorListS.dart';
import 'package:provider/provider.dart';

class SpecializationWidget extends StatefulWidget {
  final double sLatitude;
  final double sLongitude;

  const SpecializationWidget({
    required this.sLatitude,
    required this.sLongitude,
  });
  @override
  _SpecializationWidgetState createState() => _SpecializationWidgetState();
}

class _SpecializationWidgetState extends State<SpecializationWidget> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.localeString;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('Specializations')
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

        List<specializationModel> Specializations = [];
        Set<String> specializationIds = Set();

        snapshot.data!.docs.forEach((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (!specializationIds.contains(doc['Picture'])) {
            if (data != null && data.containsKey('Picture')) {
              Specializations.add(specializationModel(
                name: doc['Name_$locale'],
                photoUrl: doc['Picture'],
                sId: doc.id,
              ));
            }
            specializationIds.add(doc['Picture']);
          }
        });

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var specialization in Specializations)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                       Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorListS(
                                specializationName: specialization.photoUrl,
                                sLatitude: widget.sLatitude,
                                sLongitude: widget.sLongitude,
                              ),
                            ),
                          );
                    },
                    child: Container(
                      width: 130,
                      height: 160,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            padding: EdgeInsets.all(10),
                            child: Image.network(
                              specialization.photoUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              specialization.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 58, 139, 148),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
