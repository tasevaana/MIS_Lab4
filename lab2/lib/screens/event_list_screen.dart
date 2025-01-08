import 'package:flutter/material.dart';
import 'package:lab2/models/event_model.dart';
import 'package:provider/provider.dart';
import '../services/event_service.dart';
import 'map_screen.dart';
import 'add_event_screen.dart';  // Import AddEventScreen

class EventListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventService>().events;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to the AddEventScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEventScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          // Format the event date
          String formattedDate = "${event.date.day}-${event.date.month}-${event.date.year} ${event.date.hour}:${event.date.minute}";

          return ListTile(
            title: Text(event.title),
            subtitle: Text('${event.location}\n$formattedDate'), // Displaying date as well
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Show confirmation dialog before deleting
                _showDeleteConfirmationDialog(context, event);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(event: event),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Function to show the confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to delete the event "${event.title}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog without deleting
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete the event and close the dialog
                context.read<EventService>().deleteEvent(event);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
