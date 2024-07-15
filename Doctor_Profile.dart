// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, cast_from_null_always_fails, unnecessary_null_comparison, unnecessary_cast, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:medica_app/Screens/Booking_Screen.dart';
import 'package:medica_app/Screens/chat_Screen.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/widgets/Direction_Widget.dart';
import 'package:provider/provider.dart';

class DoctorProfile extends StatefulWidget {
  final String doctorId;
  final double distance;
  final double sLatitude;
  final double sLongitude;

  const DoctorProfile(
      {required this.doctorId,
      required this.distance,
      required this.sLatitude,
      required this.sLongitude});
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  int _currentRating = 3;
  void ratingBox(BuildContext context, var doctorDoc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${AppLocalizations.of(context)?.translate('rate')}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _currentRating = rating.toInt();
                  });
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    updateRating(_currentRating, doctorDoc).then((_) {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    '${AppLocalizations.of(context)?.translate('rated')}',
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
                    backgroundColor: Color.fromARGB(255, 58, 139, 148),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.localeString;
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
        title: Text("${AppLocalizations.of(context)?.translate('doctorp')}"),
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collectionGroup('Doctors')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error.toString()}'),
                    );
                  }
                  var doctorDocs = snapshot.data!.docs;
                  var doctorDoc = _findDoctor(doctorDocs, widget.doctorId);

                  if (doctorDoc == null) {
                    return Center(
                      child: Text('Doctor not found'),
                    );
                  }

                  var doctorData = doctorDoc.data() as Map<String, dynamic>;
                  var name = doctorData['Name_$locale'];
                  var sName = doctorData['sName_$locale'];
                  var hName = doctorData['hName_$locale'];
                  var photoUrl = doctorData['Picture'];
                  int phoneNumber = doctorData['Mobile Number'];
                  int experience = doctorData['Experience'];
                  int rating = doctorData['Rating'];
                  var email = doctorData['Email'];
                  double dLatitude = doctorData['Latitude'];
                  double dLongitude = doctorData['Longitude'];
                  int percentageRating = ratingToPercentage(rating);

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                              photoUrl,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            '${AppLocalizations.of(context)?.translate('dr')} $name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            '$sName ${AppLocalizations.of(context)?.translate('specialist')}',
                            style: TextStyle(
                              color: Color.fromARGB(255, 58, 139, 148),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Center(
                        //   child: Text(
                        //     "description",
                        //     style: TextStyle(
                        //       fontSize: 18,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              height: 50,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DirectionWidget(
                                              sLatitude: widget.sLatitude,
                                              sLongitude: widget.sLongitude,
                                              dLatitude: dLatitude,
                                              dLongitude: dLongitude,
                                            )),
                                  );
                                },
                                child: Text(
                                  '${AppLocalizations.of(context)?.translate('getD')}',
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
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              height: 50,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () => ratingBox(context, doctorDoc),
                                child: Text(
                                  '${AppLocalizations.of(context)?.translate('rate')}',
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
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              height: 50,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                            recieverId: widget.doctorId,
                                            recieverName: name)),
                                  );
                                },
                                child: Text(
                                  '${AppLocalizations.of(context)?.translate('sendmsg')}',
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
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)?.translate('experience')}",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '+${experience.toString()} ${AppLocalizations.of(context)?.translate('years')}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${percentageRating.toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                  ),
                                ),
                                faceIcon(percentageRating),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: localeProvider.locale.languageCode == 'ar'
                              ? EdgeInsets.only(right: 8)
                              : EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 30,
                                color: Color.fromARGB(255, 58, 139, 148),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  email,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: localeProvider.locale.languageCode == 'ar'
                              ? EdgeInsets.only(right: 8)
                              : EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.phone,
                                size: 30,
                                color: Color.fromARGB(255, 58, 139, 148),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  '0${phoneNumber.toString()}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  hName,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              widget.sLatitude == 0 && widget.sLongitude == 0
                                  ? Text("")
                                  : widget.distance != double.infinity
                                      ? RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${widget.distance.toString()}${AppLocalizations.of(context)?.translate('km')} ',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 58, 139, 148)),
                                              ),
                                              TextSpan(
                                                  text:
                                                      '${AppLocalizations.of(context)?.translate('away')}'),
                                            ],
                                          ),
                                        )
                                      : Text(
                                          '${AppLocalizations.of(context)?.translate('dnotfound')}',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 58, 139, 148),
                                            fontSize: 16,
                                          ),
                                        ),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingScreen(
                                          doctorId: widget.doctorId),
                                    ));
                              },
                              child: Text(
                                '${AppLocalizations.of(context)?.translate('book')}',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
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
                          height: 40,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  QueryDocumentSnapshot<Map<String, dynamic>>? _findDoctor(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, String doctorId) {
    for (var doc in docs) {
      if (doc.id == doctorId) {
        return doc;
      }
    }
    return null;
  }

  int ratingToPercentage(int rating) {
    return ((rating / 5) * 100).round();
  }

  Widget faceIcon(int percentage) {
    if (percentage == 0) {
      return Text("");
    } else if (percentage >= 80) {
      return Icon(
        Icons.sentiment_very_satisfied,
        color: Colors.green,
        size: 35,
      );
    } else if (percentage >= 50) {
      return Icon(
        Icons.sentiment_satisfied,
        color: Colors.yellow,
        size: 35,
      );
    } else {
      return Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
        size: 35,
      );
    }
  }

  Future<void> updateRating(int rating, var doctorDoc) async {
    DocumentReference doctorRef = doctorDoc.reference;
    bool numberOfRatingsExists =
        doctorDoc.data().containsKey('numberOfRatings');
    int numberOfRatings =
        numberOfRatingsExists ? doctorDoc['numberOfRatings'] : 0;
    int Rating = doctorDoc['Rating'];

    int newNumberOfRatings = numberOfRatings + 1;
    int newRating =
        ((Rating * numberOfRatings + rating) / newNumberOfRatings).round();

    await doctorRef.update({
      'Rating': newRating,
      'numberOfRatings': newNumberOfRatings,
    });
  }
}
