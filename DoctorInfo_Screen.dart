import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/Welcome_Screen2.dart';
import 'package:medica_app/Utils/Utils.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class DoctorInfoScreen extends StatefulWidget {
  const DoctorInfoScreen({super.key});

  @override
  State<DoctorInfoScreen> createState() => _DoctorInfoScreenState();
}

class _DoctorInfoScreenState extends State<DoctorInfoScreen> {
  File? image;
  final NameENController = TextEditingController();
  final NameARController = TextEditingController();
  final emailController = TextEditingController();
  final experienceController = TextEditingController();
  final descriptionController = TextEditingController();
  final genderController = TextEditingController(text: "Male");
  final List<String> _genders = ["Male", "Female"];
  String _selectedgender = "Male";
  final phoneController = TextEditingController();
  List<String> hospitals = [];
  List<String> specializations = [];
  String? selectedS;
  String? selectedH;

  @override
  void initState() {
    super.initState();
    getHospitals();
  }

  Future<void> getHospitals() async {
    try {
      final localeProvider =
          Provider.of<LocaleProvider>(context, listen: false);
      final locale = localeProvider.localeString;
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Hospitals').get();
      List<String> names = querySnapshot.docs
          .map((doc) => doc['Name_$locale'] as String)
          .toList();
      setState(() {
        hospitals = names;
      });
    } catch (e) {
      print('Error fetching names: $e');
    }
  }

