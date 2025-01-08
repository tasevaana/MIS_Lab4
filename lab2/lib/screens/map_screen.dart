import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class MapScreen extends StatefulWidget {
  final Event event;

  const MapScreen({Key? key, required this.event}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  LatLng? _currentLocation;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  final String _googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? ''; // Replace with your API key

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    _initializeMarkers();
    if (_currentLocation != null) {
      await _fetchRoute();
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Location permissions are permanently denied, we cannot request permissions.");
    }

    // Get current location
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: InfoWindow(title: 'Your Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  // Initialize event marker
  void _initializeMarkers() {
    final eventLocation =
    LatLng(widget.event.latitude, widget.event.longitude);

    _markers.add(
      Marker(
        markerId: MarkerId('event_location'),
        position: eventLocation,
        infoWindow: InfoWindow(
          title: widget.event.title,
          snippet: widget.event.location,
        ),
      ),
    );
  }

  // Fetch route using Google Directions API
  Future<void> _fetchRoute() async {
    if (_currentLocation == null) return;

    final origin = _currentLocation!;
    final destination = LatLng(widget.event.latitude, widget.event.longitude);

    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_googleMapsApiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final route = data['routes'][0]['legs'][0];
        final steps = route['steps'];

        List<LatLng> polylineCoordinates = [];
        for (var step in steps) {
          final startLat = step['end_location']['lat'];
          final startLng = step['end_location']['lng'];
          polylineCoordinates.add(LatLng(startLat, startLng));
        }

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: polylineCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });

        // Move camera to include both the current location and the event location
        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            route['start_location']['lat'],
            route['start_location']['lng'],
          ),
          northeast: LatLng(
            route['end_location']['lat'],
            route['end_location']['lng'],
          ),
        );

        _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    } else {
      print('Error fetching route');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event.title)),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 14,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
