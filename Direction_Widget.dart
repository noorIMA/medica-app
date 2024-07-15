// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionWidget extends StatefulWidget {
  final double sLatitude;
  final double sLongitude;
  final double dLatitude;
  final double dLongitude;
  const DirectionWidget(
      {required this.sLatitude,
      required this.sLongitude,
      required this.dLatitude,
      required this.dLongitude});

  @override
  State<DirectionWidget> createState() => _DirectionWidgetState();
}

class _DirectionWidgetState extends State<DirectionWidget> {
  late LatLng _sourceLocation =
      LatLng(widget.sLatitude, widget.sLongitude);
  late LatLng _destinationLocation = LatLng(widget.dLatitude, widget.dLongitude);
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    getPolyline().then((coordinates) => {
          generatePolyLine(coordinates),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sourceLocation == null
          ? Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: _sourceLocation,
                zoom: 13,
              ),
              markers: {
                Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _sourceLocation),
                Marker(
                    markerId: MarkerId("_destinationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _destinationLocation),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  Future<List<LatLng>> getPolyline() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinepoints = PolylinePoints();
    PolylineResult result = await polylinepoints.getRouteBetweenCoordinates(
      "AIzaSyC3heZ71W5sKf-_zUL5KNs38lkFL9lanEY",
      PointLatLng(_sourceLocation.latitude, _sourceLocation.longitude),
      PointLatLng(
          _destinationLocation.latitude, _destinationLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLine(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: const Color.fromARGB(255, 235, 12, 12),
        points: polylineCoordinates,
        width: 4);

    setState(() {
      polylines[id] = polyline;
    });
  }
}
