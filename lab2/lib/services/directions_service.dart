import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class DirectionsService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

  // Replace with your API Key
  static const String _apiKey = 'AIzaSyCAbEx0FEGZ_Dm9sX6jibDQCLpKd6Of-gY';

  Future<List<LatLng>> getRoute(LatLng origin, LatLng destination) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Extracting the polyline from the response
      final steps = data['routes'][0]['legs'][0]['steps'];
      List<LatLng> route = [];

      for (var step in steps) {
        final lat = step['end_location']['lat'];
        final lng = step['end_location']['lng'];
        route.add(LatLng(lat, lng));
      }
      return route;
    } else {
      throw Exception('Failed to load directions');
    }
  }
}
