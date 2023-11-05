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
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Ganti latar belakang putih
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_currentPosition != null)
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(
                            0xFFEDFAFD), // Gunakan warna heksadesimal #EDFAFD
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Lokasi Anda saat ini",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black, // Ganti warna teks menjadi hitam
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Latitude: ${_currentPosition?.latitude}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors
                                  .black, // Ganti warna teks menjadi hitam
                            ),
                          ),
                          Text(
                            "Longitude: ${_currentPosition?.longitude}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors
                                  .black, // Ganti warna teks menjadi hitam
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
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
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue, // Ganti warna tombol
                        onPrimary: Colors.white, // Ganti warna teks tombol
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.map),
                          SizedBox(width: 10),
                          Text('Buka Google Maps'),
                        ],
                      ),
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
