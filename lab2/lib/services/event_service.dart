import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventService with ChangeNotifier {
  List<Event> _events = [
    Event(
      title: "Exam 1",
      location: "Room A-101",
      latitude: 41.9981,
      longitude: 21.4254,
      date: DateTime(2025, 1, 10), // Added date
    ),
    Event(
      title: "Exam 2",
      location: "Room B-202",
      latitude: 41.9985,
      longitude: 21.4260,
      date: DateTime(2025, 1, 15), // Added date
    ),
    Event(
      title: "Exam 3",
      location: "Room C-303",
      latitude: 41.9990,
      longitude: 21.4270,
      date: DateTime(2025, 1, 20), // Added date
    ),
  ];

  List<Event> get events {
    _events.sort((a, b) => a.date.compareTo(b.date)); // Sorting by date
    return _events;
  }

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }
}
