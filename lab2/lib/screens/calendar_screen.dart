// import 'package:flutter/material.dart';
// import 'add_event_screen.dart';
// import 'map_screen.dart';
// import '../services/event_service.dart';
//
// class CalendarScreen extends StatelessWidget {
//   final EventService eventService;
//
//   const CalendarScreen({Key? key, required this.eventService}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Student Calendar')),
//       body: ListView.builder(
//         itemCount: eventService.events.length,
//         itemBuilder: (context, index) {
//           final event = eventService.events[index];
//           return ListTile(
//             title: Text(event.title),
//             subtitle: Text(event.dateTime.toString()),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => MapScreen(event: event),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AddEventScreen(eventService: eventService),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
