// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/model/appointments_model.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:medica_app/widgets/Appointments_Widget.dart';
import 'package:medica_app/widgets/Fappointments_Widget.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    Future<List<appointmentModel>> appointmentsFuture =
        getAppointments(ap.userModel.uid);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${AppLocalizations.of(context)?.translate('appointments')}',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          toolbarHeight: 70,
          backgroundColor: Color.fromARGB(255, 58, 139, 148),
          bottom: TabBar(
            tabs: [
              Tab(text: '${AppLocalizations.of(context)?.translate('upcoming')}'),
              Tab(text: '${AppLocalizations.of(context)?.translate('completed')}'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: const Color.fromARGB(255, 195, 193, 193),
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            indicatorColor: Colors.white,
            indicatorWeight: 4.0,
          ),
        ),
        body: FutureBuilder<List<appointmentModel>>(
          future: appointmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No appointments found.'));
            } else {
              final now = DateTime.now();
              final upcomingAppointments = snapshot.data!
                  .where((a) =>
                      a.date.year >= now.year &&
                      a.date.month >= now.month &&
                      a.date.day >= now.day)
                  .toList();
              final finishedAppointments = snapshot.data!
                  .where((a) =>
                      a.date.year < now.year ||
                      a.date.month < now.month ||
                      a.date.day < now.day)
                  .toList();

              return TabBarView(
                children: [
                  AppointmentsWidget(
                      appointments: upcomingAppointments,
                      uId: ap.userModel.uid),
                  FAppointmentsWidget(appointments: finishedAppointments),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<appointmentModel>> getAppointments(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('appointments')
        .get();
    return snapshot.docs
        .map((doc) => appointmentModel.fromFirestore(doc))
        .toList();
  }
}
