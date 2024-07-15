import 'package:cloud_firestore/cloud_firestore.dart';

class appointmentModel {
  final String doctorId;
  final DateTime date;
  final String time;
  final String aid;

  appointmentModel(
      {required this.doctorId,
      required this.date,
      required this.time,
      required this.aid});
  factory appointmentModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return appointmentModel(
      doctorId: data['doctorId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      aid: data['aid'] ?? '',
    );
  }
}
