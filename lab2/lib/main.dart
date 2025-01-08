import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'services/event_service.dart';
import 'screens/event_list_screen.dart';

void main() async {
  // Ensure dotenv is loaded before running the app
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventService(),
      child: MaterialApp(
        title: 'Event Scheduler',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: EventListScreen(),
      ),
    );
  }
}
