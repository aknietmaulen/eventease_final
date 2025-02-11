import 'package:eventease_final/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  final List<Map<String, dynamic>> categories = [
    {"image": "assets/icons/heart.png", "title": "Wedding", "color": Colors.pink},
    {"image": "assets/icons/briefcase.png", "title": "Corporate event", "color": Colors.blue},
    {"image": "assets/icons/balloon.png", "title": "Birthday", "color": Colors.yellow},
    {"image": "assets/icons/photograph.png", "title": "Photoshoot", "color": Colors.orange},
    {"image": "assets/icons/formal.png", "title": "Conference", "color": Colors.red},
  ];

  Set<String> selectedCategories = {};

  @override
  void initState() {
    super.initState();
    selectedCategories = {}; // Reset selections every time the app runs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Placing image slightly above center
          Positioned(
            top: 230, // Adjusted position
            left: 15,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 200, // Increased height
                child: Image.asset(
                  'assets/images/background1.png',
                  fit: BoxFit.cover, // Ensures it scales properly
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF800080),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(42),
                  topRight: Radius.circular(42),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Choose Your Interests',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: categories.map((category) {
                        bool isSelected = selectedCategories.contains(category["title"]);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedCategories.remove(category["title"]);
                              } else {
                                selectedCategories.add(category["title"]);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected ? category["color"] : Colors.white38,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(category["image"], height: 24, width: 24),
                                SizedBox(width: 10),
                                Text(
                                  category["title"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setStringList('selectedCategories', selectedCategories.toList());

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
