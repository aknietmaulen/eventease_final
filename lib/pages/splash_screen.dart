import 'package:eventease_final/pages/onboarding1.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Onboarding1Screen()),
          );
        },
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Image(image: AssetImage('assets/images/top_right_shade.png')),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/images/logo_f.png'), height: 300,),
                  SizedBox(height: 7), 
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Image(image: AssetImage('assets/images/bottom_left_shade.png')),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image(image: AssetImage('assets/images/bottom_right_shade.png')),
            ),
          ],
        ),
      ),
    );
  }
}
