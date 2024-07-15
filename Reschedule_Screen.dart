// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls, non_constant_identifier_names, sort_child_properties_last, use_build_context_synchronously, unnecessary_null_comparison, unused_local_variable, use_key_in_widget_constructors, deprecated_member_use

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/Confirmation_Screen.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class RescheduleScreen extends StatefulWidget {
  final String doctorId;
  final DateTime date;
  final String time;
  final String aid;

  const RescheduleScreen(
      {required this.doctorId,
      required this.date,
      required this.time,
      required this.aid});

  @override
  State<RescheduleScreen> createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  late DateTime _selectedDate;
  List<dynamic> _selectedDateTimes = [];
  String _selectedTime = "";

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    _getAppointments();
  }

  void _getAppointments() async {
    try {
      var doctorSnapshot =
          await FirebaseFirestore.instance.collectionGroup('Doctors').get();

      QueryDocumentSnapshot<Map<String, dynamic>>? doctorDoc;
      try {
        doctorDoc =
            doctorSnapshot.docs.firstWhere((doc) => doc.id == widget.doctorId);
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

  Future<void> bookAppointment(
      String doctorId, DateTime date, String time, String uid) async {
    try {
      DocumentReference appointmentRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('appointments')
          .add({
        'doctorId': doctorId,
        'date': Timestamp.fromDate(date),
        'time': time,
      });

      String appointmentId = appointmentRef.id;
      await appointmentRef.update({'aid': appointmentId});

      var doctorSnapshot =
          await FirebaseFirestore.instance.collectionGroup('Doctors').get();

      QueryDocumentSnapshot<Map<String, dynamic>>? doctorDoc;
      try {
        doctorDoc =
            doctorSnapshot.docs.firstWhere((doc) => doc.id == widget.doctorId);
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

        if (snapshot.docs.isNotEmpty) {
          var appointmentDoc = snapshot.docs.first;
          var appointmentData = appointmentDoc.data();
          if (appointmentData != null) {
            var times =
                List<Map<String, dynamic>>.from(appointmentData['times']);
            for (var i = 0; i < times.length; i++) {
              if (times[i]['time'] == time) {
                times[i]['reserved'] = true;
                times[i]['userId'] = uid;

                break;
              }
            }
            await appointmentDoc.reference.update({'times': times});
          }
        }

        setState(() {
          _selectedTime = '';
        });

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => confirmationScreen(
                  doctorId: doctorId, time: time, date: date),
            ));
      } else {
        print('Doctor does not exist.');
      }
    } catch (e) {
      print('Error booking appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to book appointment. Please try again.'),
      ));
    }
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
        title: Text("${AppLocalizations.of(context)?.translate('res')}"),
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
                  '${AppLocalizations.of(context)?.translate('selecttime')}:',
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
                  onTap: time['reserved']
                      ? null
                      : () {
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
                          : time['reserved']
                              ? Colors.grey
                              : Color.fromARGB(255, 173, 227, 233),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        time['time'],
                        style: TextStyle(
                          color: _selectedTime == time['time']
                              ? Colors.white
                              : time['reserved']
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
                  onPressed: _selectedTime.isEmpty
                      ? null
                      : () {
                          removeAppointment(ap.userModel.uid);
                          bookAppointment(widget.doctorId, _selectedDate,
                              _selectedTime, ap.userModel.uid);
                          triggerNotification(_selectedDate, _selectedTime);
                        },
                  child: Text(
                    '${AppLocalizations.of(context)?.translate('continue')}',
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

  triggerNotification(DateTime date, String time) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 10,
      channelKey: "basic_channel",
      title: "${AppLocalizations.of(context)?.translate('appstmt2')}",
      body:
          "Date : ${date.day.toString()}/${date.month.toString()}/${date.year.toString()}  Time: $time",
    ));
  }

  void removeAppointment(String uId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('appointments')
        .doc(widget.aid)
        .delete();
    var doctorSnapshot =
        await FirebaseFirestore.instance.collectionGroup('Doctors').get();

    QueryDocumentSnapshot<Map<String, dynamic>>? doctorDoc;
    try {
      doctorDoc =
          doctorSnapshot.docs.firstWhere((doc) => doc.id == widget.doctorId);
    } catch (e) {
      doctorDoc = null;
    }

    if (doctorDoc != null) {
      var selectedDateGMT3 = widget.date.add(Duration(hours: 3));
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
            if (times[i]['time'] == widget.time) {
              times[i]['reserved'] = false;
              times[i]['userId'] = "";

              break;
            }
          }
          await appointmentDoc.reference.update({'times': times});
        }
      }
    }
  }
}
