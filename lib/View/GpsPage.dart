import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GpsPage extends StatefulWidget {
  @override
  _GpsPageState createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  Position? _currentPosition;
  GoogleMapController? mapController;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Anda'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null) Text("Lokasi Anda saat ini:"),
            if (_currentPosition != null)
              Text("Latitude: ${_currentPosition?.latitude}"),
            if (_currentPosition != null)
              Text("Longitude: ${_currentPosition?.longitude}"),
            if (_currentPosition != null)
              Container(
                height: 300,
                width: 300,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    zoom: 15,
                  ),
                  markers: Set<Marker>.from([
                    Marker(
                      markerId: MarkerId('Your_Location'),
                      position: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                      infoWindow: InfoWindow(title: 'Your Location'),
                    ),
                  ]),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                _getCurrentLocation();
                if (_currentPosition != null) {
                  _openGoogleMaps(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  );
                }
              },
              child: Text('Buka Google Maps'),
            ),
          ],
        ),
      ),
    );
  }
}
