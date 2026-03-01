import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  LatLng? currentLocation;
  final MapController _mapController = MapController();
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 3,
          ),
        ).listen((Position position) {
          final newLocation = LatLng(position.latitude, position.longitude);

          setState(() {
            currentLocation = newLocation;
          });

          _mapController.move(newLocation, 18);
        });
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1D37),
      appBar: AppBar(
        title: const Text(
          'Live GPS Tracking', // or 'Live Camera'
          style: TextStyle(
            color: Colors.white, // Title text color
            fontWeight: FontWeight.bold, // Optional: bold
            fontSize: 20, // Optional: font size
          ),
        ),
        backgroundColor: const Color(0xFF0A1D37), // AppBar background
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white, // Back icon color
        ),
        centerTitle: true, // Optional: center the title
      ),

      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
              children: [
                /// Rounded Premium Map
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: currentLocation!,
                        initialZoom: 18,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                      ),
                      children: [
                        /// High Quality Tiles
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.pakrescue_ai',
                          maxZoom: 20,
                          tileProvider: NetworkTileProvider(),
                        ),

                        /// Glow Effect Circle
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: currentLocation!,
                              radius: 25,
                              color: Colors.blue.withOpacity(0.2),
                              borderStrokeWidth: 0,
                            ),
                          ],
                        ),

                        /// Sharp GPS Marker
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: currentLocation!,
                              width: 80,
                              height: 80,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.6),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.my_location,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// Floating Control Panel
                Positioned(
                  bottom: 25,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.flight_takeoff),
                            label: const Text('Start Flight'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(
                                context,
                              ); // This will go back to HomeDashboard
                            },
                            icon: const Icon(Icons.home),
                            label: const Text('Return'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
