// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medica_app/Screens/EditProfile_Screen.dart';
import 'package:medica_app/Screens/Search_Screen.dart';
import 'package:medica_app/Screens/doctoruser_screen.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/provider/location_provider.dart';
import 'package:medica_app/widgets/AppBar_widget.dart';
import 'package:medica_app/widgets/Hospitals_Widget.dart';
import 'package:medica_app/widgets/PhotoWidget.dart';
import 'package:medica_app/widgets/Spec_Widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';

class HomeBodyScreen extends StatefulWidget {
  const HomeBodyScreen({super.key});

  @override
  State<HomeBodyScreen> createState() => _HomeBodyScreenState();
}

class _HomeBodyScreenState extends State<HomeBodyScreen> {
  bool _isLoading = false;

  Future<void> _getLocation() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      if (!mounted) return;
      locationProvider.updateLocation(0.0, 0.0);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        locationProvider.updateLocation(0.0, 0.0);
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      locationProvider.updateLocation(0.0, 0.0);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (!mounted) return;
    locationProvider.updateLocation(position.latitude, position.longitude);
    setState(() {
      _isLoading = false;
    });
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final localeProvider = Provider.of<LocaleProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 58, 139, 148),
                ),
                child: Column(
                  children: [
                    AppBarWidget(),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () {
                                  print(
                                      'Latitude: ${locationProvider.latitude}, Longitude: ${locationProvider.longitude}/ ${_isLoading}');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen(
                                              latitude:
                                                  locationProvider.latitude,
                                              longitude:
                                                  locationProvider.longitude,
                                            )),
                                  );
                                },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.search,
                                    color: Color.fromARGB(255, 58, 139, 148),
                                    size: 30,
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 290,
                                      height: 50,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: TextFormField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                "${AppLocalizations.of(context)?.translate('find')}"),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.location_on_sharp,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: _getLocation,
                        tooltip: 'Get Location',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 20,
                ),
                PhotoWidget(),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '${AppLocalizations.of(context)?.translate('specialization')}',
                    textAlign: localeProvider.locale.languageCode == 'ar'
                        ? TextAlign.right
                        : TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SpecializationWidget(sLatitude: locationProvider.latitude,sLongitude: locationProvider.longitude),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '${AppLocalizations.of(context)?.translate('phospitals')}',
                    textAlign: localeProvider.locale.languageCode == 'ar'
                        ? TextAlign.right
                        : TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                HospitalWidget(sLatitude: locationProvider.latitude,sLongitude: locationProvider.longitude),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName:
                  Text("${ap.userModel.firstName} ${ap.userModel.lastName}"),
              accountEmail: Text(ap.userModel.phoneNumber),
              currentAccountPicture: ap.userModel.profilePic == ""
                  ? CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 58, 139, 148),
                      child: Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(ap.userModel.profilePic),
                    ),
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 58, 139, 148)),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title:
                  Text('${AppLocalizations.of(context)?.translate('profile')}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditUserProfileScreen(
                            user: ap.userModel,
                          )),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            //   onTap: () => null,
            // ),
            ListTile(
              leading: Icon(Icons.share),
              title:
                  Text('${AppLocalizations.of(context)?.translate('share')}'),
              onTap: () => shareContent(context),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title:
                  Text('${AppLocalizations.of(context)?.translate('logout')}'),
              onTap: () {
                ap.userSignOut().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorUserScreen(),
                        ),
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
   void shareContent(BuildContext context) async {
  final box = context.findRenderObject() as RenderBox?;
  final text = '${AppLocalizations.of(context)?.translate('sharestmt')}';
  final image = 'lib/images/medica.jpg'; 

  final ByteData bytes = await rootBundle.load(image);
  final Uint8List list = bytes.buffer.asUint8List();

  final tempDir = Directory.systemTemp;
  final file = await File('${tempDir.path}/medica.jpg').create();
  await file.writeAsBytes(list);

  Share.shareXFiles(
    [XFile(file.path)],
    text: text,
    subject: 'Check this out!',
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}
}
