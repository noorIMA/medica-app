// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls, non_constant_identifier_names, sort_child_properties_last, use_build_context_synchronously, unnecessary_null_comparison, unused_local_variable, use_key_in_widget_constructors, deprecated_member_use

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  DateTime _selectedDate = DateTime.now();
  List<dynamic> _selectedDateTimes = [];
  String _selectedTime = '';

  @override
  void initState() {
    super.initState();
    _getAppointments();
  }

  void _getAppointments() async {
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
        var selectedDateGMT3 = _selectedDate.add(Duration(hours: 3));
        var startOfDay = Timestamp.fromDate(DateTime(selectedDateGMT3.year,
            selectedDateGMT3.month, selectedDateGMT3.day));
        var endOfDay = Timestamp.fromDate(DateTime(selectedDateGMT3.year,
            selectedDateGMT3.month, selectedDateGMT3.day, 23, 59, 59));

        var snapshot = await doctorDoc.reference
            .collection('Appointments')
            .where('date', isGreaterThanOrEqualTo: startOfDay)
            .where('date', isLessThan: endOfDay)
            .get();
        List<dynamic> times = [];
        snapshot.docs.forEach((doc) {
          List<dynamic> appointmentTimes = doc['times'];
          times.addAll(appointmentTimes);
        });
        setState(() {
          _selectedDateTimes = times;
        });
      } else {
        print('Doctor does not exist.');
      }
    } catch (e) {
      print('Error fetching doctor: $e');
    }
  }

  void _addAppointment(String selectedTime) async {
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
        var selectedDateGMT3 = _selectedDate.add(Duration(hours: 3));
        var startOfDay = Timestamp.fromDate(DateTime(selectedDateGMT3.year,
            selectedDateGMT3.month, selectedDateGMT3.day));
        var endOfDay = Timestamp.fromDate(DateTime(selectedDateGMT3.year,
            selectedDateGMT3.month, selectedDateGMT3.day, 23, 59, 59));

        var snapshot = await doctorDoc.reference
            .collection('Appointments')
            .where('date', isGreaterThanOrEqualTo: startOfDay)
            .where('date', isLessThan: endOfDay)
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          await doctorDoc.reference.collection('Appointments').add({
            'date': startOfDay,
            'times': [
              {'time': selectedTime, 'reserved': false}
            ]
          });
        } else {
          var doc = snapshot.docs.first;
          List<dynamic> times = List.from(doc['times']);
          times.add({'time': selectedTime, 'reserved': false});
          await doc.reference.update({'times': times});
        }
        triggerNotification(_selectedDate, selectedTime);
        _getAppointments();
      } else {
        print('Doctor does not exist.');
      }
    } catch (e) {
      print('Error adding appointment: $e');
    }
  }

  Future<void> _showAddTimeDialog() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      String formattedTime = _formatTime(selectedTime);
      _addAppointment(formattedTime);
    }
  }

  String _formatTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final formatter = DateFormat.jm();
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
            size: 40,
          ),
        ),
        title:
            Text("${AppLocalizations.of(context)?.translate('appointment')}"),
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16),
                Text(
                  '${AppLocalizations.of(context)?.translate('selectdate')}:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400, width: 1),
                color: Colors.transparent,
              ),
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _selectedDate,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                  });
                  _getAppointments();
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16),
                Text(
                  '${AppLocalizations.of(context)?.translate('times')}:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _selectedDateTimes.map((time) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTime = time['time'];
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _selectedTime == time['time']
                          ? Color.fromARGB(255, 58, 139, 148)
                          : Color.fromARGB(255, 173, 227, 233),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        time['time'],
                        style: TextStyle(
                          color: _selectedTime == time['time']
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.80,
                child: ElevatedButton(
                  onPressed: _showAddTimeDialog,
                  child: Text(
                    '${AppLocalizations.of(context)?.translate('add')}',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Color.fromARGB(255, 58, 139, 148),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.80,
                child: ElevatedButton(
                  onPressed: _selectedTime.isEmpty
                      ? null
                      : () {
                          print(_selectedTime);

                          _removeAppointment(_selectedTime);
                        },
                  child: Text(
                    '${AppLocalizations.of(context)?.translate('cancela')}',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Color.fromARGB(255, 58, 139, 148),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _removeAppointment(String selectedTime) async {
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
        var selectedDate = _selectedDate.add(Duration(hours: 3));
        var startOfDay = Timestamp.fromDate(
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day));
        var endOfDay = Timestamp.fromDate(DateTime(selectedDate.year,
            selectedDate.month, selectedDate.day, 23, 59, 59));

        var snapshot = await doctorDoc.reference
            .collection('Appointments')
            .where('date', isGreaterThanOrEqualTo: startOfDay)
            .where('date', isLessThan: endOfDay)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          var appointmentDoc = snapshot.docs.first;
          var appointmentData = appointmentDoc.data();

          var times = List<Map<String, dynamic>>.from(appointmentData['times']);

          // Check if the appointment was reserved and remove it from user's collection
          Map<String, dynamic>? reservedAppointment = null;

// Iterate over times list
          for (var time in times) {
            if (time['time'] == selectedTime && time['reserved'] == true) {
              reservedAppointment = time;
              break; // Exit loop once reserved appointment is found
            }
          }
          if (reservedAppointment != null) {
            // Reserved appointment found, proceed with deletion or other logic
            print('Reserved appointment found: $reservedAppointment');
          } else {
            // Reserved appointment not found
            print('No reserved appointment found for $selectedTime');
          }
          if (reservedAppointment != null) {
            print(reservedAppointment['userId']);
            times.removeWhere((time) =>
                time['time'] == selectedTime && time['reserved'] == true);

            await appointmentDoc.reference.update({'times': times});
            var userSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(reservedAppointment['userId'])
                .collection('appointments')
                .where('date', isGreaterThanOrEqualTo: startOfDay)
                .where('date', isLessThan: endOfDay)
                .where('time', isEqualTo: selectedTime)
                .limit(1)
                .get();
            if (userSnapshot.docs.isNotEmpty) {
              await userSnapshot.docs.first.reference.delete();
            }
          } else {
            times.removeWhere((time) => time['time'] == selectedTime);
            await appointmentDoc.reference.update({'times': times});
          }
        }
        _getAppointments();
        setState(() {
          _selectedTime = '';
        });
      }
    } catch (e) {
      print('Error removing appointment: $e');
    }
  }

  triggerNotification(DateTime date, String time) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: "basic_channel",
      title: "${AppLocalizations.of(context)?.translate('appstmt3')}",
      body:
          "Date : ${date.day.toString()}/${date.month.toString()}/${date.year.toString()}  Time: $time",
    ));
  }
}
