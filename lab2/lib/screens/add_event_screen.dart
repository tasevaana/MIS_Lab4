import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../services/event_service.dart';
import '../models/event_model.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedDate; // Added field for date
  LatLng _selectedLocation = LatLng(41.9981, 21.4254); // Default to Skopje
  Set<Marker> _markers = {};

  void _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Event Location'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: _selectDate,
              child: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Selected Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation,
                  zoom: 14,
                ),
                markers: _markers,
                onTap: (LatLng latLng) {
                  setState(() {
                    _selectedLocation = latLng;
                    _markers = {
                      Marker(
                        markerId: MarkerId('selected_location'),
                        position: latLng,
                        infoWindow: InfoWindow(
                          title: 'Selected Location',
                          snippet: '${latLng.latitude}, ${latLng.longitude}',
                        ),
                      ),
                    };
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final location = _locationController.text;

                if (title.isNotEmpty &&
                    location.isNotEmpty &&
                    _selectedDate != null) {
                  final newEvent = Event(
                    title: title,
                    location: location,
                    latitude: _selectedLocation.latitude,
                    longitude: _selectedLocation.longitude,
                    date: _selectedDate!,
                  );

                  context.read<EventService>().addEvent(newEvent);

                  Navigator.pop(context);
                }
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
