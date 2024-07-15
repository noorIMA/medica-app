// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls, prefer_const_literals_to_create_immutables, unnecessary_import, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/model/specialization_model.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/widgets/DoctorListH.dart';
import 'package:provider/provider.dart';

class DoctorList extends StatelessWidget {
  final String hospitalId;
  final double distance;
  final double sLatitude;
  final double sLongitude;

  const DoctorList(
      {required this.hospitalId,
      required this.distance,
      required this.sLatitude,
      required this.sLongitude});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.localeString;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Hospitals')
          .doc(hospitalId)
          .collection('Specializations')
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
        snapshot.data!.docs.forEach((doc) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          if (data != null && data.containsKey('Picture')&& data.containsKey('Name_$locale')) {
            Specializations.add(specializationModel(
              name: doc['Name_$locale'],
              photoUrl: doc['Picture'],
              sId: doc.id,
            ));
          }
        });

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: Specializations.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  title: Text(Specializations[index].name),
                  titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Divider(),
                DoctorListH(
                  specializationId: Specializations[index].sId,
                  hospitalId: hospitalId,
                  distance: distance,
                  sLatitude: sLatitude,
                  sLongitude: sLongitude,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
