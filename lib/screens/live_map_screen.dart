import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  static const Color bg = Color(0xFF050607);
  static const Color panel = Color(0xFF101418);
  static const Color panel2 = Color(0xFF151A1F);
  static const Color border = Color(0xFF1F252B);
  static const Color textPrimary = Color(0xFFF3F5F6);
  static const Color green = Color(0xFF2ED15F);
  static const Color blue = Color(0xFF2F7BFF);
  static const Color victimRed = Color(0xFFDC2F2F);

  static const LatLng _mapCenter = LatLng(24.8607, 67.0100);

  static const LatLng _robotPosition = LatLng(24.8608, 67.0092);
  static const LatLng _victimPosition = LatLng(24.8621, 67.0120);
  static const LatLng _teamPosition = LatLng(24.8589, 67.0111);
  static const LatLng _basePosition = LatLng(24.8578, 67.0082);

  GoogleMapController? _mapController;
  MapType _mapType = MapType.satellite;

  Set<Marker> get _markers => <Marker>{
    Marker(
      markerId: const MarkerId('robot'),
      position: _robotPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'Robot 1', snippet: 'Moving'),
    ),
    Marker(
      markerId: const MarkerId('victim'),
      position: _victimPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Victim', snippet: 'Detected'),
    ),
    Marker(
      markerId: const MarkerId('team'),
      position: _teamPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'Team', snippet: 'On site'),
    ),
    Marker(
      markerId: const MarkerId('base'),
      position: _basePosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: const InfoWindow(title: 'Base', snippet: 'Command center'),
    ),
  };

  Set<Polyline> get _polylines => <Polyline>{
    Polyline(
      polylineId: const PolylineId('route'),
      points: const [
        LatLng(24.8578, 67.0082),
        LatLng(24.8585, 67.0090),
        LatLng(24.8596, 67.0097),
        LatLng(24.8608, 67.0092),
        LatLng(24.8614, 67.0108),
        LatLng(24.8621, 67.0120),
      ],
      color: const Color(0xFF58A6FF),
      width: 5,
      geodesic: true,
    ),
  };

  Set<Polygon> get _polygons => <Polygon>{
    Polygon(
      polygonId: const PolygonId('disaster_zone'),
      points: const [
        LatLng(24.8618, 67.0092),
        LatLng(24.8630, 67.0104),
        LatLng(24.8623, 67.0130),
        LatLng(24.8605, 67.0125),
        LatLng(24.8601, 67.0106),
      ],
      fillColor: victimRed.withOpacity(0.22),
      strokeColor: victimRed.withOpacity(0.65),
      strokeWidth: 2,
    ),
  };

  Future<void> _zoomIn() async {
    await _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _toggleMapType() async {
    setState(() {
      _mapType = _mapType == MapType.satellite
          ? MapType.normal
          : MapType.satellite;
    });
  }

  Future<void> _recenterMap() async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(target: _mapCenter, zoom: 15.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: bg,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Live Map',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 34,
                          minHeight: 34,
                        ),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14351F),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Live',
                          style: TextStyle(
                            color: green,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: panel,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border, width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GoogleMap(
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            initialCameraPosition: const CameraPosition(
                              target: _mapCenter,
                              zoom: 15.0,
                            ),
                            mapType: _mapType,
                            markers: _markers,
                            polylines: _polylines,
                            polygons: _polygons,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: false,
                            compassEnabled: false,
                            mapToolbarEnabled: false,
                            trafficEnabled: false,
                            buildingsEnabled: true,
                            tiltGesturesEnabled: false,
                            rotateGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomGesturesEnabled: true,
                          ),
                          Container(color: Colors.black.withOpacity(0.12)),
                          Positioned(
                            left: 16,
                            top: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.56),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              child: const Text(
                                'Disaster Zone',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Column(
                              children: [
                                _MapIconButton(
                                  icon: Icons.layers_rounded,
                                  onTap: _toggleMapType,
                                ),
                                const SizedBox(height: 10),
                                _MapIconButton(
                                  icon: Icons.my_location_rounded,
                                  onTap: _recenterMap,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 14,
                            bottom: 92,
                            child: Container(
                              width: 104,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.58),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _LegendItem(
                                    color: blue,
                                    label: 'Robot',
                                    icon: Icons.smart_toy_rounded,
                                  ),
                                  SizedBox(height: 12),
                                  _LegendItem(
                                    color: victimRed,
                                    label: 'Victim',
                                    icon: Icons.location_on_rounded,
                                  ),
                                  SizedBox(height: 12),
                                  _LegendItem(
                                    color: green,
                                    label: 'Team',
                                    icon: Icons.person_rounded,
                                  ),
                                  SizedBox(height: 12),
                                  _LegendItem(
                                    color: Colors.white,
                                    label: 'Base',
                                    icon: Icons.home_rounded,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 14,
                            bottom: 14,
                            child: GestureDetector(
                              onTap: _zoomIn,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF101418),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.08),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: border, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: panel2,
                              shape: BoxShape.circle,
                              border: Border.all(color: border, width: 1),
                            ),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Robot 1',
                                style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.0,
                                  letterSpacing: -0.15,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Moving',
                                style: TextStyle(
                                  color: green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white.withOpacity(0.72),
                            size: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Row(
                        children: [
                          Expanded(
                            child: _MetricItem(
                              title: 'Speed',
                              value: '2.4 m/s',
                            ),
                          ),
                          Expanded(
                            child: _MetricItem(title: 'Battery', value: '78%'),
                          ),
                          Expanded(
                            child: _MetricItem(
                              title: 'Distance',
                              value: '1.2 km',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.56),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final IconData icon;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          child: Icon(
            icon,
            size: 14,
            color: color == Colors.white ? Colors.black : Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String title;
  final String value;

  const _MetricItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF8A9298),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
