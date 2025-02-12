import 'package:eventease_final/pages/home/home_screen.dart';
import 'package:eventease_final/pages/login_screen.dart';
import 'package:eventease_final/pages/onboarding1.dart';
import 'package:eventease_final/pages/register_screen.dart';
import 'package:eventease_final/pages/splash_screen.dart';
import 'package:eventease_final/providers/auth_provider.dart';
import 'package:eventease_final/providers/review_provider.dart';
import 'package:eventease_final/providers/service_provider.dart';
import 'package:eventease_final/providers/venue_provider.dart';
import 'package:eventease_final/pages/all_venues.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized before running the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VenueProvider()), 
        ChangeNotifierProvider(create: (_) => ReviewProvider()), 
        ChangeNotifierProvider(create: (_) => ServiceProviderProvider()),  
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'EventEase',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [observer], // Add observer for Firebase Analytics
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/onboarding': (context) => Onboarding1Screen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
