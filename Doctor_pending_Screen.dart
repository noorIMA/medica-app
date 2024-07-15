import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class DoctorPenScreen extends StatefulWidget {
  final String id;
  const DoctorPenScreen({required this.id});

  @override
  State<DoctorPenScreen> createState() => _DoctorPenScreenState();
}

class _DoctorPenScreenState extends State<DoctorPenScreen> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.localeString;
    CollectionReference users =
        FirebaseFirestore.instance.collection('doctors_pending');

    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context)?.translate('DoctorD')}'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('not found'));
          }

          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildField(
                        '${AppLocalizations.of(context)?.translate('dnamee')}',
                        userData['name_en']),
                    _buildField(
                        '${AppLocalizations.of(context)?.translate('dnamea')}',
                        userData['name_ar']),
                    _buildField(
                        '${AppLocalizations.of(context)?.translate('email')}',
                        userData['email']),
                    _buildField(
                        '${AppLocalizations.of(context)?.translate('phone')}',
                        '+${userData['phone'].toString()}'),
                    _buildField(
                        '${AppLocalizations.of(context)?.translate('description')}',
                        userData['description']),
                    _buildField(
                        '${AppLocalizations.of(context)?.translate('experience')}',
                        userData['experience'].toString()),
                    _buildField(
                        '${AppLocalizations.of(context)?.translate('gender')}',
                        userData['gender']),
                    _buildField(
                        '${AppLocalizations.of(context)?.translate('hos')}',
                        userData['hName_$locale']),
                    _buildField(
                        '${AppLocalizations.of(context)?.translate('spec')}',
                        userData['sName_$locale']),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 140,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () =>
                                  approveDoctor(widget.id, userData),
                              child: Text(
                                '${AppLocalizations.of(context)?.translate('approve')}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 58, 139, 148),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 140,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => rejectDoctor(widget.id),
                              child: Text(
                                '${AppLocalizations.of(context)?.translate('reject')}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 58, 139, 148),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(String fieldName, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color.fromARGB(255, 58, 139, 148),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> rejectDoctor(String docId) async {
    await FirebaseFirestore.instance
        .collection('doctors_pending')
        .doc(docId)
        .delete();
  }

  Future<void> approveDoctor(
      String docId, Map<String, dynamic> doctorData) async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.localeString;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Hospitals')
        .where('Name_$locale', isEqualTo: doctorData['hName_$locale'])
        .limit(1)
        .get();

    String hId = querySnapshot.docs.first.id;
    QuerySnapshot Snapshot = await FirebaseFirestore.instance
        .collection('Hospitals')
        .doc(hId)
        .collection('Specializations')
        .where('Name_$locale', isEqualTo: doctorData['sName_$locale'])
        .limit(1)
        .get();
    String sId = Snapshot.docs.first.id;

    await FirebaseFirestore.instance
      .collection('Hospitals')
          .doc(hId)
          .collection('Specializations')
          .doc(sId)
          .collection('Doctors')
          .add({
            'Name_en': doctorData['name_en'],
            'Name_ar': doctorData['name_ar'],
            'Email': doctorData['email'],
            'Mobile Number': doctorData['phone'],
            'Experience': doctorData['experience'],
            'Description': doctorData['description'],
            'hName_en': doctorData['hName_en'],
            'hName_ar': doctorData['hName_ar'],
            'sName_en': doctorData['sName_en'],
            'sName_ar': doctorData['sName_ar'],
            'Latitude': doctorData['Latitude'],
            'Longitude': doctorData['Longitude'],
            'Gender': doctorData['gender'],
            'Picture': doctorData['picture'],
            'Rating':0,
          });

    await FirebaseFirestore.instance
        .collection('doctors_pending')
        .doc(docId)
        .delete();
  }
}
