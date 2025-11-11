import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GeolocatorPage(),
    );
  }
}

class GeolocatorPage extends StatefulWidget {
  const GeolocatorPage({super.key});

  @override
  State<GeolocatorPage> createState() => _GeolocatorPageState();
}

class _GeolocatorPageState extends State<GeolocatorPage> {
  Position? position;
  String? address;
  String? distance;
  Stream<Position>? stream;

  static const double pnbLat = -6.2088;
  static const double pnbLng = 106.8456;

  Future<Position> _getLocation() async {
    bool service = await Geolocator.isLocationServiceEnabled();
    if (!service) throw 'GPS belum aktif';
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) throw 'Izin lokasi ditolak';
    }
    if (perm == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak permanen';
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddress(Position pos) async {
    List<Placemark> p = await placemarkFromCoordinates(
      pos.latitude,
      pos.longitude,
    );
    var place = p.first;
    setState(() {
      address = "${place.street}, ${place.locality}, ${place.country}";
    });
  }

  Future<void> getNow() async {
    try {
      var pos = await _getLocation();
      double jarak = Geolocator.distanceBetween(
        pnbLat,
        pnbLng,
        pos.latitude,
        pos.longitude,
      );
      setState(() {
        position = pos;
        distance = "${(jarak / 1000).toStringAsFixed(2)} km";
      });
      _getAddress(pos);
    } catch (e) {
      setState(() => address = "$e");
    }
  }

  void startTrack() {
    stream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
    stream!.listen((pos) {
      double jarak = Geolocator.distanceBetween(
        pnbLat,
        pnbLng,
        pos.latitude,
        pos.longitude,
      );
      setState(() {
        position = pos;
        distance = "${(jarak / 1000).toStringAsFixed(2)} km";
      });
      _getAddress(pos);
    });
  }

  void stopTrack() {
    stream = null;
    setState(() => address = "Pelacakan dihentikan.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Praktikum Geolocator (Dasar)"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 70, color: Colors.blue),
              const SizedBox(height: 10),
              if (position != null)
                Text(
                  "Lat: ${position!.latitude}\nLng: ${position!.longitude}",
                  textAlign: TextAlign.center,
                ),
              if (address != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(address!, textAlign: TextAlign.center),
                ),
              if (distance != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    "Jarak ke PNB: $distance",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: getNow,
                icon: const Icon(Icons.my_location, color: Colors.blue),
                label: const Text(
                  "Dapatkan Lokasi Sekarang",
                  style: TextStyle(color: Colors.blue),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.blue),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: startTrack,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Mulai Lacak"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton.icon(
                    onPressed: stopTrack,
                    icon: const Icon(Icons.stop),
                    label: const Text("Henti Lacak"),
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
    );
  }
}
