// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/DoctorHomeScreen.dart';
import 'package:medica_app/Utils/Utils.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen3 extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen3(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OtpScreen3> createState() => _OtpScreen3State();
}

class _OtpScreen3State extends State<OtpScreen3> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    print(widget.phoneNumber);
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 222, 238, 250),
            Colors.white,
          ],
        )),
        child: SingleChildScrollView(
          child: SafeArea(
            child: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 58, 139, 148),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 25, horizontal: 30),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.back,
                                      color: Color.fromARGB(255, 58, 139, 148),
                                      size: 40,
                                    ),
                                    Text(
                                      "${AppLocalizations.of(context)?.translate('back')}",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 20),
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            child: Image.asset('lib/images/icon2.png'),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "${AppLocalizations.of(context)?.translate('otpv')}",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 58, 139, 148),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "${AppLocalizations.of(context)?.translate('otp')}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Pinput(
                            length: 6,
                            showCursor: true,
                            defaultPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 253, 247, 247),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color.fromARGB(255, 58, 139, 148),
                                ),
                              ),
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onCompleted: (value) {
                              setState(() {
                                otpCode = value;
                              });
                            },
                          ),
                          SizedBox(height: 25),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (otpCode != null) {
                                  verifyOtpCode(context, otpCode!);
                                } else {
                                  showSnackBar(context,
                                      "${AppLocalizations.of(context)?.translate('otperr1')}");
                                }
                              },
                              child: Text(
                                '${AppLocalizations.of(context)?.translate('verify')}',
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
                                backgroundColor:
                                    Color.fromARGB(255, 58, 139, 148),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${AppLocalizations.of(context)?.translate('recievecode')}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "${AppLocalizations.of(context)?.translate('resendcode')}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 58, 139, 148)),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void verifyOtpCode(BuildContext context, String userOTP) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtpCodeD(
        context: context,
        verificationId: widget.verificationId,
        userOTP: userOTP,
        onSuccess: () {
          //to check if the user exsits in the database
          checkExistingUser().then((value) async {
            if (value != null) {
              print("hi");
              //user exists
              ap.getDoctorDataFromFireStore(value,context).then((value) => ap
                  .saveDoctorDataToSP()
                  .then((value) => ap.setSignIn().then((value) =>
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Doctorhomescreen()),
                          (route) => false))));
            } else {
              //new user
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => UserInfoScreen()),
              //     (route) => false);
              showSnackBar(context,
                  "${AppLocalizations.of(context)?.translate('doctornotexist')}");
            }
          });
        });
  }

  Future <QueryDocumentSnapshot<Map<String, dynamic>>?> checkExistingUser() async{
      var doctorSnapshot =
          await FirebaseFirestore.instance.collectionGroup('Doctors').get();

  var doctorDocs = doctorSnapshot.docs;
      for (var doc in doctorDocs) {
      if ("+${doc.data()['Mobile Number']}" == widget.phoneNumber) {
        return doc;
      }
    }
    return null;
  }
}
