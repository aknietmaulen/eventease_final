import 'package:eventease_final/pages/home/home_screen.dart';
import 'package:eventease_final/pages/login_screen.dart';
import 'package:eventease_final/pages/register_screen.dart';
import 'package:eventease_final/providers/venue_provider.dart';
import 'package:eventease_final/pages/all_venues.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized before running the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VenueProvider()),  // Provider for Venues
        // Add other providers here if needed
      ],
      child: MaterialApp(
        title: 'EventEase',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/', // Set initial route to VenuesPage
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),  // Start with VenuesPage
          // Add other routes here as needed
        },
      ),
    );
  }
}
