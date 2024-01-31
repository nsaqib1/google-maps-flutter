import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_project/utils/location_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GoogleMapController _mapController;
  late final StreamSubscription _streamSubscription;
  final LatLng _initialPosition = const LatLng(23.7808186, 90.3372882);
  final List<LatLng> _points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real-Time Location Tracker"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 8,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          _listenAndUpdateLocationOnMap();
        },
        markers: {
          Marker(
            markerId: const MarkerId("marker"),
            infoWindow: _points.isNotEmpty
                ? InfoWindow(
                    title: "My current location",
                    snippet: "${_points.last.latitude}, ${_points.last.longitude}",
                  )
                : const InfoWindow(),
            position: _points.isEmpty ? _initialPosition : _points.last,
            visible: _points.isEmpty ? false : true,
          ),
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId("polyline"),
            points: _points,
            color: Colors.blue,
          ),
        },
        compassEnabled: true,
      ),
    );
  }

  Future<void> _listenAndUpdateLocationOnMap() async {
    // Getting Permission
    try {
      await LocationServices.getPermission();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red.shade900,
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
      return;
    }

    LocationServices.getCurrentLocationStream().listen((event) {
      _points.add(LatLng(event.latitude, event.longitude));

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.latitude, event.longitude),
            zoom: 17,
          ),
        ),
      );

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }
}
