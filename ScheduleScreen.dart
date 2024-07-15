import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> _scheduledAppointments = [];

  @override
  void initState() {
    super.initState();
    _bookedAppointment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context)?.translate('scheduled')}'),
      ),
      body:  _scheduledAppointments.isEmpty
          ? Center(child: Text('No scheduled appointments'))
          : ListView.builder(
              itemCount: _scheduledAppointments.length,
              itemBuilder: (context, index) {
                var appointment = _scheduledAppointments[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
                  child: Container(
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
                      title: Text(
                        '${AppLocalizations.of(context)?.translate('date')}: ${appointment['date']}',
                        style: TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 58, 139, 148),fontSize: 20),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${AppLocalizations.of(context)?.translate('time')}: ${appointment['time']}'),
                          Text('${AppLocalizations.of(context)?.translate('name')}: ${appointment['userName']}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _bookedAppointment() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    try {
      var doctorSnapshot =
          await FirebaseFirestore.instance.collectionGroup('Doctors').get();

      QueryDocumentSnapshot<Map<String, dynamic>>? doctorDoc;
      try {
        doctorDoc = doctorSnapshot.docs
            .firstWhere((doc) => doc.id == ap.doctorModel.did);
      } catch (e) {
        doctorDoc = null;
      }

      if (doctorDoc != null) {
        var snapshot =
            await doctorDoc.reference.collection('Appointments').get();

        List<Map<String, dynamic>> scheduledAppointments = [];

        if (snapshot.docs.isNotEmpty) {
          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day);
          for (var doc in snapshot.docs) {
            var appointmentData = doc.data();
            var times =
                List<Map<String, dynamic>>.from(appointmentData['times']);

            for (var time in times) {
              if (time['reserved'] == true) {
                DateTime appointmentDateTime = appointmentData['date'].toDate();
                String date =
                    "${appointmentDateTime.day.toString()}/${appointmentDateTime.month.toString()}/${appointmentDateTime.year.toString()}";

                if (appointmentDateTime.isAtSameMomentAs(today)) {
                  String timeString = time['time'];
                  int hour = int.parse(timeString.split(':')[0]);
                  int minute =
                      int.parse(timeString.split(':')[1].split(' ')[0]);
                  String period = timeString.split(' ')[1];

                  if ((period == 'PM' && hour < 12) ||
                      (period == 'AM' && hour == 12)) {
                    hour += 12;
                  }

                  TimeOfDay currentTime = TimeOfDay.fromDateTime(now);
                  TimeOfDay appointmentTime =
                      TimeOfDay(hour: hour, minute: minute);

                  if (currentTime.hour < appointmentTime.hour ||
                      (currentTime.hour == appointmentTime.hour &&
                          currentTime.minute < appointmentTime.minute)) {
                    String userName = await getUserName(time['userId']);
                    scheduledAppointments.add({
                      'date': date,
                      'time': time['time'],
                      'userName': userName,
                    });
                  }
                } else if (appointmentDateTime.isAfter(today)) {
                  String userName = await getUserName(time['userId']);
                  scheduledAppointments.add({
                    'date': date,
                    'time': time['time'],
                    'userName': userName,
                  });
                }
              }
            }
          }

          setState(() {
            _scheduledAppointments = scheduledAppointments;
          });
        }
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  Future<String> getUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        String userName =
            "${userSnapshot['firstName']} ${userSnapshot['lastName']}";
        return userName;
      } else {
        return 'User not found';
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return 'Error';
    }
  }
}
