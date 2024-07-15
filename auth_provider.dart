// ignore_for_file: prefer_final_fields, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/Screens/OTPScreen3.dart';
import 'package:medica_app/Screens/OTP_Screen.dart';
import 'package:medica_app/Screens/OTP_Screen2.dart';
import 'package:medica_app/Screens/OTP_Screen4.dart';
import 'package:medica_app/Utils/Utils.dart';
import 'package:medica_app/model/doctor_model.dart';
import 'package:medica_app/model/itAdmin_model.dart';
import 'package:medica_app/model/user_model.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _uid;
  String get uid => _uid!;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  String? _did;
  String get did => _did!;
  DoctorModel? _doctorModel;
  DoctorModel get doctorModel => _doctorModel!;
  String? _aid;
  String get aid => _aid!;
  AdminModel? _adminModel;
  AdminModel get adminModel => _adminModel!;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSign();
  }
  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

//sign in
  void signInWithPhoneNum(BuildContext context, String phoneNum) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNum,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            //after otp
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        OtpScreen(verificationId: verificationId))));
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void signInDWithPhoneNum(BuildContext context, String phoneNum) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNum,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            //after otp
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => OtpScreen3(
                        verificationId: verificationId,
                        phoneNumber: phoneNum))));
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void signInAWithPhoneNum(BuildContext context, String phoneNum) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNum,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            //after otp
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => OtpScreen4(
                        verificationId: verificationId,
                        phoneNumber: phoneNum))));
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  //signup
  void signUnWithPhoneNum(BuildContext context, String phoneNum) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNum,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            //after otp
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        OtpScreen2(verificationId: verificationId))));
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  // verify otp
  void verifyOtpCode({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void verifyOtpCodeD({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await _firebaseAuth.signInWithCredential(creds);
      onSuccess();
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  //DataBase
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapShot =
        await _firebaseFireStore.collection("users").doc(_uid).get();
    if (snapShot.exists) {
      print("USER EXISTS");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  void editUserDataToFirebase(
      {required BuildContext context,
      required UserModel userModel,
      File? profilePic,
      required String eProfilePicUrl,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (profilePic != null) {
        String profilePicUrl =
            await saveFileToStorage("profilePic/$_uid", profilePic);
        userModel.profilePic = profilePicUrl;
      } else {
        userModel.profilePic = eProfilePicUrl;
      }

      userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
      userModel.uid = _firebaseAuth.currentUser!.uid;

      _userModel = userModel;
      //uploading to database
      await _firebaseFireStore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void editDoctorDataToFirebase(
      {required BuildContext context,
      required DoctorModel doctorModel,
      File? profilePic,
      required String eProfilePicUrl,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (profilePic != null) {
        String profilePicUrl = "";
        if (doctorModel.gender == "Male") {
          profilePicUrl =
              await saveFileToStorage("Male doctors/$_did", profilePic);
        } else if (doctorModel.gender == "Female") {
          profilePicUrl =
              await saveFileToStorage("Female doctors/$_did", profilePic);
        }

        doctorModel.photoUrl = profilePicUrl;
      } else {
        doctorModel.photoUrl = eProfilePicUrl;
      }
      _doctorModel = doctorModel;
      final localeProvider =
          Provider.of<LocaleProvider>(context, listen: false);
      final locale = localeProvider.localeString;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Hospitals')
          .where('Name_$locale', isEqualTo: doctorModel.hospital)
          .limit(1)
          .get();

      String hId = querySnapshot.docs.first.id;
      QuerySnapshot Snapshot = await FirebaseFirestore.instance
          .collection('Hospitals')
          .doc(hId)
          .collection('Specializations')
          .where('Name_$locale', isEqualTo: doctorModel.specialization)
          .limit(1)
          .get();
      String sId = Snapshot.docs.first.id;

      await _firebaseFireStore
          .collection('Hospitals')
          .doc(hId)
          .collection('Specializations')
          .doc(sId)
          .collection('Doctors')
          .doc(_did)
          .update({
        'Name_en': doctorModel.name_en,
        'Name_ar': doctorModel.name_ar,
        'Email': doctorModel.email,
        'Mobile Number': doctorModel.phoneNumber,
        'Experience': doctorModel.experience,
        'Description': doctorModel.description,
        'Gender': doctorModel.gender,
        'Picture': doctorModel.photoUrl,
      }).then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  void saveUserDataToFirebase(
      {required BuildContext context,
      required UserModel userModel,
      File? profilePic,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (profilePic != null) {
        String profilePicUrl =
            await saveFileToStorage("profilePic/$_uid", profilePic);
        userModel.profilePic = profilePicUrl;
      }
      userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
      userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
      userModel.uid = _firebaseAuth.currentUser!.uid;

      _userModel = userModel;
      //uploading to database
      await _firebaseFireStore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> saveFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future getUserDataFromFireStore() async {
    await _firebaseFireStore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
          firstName: snapshot['firstName'],
          lastName: snapshot['lastName'],
          email: snapshot['email'],
          profilePic: snapshot['profilePic'],
          gender: snapshot['gender'],
          dateOfBirth: snapshot['dateOfBirth'],
          createdAt: snapshot['createdAt'],
          phoneNumber: snapshot['phoneNumber'],
          uid: snapshot['uid']);
      _uid = userModel.uid;
    });
  }

  Future getDoctorDataFromFireStore(
      QueryDocumentSnapshot<Map<String, dynamic>> doctorDoc,
      BuildContext context) async {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.localeString;
    var doctorData = doctorDoc.data() as Map<String, dynamic>;
    _doctorModel = DoctorModel(
      name_en: doctorData['Name_en'],
      name_ar: doctorData['Name_ar'],
      phoneNumber: doctorData['Mobile Number'],
      Latitude: doctorData['Latitude'],
      Longitude: doctorData['Longitude'],
      rating: doctorData['Rating'],
      experience: doctorData['Experience'],
      gender: doctorData['Gender'],
      description: doctorData['Description'],
      email: doctorData['Email'],
      photoUrl: doctorData['Picture'],
      specialization: doctorData['sName_$locale'],
      hospital: doctorData['hName_$locale'],
      did: doctorDoc.id,
    );
    _did = doctorModel.did;
  }

  Future getAdminDataFromFireStore(
      QueryDocumentSnapshot adminDoc, BuildContext context) async {
    var adminData = adminDoc.data() as Map<String, dynamic>;
    _adminModel = AdminModel(
      name: adminData['name'],
      phoneNumber: adminData['phone'],
      aid: adminDoc.id,
    );
    _aid = adminModel.aid;
  }

  //shared prefrence
  Future saveDateToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    Map<String, dynamic> userModelMap = userModel.toMap();
    userModelMap['type'] = 'user';
    await s.setString('user_model', jsonEncode(userModelMap));
  }

  Future saveDoctorDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    Map<String, dynamic> doctorModelMap = doctorModel.toMap();
    doctorModelMap['type'] = 'doctor';
    await s.setString('user_model', jsonEncode(doctorModelMap));
  }

  Future saveAdminDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    Map<String, dynamic> adminModelMap = adminModel.toMap();
    adminModelMap['type'] = 'admin';
    await s.setString('user_model', jsonEncode(adminModelMap));
  }

  Future getDateFroSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';

    if (data.isNotEmpty) {
      Map<String, dynamic> map = jsonDecode(data);

      if (map.containsKey('type')) {
        String type = map['type'];

        if (type == 'user') {
          _userModel = UserModel.fromMap(map);
          _uid = _userModel!.uid;
        } else if (type == 'doctor') {
          _doctorModel = DoctorModel.fromMap(map);
          _did = _doctorModel!.did;
        } else if (type == 'admin') {
          _adminModel = AdminModel.fromMap(map);
          _aid = _adminModel!.aid;
        }
      }
    }

    notifyListeners();
  }

  bool get isUser => _userModel != null;
  bool get isDoctor => _doctorModel != null;
  bool get isAdmin => _adminModel != null;

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    s.clear();
    notifyListeners();
  }
}
