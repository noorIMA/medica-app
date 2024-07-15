// ignore_for_file: await_only_futures, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/DoctorHomeScreen.dart';
import 'package:medica_app/Utils/Utils.dart';
import 'package:medica_app/model/doctor_model.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class EditDoctorProfileScreen extends StatefulWidget {
  final DoctorModel doctor;

  EditDoctorProfileScreen({required this.doctor});

  @override
  _EditDoctorProfileScreenState createState() =>
      _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
  File? image;
  var NameENController = TextEditingController();
  var NameARController = TextEditingController();
  var emailController = TextEditingController();
  var experienceController = TextEditingController();
  var descriptionController = TextEditingController();
  var genderController = TextEditingController();
  var phoneController = TextEditingController();
  var hospitalController = TextEditingController();
  var specializationController = TextEditingController();

  final List<String> _genders = ["Male", "Female"];
  late String _selectedgender = widget.doctor.gender;

  @override
  void initState() {
    super.initState();
    NameENController = TextEditingController(text: widget.doctor.name_en);
    NameARController = TextEditingController(text: widget.doctor.name_ar);
    emailController = TextEditingController(text: widget.doctor.email);
    genderController = TextEditingController(text: widget.doctor.gender);
    experienceController =
        TextEditingController(text: widget.doctor.experience.toString());
    descriptionController =
        TextEditingController(text: widget.doctor.description);
    phoneController =
        TextEditingController(text: widget.doctor.phoneNumber.toString());
    hospitalController = TextEditingController(text: widget.doctor.hospital);
    specializationController =
        TextEditingController(text: widget.doctor.specialization);
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
        title: Text("${AppLocalizations.of(context)?.translate('editp')}"),
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      body: Container(
        height: double.maxFinite,
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
                        InkWell(
                          onTap: () => selectImage(),
                          child: image == null
                              ? widget.doctor.photoUrl == ""
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
                                      backgroundImage:
                                          NetworkImage(widget.doctor.photoUrl),
                                      radius: 50,
                                    )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                        ),
                        SizedBox(height: 20),
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
                            textField2(
                                hintText:
                                    "${AppLocalizations.of(context)?.translate('hos')}",
                                icon: Icons.edit,
                                inputType: TextInputType.name,
                                maxLines: 2,
                                controller: hospitalController),
                            textField2(
                                hintText:
                                    "${AppLocalizations.of(context)?.translate('spec')}",
                                icon: Icons.edit,
                                inputType: TextInputType.name,
                                maxLines: 2,
                                controller: specializationController),
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
                              '${AppLocalizations.of(context)?.translate('edit')}',
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
          labelText: hintText,
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
          labelText: hintText,
          prefixText: prefix,
          prefixStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
          alignLabelWithHint: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget textField2({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required TextEditingController controller,
    required int maxLines,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        enabled: false,
        cursorColor: Color.fromARGB(255, 58, 139, 148),
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: hintText,
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
    final ap = Provider.of<AuthProvider>(context, listen: false);
    DoctorModel doctorModel = DoctorModel(
        name_en: NameENController.text.trim(),
        name_ar: NameARController.text.trim(),
        phoneNumber: int.tryParse(phoneController.text.trim()) ?? 0,
        Latitude: widget.doctor.Latitude,
        Longitude: widget.doctor.Longitude,
        rating: widget.doctor.rating,
        experience:int.tryParse(experienceController.text.trim()) ?? 0 ,
        gender: genderController.text.trim(),
        description: descriptionController.text.trim(),
        email: emailController.text.trim(),
        photoUrl: "",
        specialization: widget.doctor.specialization,
        hospital: widget.doctor.hospital,
        did: widget.doctor.did);
        if (NameARController.text == "" ||
        NameENController.text == "" ||
        experienceController.text == "" ||
        phoneController.text == "" ||
        emailController.text == "") {
      showSnackBar(
          context, "${AppLocalizations.of(context)?.translate('fielderr')}");
    }else{
       ap.editDoctorDataToFirebase(
          context: context,
          doctorModel: doctorModel,
          profilePic: image,
          eProfilePicUrl: widget.doctor.photoUrl,
          onSuccess: () {
            //store the data locally
            ap.saveDoctorDataToSP().then((value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Doctorhomescreen()),
                (route) => false));
          });
    }
  }
}
