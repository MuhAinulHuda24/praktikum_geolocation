import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // untuk ubah koordinat jadi alamat

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Geolocator (Dasar)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _currentPosition;
  String? _errorMessage;
  StreamSubscription<Position>? _positionStream;

  String? _currentAddress; // alamat dari koordinat
  String? _distanceToPNB;  // jarak ke titik tetap

  // Titik tetap (contohnya lokasi kampus PNB)
  final double _pnbLatitude = -8.7996;
  final double _pnbLongitude = 115.1767;

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  // Fungsi izin + ambil lokasi awal
  Future<Position> _getPermissionAndLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi tidak aktif. Harap aktifkan GPS.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Izin lokasi ditolak permanen. Harap ubah di pengaturan aplikasi.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  //  Ubah koordinat ke alamat (pakai geocoding)
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        _currentAddress = "Gagal mendapatkan alamat: $e";
      });
    }
  }

  //  Ambil lokasi sekali (tombol "Dapatkan Lokasi Sekarang")
  void _handleGetLocation() async {
    try {
      Position position = await _getPermissionAndLocation();
      setState(() {
        _currentPosition = position;
        _errorMessage = null;
      });

      // tampilkan alamat
      await _getAddressFromLatLng(position);

      // hitung jarak ke PNB
      double distanceInMeters = Geolocator.distanceBetween(
        _pnbLatitude,
        _pnbLongitude,
        position.latitude,
        position.longitude,
      );
      setState(() {
        _distanceToPNB =
            "Jarak dari PNB: ${distanceInMeters.toStringAsFixed(2)} m";
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  //  Lacak posisi terus-menerus
  void _handleStartTracking() {
    _positionStream?.cancel();

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, //  update posisi setiap berpindah ≥10 meter
    );

    try {
      _positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        double distanceInMeters = Geolocator.distanceBetween(
          _pnbLatitude,
          _pnbLongitude,
          position.latitude,
          position.longitude,
        );

        setState(() {
          _currentPosition = position;
          _distanceToPNB =
              "Jarak dari PNB: ${distanceInMeters.toStringAsFixed(2)} m";
          _errorMessage = null;
        });

        _getAddressFromLatLng(position); // update alamat tiap bergerak
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _handleStopTracking() {
    _positionStream?.cancel();
    setState(() {
      _errorMessage = "Pelacakan dihentikan.";
    });
  }

  //  UI (tampilan utama)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Praktikum Geolocator (Dasar)")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 50, color: Colors.blue),
                SizedBox(height: 16),

                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 16),

                      if (_currentPosition != null) ...[
                        Text(
                          "Lat: ${_currentPosition!.latitude}\nLng: ${_currentPosition!.longitude}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_currentAddress != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Alamat: $_currentAddress",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        if (_distanceToPNB != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _distanceToPNB!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.deepPurple),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 32),

                ElevatedButton.icon(
                  icon: Icon(Icons.location_searching),
                  label: Text('Dapatkan Lokasi Sekarang'),
                  onPressed: _handleGetLocation,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.play_arrow),
                      label: Text('Mulai Lacak'),
                      onPressed: _handleStartTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.stop),
                      label: Text('Henti Lacak'),
                      onPressed: _handleStopTracking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