  Future<void> getSpecializations(String hName) async {
    try {
      final localeProvider =
          Provider.of<LocaleProvider>(context, listen: false);
      final locale = localeProvider.localeString;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Hospitals')
          .where('Name_$locale', isEqualTo: hName)
          .limit(1)
          .get();

      String hId = querySnapshot.docs.first.id;
      QuerySnapshot Snapshot = await FirebaseFirestore.instance
          .collection('Hospitals')
          .doc(hId)
          .collection('Specializations')
          .get();

      List<String> sList =
          Snapshot.docs.map((doc) => doc['Name_$locale'] as String).toList();

      setState(() {
        specializations = sList;
      });
    } catch (e) {
      print('Error fetching hospitals: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    NameENController.dispose();
    NameARController.dispose();
    emailController.dispose();
    genderController.dispose();
    descriptionController.dispose();
    experienceController.dispose();
    phoneController.dispose();
  }

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
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
          ),
        ),
        child: SafeArea(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 58, 139, 148),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
                  child: Center(
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Welcome2())),
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
                          height: 20,
                        ),
                        Text(
                          "${AppLocalizations.of(context)?.translate('createaccount')}",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 58, 139, 148),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () => selectImage(),
                          child: image == null
                              ? CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 58, 139, 148),
                                  radius: 50,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${AppLocalizations.of(context)?.translate('choosephoto1')}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          margin: EdgeInsets.only(top: 30),
                          child: Column(children: [
                            textField(
                                hintText:
                                    "${AppLocalizations.of(context)?.translate('dnamee')}",
                                icon: Icons.account_circle,
                                inputType: TextInputType.name,
                                maxLines: 1,
                                controller: NameENController),
                            textField(
                                hintText:
                                    "${AppLocalizations.of(context)?.translate('dnamea')}",
                                icon: Icons.account_circle,
                                inputType: TextInputType.name,
                                maxLines: 1,
                                controller: NameARController),
                            textField(
                                hintText:
                                    "${AppLocalizations.of(context)?.translate('email')}",
                                icon: Icons.email,
                                inputType: TextInputType.emailAddress,
                                maxLines: 1,
                                controller: emailController),
                            textField1(
                                hintText:
                                    "${AppLocalizations.of(context)?.translate('phone')}",
                                icon: Icons.phone,
                                prefix: ' +  ',
                                inputType: TextInputType.phone,
                                maxLines: 1,
                                controller: phoneController),
                            textField(
                                hintText:
                                    "${AppLocalizations.of(context)?.translate('experience')}",
                                icon: Icons.edit,
                                inputType: TextInputType.number,
                                maxLines: 1,
                                controller: experienceController),
                            textField(
                                hintText:
                                    "${AppLocalizations.of(context)?.translate('description')}",
                                icon: Icons.edit,
                                inputType: TextInputType.name,
                                maxLines: 2,
                                controller: descriptionController),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 300,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 58, 139, 148)),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(
                                          "${AppLocalizations.of(context)?.translate('selecth')}"),
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      underline: Container(
                                        height: 0,
                                        color: Colors.transparent,
                                      ),
                                      value: selectedH,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedH = newValue!;
                                          specializations.clear();
                                          selectedS = null;
                                          getSpecializations(newValue);
                                        });
                                      },
                                      items: hospitals
                                          .map<DropdownMenuItem<String>>(
                                              (String name) {
                                        return DropdownMenuItem<String>(
                                          value: name,
                                          child: Text(name),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width: 300,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 58, 139, 148)),
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(
                                          "${AppLocalizations.of(context)?.translate('selects')}"),
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      underline: Container(
                                        height: 0,
                                        color: Colors.transparent,
                                      ),
                                      value: selectedS,
                                      onChanged: specializations.isEmpty
                                          ? null
                                          : (String? newValue) {
                                              setState(() {
                                                selectedS = newValue;
                                              });
                                            },
                                      items: specializations
                                          .map<DropdownMenuItem<String>>(
                                              (String specialization) {
                                        return DropdownMenuItem<String>(
                                          value: specialization,
                                          child: Text(specialization),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gender(),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: ElevatedButton(
                            onPressed: () => storeData(),
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
                              backgroundColor:
                                  Color.fromARGB(255, 58, 139, 148),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget textField({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required TextEditingController controller,
    required int maxLines,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        cursorColor: Color.fromARGB(255, 58, 139, 148),
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 253, 247, 247),
          prefixIcon: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 58, 139, 148),
              ),
              child: Icon(icon, size: 20, color: Colors.white)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 58, 139, 148),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget textField1({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required TextEditingController controller,
    required String prefix,
    required int maxLines,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        cursorColor: Color.fromARGB(255, 58, 139, 148),
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 253, 247, 247),
          prefixText: prefix,
          prefixStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          prefixIcon: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 58, 139, 148),
              ),
              child: Icon(icon, size: 20, color: Colors.white)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 58, 139, 148),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Row Gender() {
    return Row(
      children: [
        Text(
          '${AppLocalizations.of(context)?.translate('gender')}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        for (int i = 0; i < _genders.length; i++)
          Row(
            children: [
              Radio(
                value: _genders[i],
                groupValue: _selectedgender,
                onChanged: (value) {
                  setState(() {
                    _selectedgender = value.toString();
                    genderController.text = _selectedgender;
                  });
                },
                activeColor: Color.fromARGB(255, 58, 139, 148),
              ),
              Text(
                "${AppLocalizations.of(context)?.translate(_genders[i])}",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(right: 50.0, top: 50, bottom: 30),
        ),
      ],
    );
  }

  //store the data
  void storeData() async {
    if (image == null) {
      showSnackBar(
          context, "${AppLocalizations.of(context)?.translate('imageerr')}");
    } else if (NameARController.text == "" ||
        NameENController.text == "" ||
        experienceController.text == "" ||
        phoneController.text == "" ||
        emailController.text == "") {
      showSnackBar(
          context, "${AppLocalizations.of(context)?.translate('fielderr')}");
    } else if (selectedH == null || selectedS == null) {
      showSnackBar(
          context, "${AppLocalizations.of(context)?.translate('selecterr')}");
    } else {
      String profilePicUrl = "";
      String hospital_en = "",
          hospital_ar = "",
          specialization_en = "",
          specialization_ar = "";
      double Latitude = 0.0, Longitude = 0.0;
      final localeProvider =
          Provider.of<LocaleProvider>(context, listen: false);
      final locale = localeProvider.localeString;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Hospitals')
          .where('Name_$locale', isEqualTo: selectedH)
          .limit(1)
          .get();
      String hId = querySnapshot.docs.first.id;
      QuerySnapshot Snapshot = await FirebaseFirestore.instance
          .collection('Hospitals')
          .doc(hId)
          .collection('Specializations')
          .where('Name_$locale', isEqualTo: selectedS)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        Latitude = data['Latitude'];
        Longitude = data['Longitude'];
        if (Snapshot.docs.isNotEmpty) {
          DocumentSnapshot document1Snapshot = Snapshot.docs.first;
          Map<String, dynamic> data1 =
              document1Snapshot.data() as Map<String, dynamic>;
          if (locale == "en") {
            hospital_en = selectedH!;
            specialization_en = selectedS!;
            specialization_ar = data1['Name_ar'];
            hospital_ar = data['Name_ar'];
          } else if (locale == "ar") {
            hospital_ar = selectedH!;
            specialization_ar = selectedS!;
            specialization_en = data1['Name_en'];
            hospital_en = data['Name_en'];
          }
        }
      }
      if (genderController.text.trim() == "Male") {
        profilePicUrl = await saveFileToStorage(
            "Male doctors/${NameENController.text.trim()}", image!);
      } else if (genderController.text.trim() == "Female") {
        profilePicUrl = await saveFileToStorage(
            "Female doctors/${NameENController.text.trim()}", image!);
      }

      CollectionReference doctors =
          FirebaseFirestore.instance.collection('doctors_pending');
      return doctors
          .add({
            'name_en': NameENController.text.trim(),
            'name_ar': NameARController.text.trim(),
            'email': emailController.text.trim(),
            'phone': int.tryParse(phoneController.text.trim()) ?? 0,
            'experience': int.tryParse(experienceController.text.trim()) ?? 0,
            'description': descriptionController.text.trim(),
            'hName_en': hospital_en,
            'hName_ar': hospital_ar,
            'sName_en': specialization_en,
            'sName_ar': specialization_ar,
            'Latitude': Latitude,
            'Longitude': Longitude,
            'gender': genderController.text.trim(),
            'picture': profilePicUrl,
          })
          .then((value) {print("doctor Added");
           Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Welcome2()),
        // ignore: invalid_return_type_for_catch_error
        );}).catchError((error) => print("Failed to add doctor: $error"));
    }
  }

  Future<String> saveFileToStorage(String ref, File file) async {
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
