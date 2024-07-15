// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:medica_app/widgets/Doctors_tab.dart';
import 'package:medica_app/widgets/Hospital_List.dart';
import 'package:medica_app/widgets/Specialization_tab.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  const SearchScreen({required this.latitude, required this.longitude});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchText = '';
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 58, 139, 148),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.back,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text(
                                        "${AppLocalizations.of(context)?.translate('back')}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Container(
                            width: double.infinity,
                            height: 60,
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
                                      child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            _searchText = value;
                                          });
                                        },
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
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      widget.latitude == 0 && widget.longitude == 0
                          ? '${AppLocalizations.of(context)?.translate('specialization')}'
                          : '${AppLocalizations.of(context)?.translate('specializations')}',
                      textAlign: localeProvider.locale.languageCode == 'ar'
                          ? TextAlign.right
                          : TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SpecializationTab(
                    searchText: _searchText,
                    sLatitude: widget.latitude,
                    sLongitude: widget.longitude,
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      widget.latitude == 0 && widget.longitude == 0
                          ? '${AppLocalizations.of(context)?.translate('hospital')}'
                          : '${AppLocalizations.of(context)?.translate('hospitals')}',
                      textAlign: localeProvider.locale.languageCode == 'ar'
                          ? TextAlign.right
                          : TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: HospitalList(
                      searchText: _searchText,
                      sLatitude: widget.latitude,
                      sLongitude: widget.longitude,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      widget.latitude == 0 && widget.longitude == 0
                          ? '${AppLocalizations.of(context)?.translate('doctor')}'
                          : '${AppLocalizations.of(context)?.translate('doctors')}',
                      textAlign: localeProvider.locale.languageCode == 'ar'
                          ? TextAlign.right
                          : TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DoctorTab(
                        searchText: _searchText,
                        sLatitude: widget.latitude,
                        sLongitude: widget.longitude),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
