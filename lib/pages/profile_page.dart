import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventease_final/models/tab_item_model.dart';
import 'package:eventease_final/models/venue_model.dart';
import 'package:eventease_final/my_theme.dart';
import 'package:eventease_final/pages/all_venues.dart';
import 'package:eventease_final/pages/edit_profile_screen.dart';
import 'package:eventease_final/pages/home/home_screen.dart';
import 'package:eventease_final/pages/home/services_screen.dart';
import 'package:eventease_final/pages/map_page.dart';
import 'package:eventease_final/pages/venue_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = '';
  String _profileURL = '';
  List<Map<String, String>> savedVenues = [];

  final bottomBarItemsDataList = [
    TabItemModel(
      image: "assets/icons/icon-venue.png",
      title: "Venues",
      backgroundColor: MyTheme.customRed,
    ),
    TabItemModel(
      image: "assets/icons/icon-job.png",
      title: "Services",
      backgroundColor: MyTheme.customYellow,
    ),
    TabItemModel(
      image: "assets/icons/ic_location_marker.png",
      title: "Map",
      backgroundColor: MyTheme.foodTabItemColor,
    ),
    TabItemModel(
      image: "assets/icons/ic_profile.png",
      title: "Profile",
      backgroundColor: MyTheme.customRed,
    ),
  ];
  
  var bottomBarItemSelectedIndex = 3;

  void selectBottomBarItem(int index) {
    setState(() {
      bottomBarItemSelectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSavedVenues();
  }

  Future<void> _loadUserData() async {
    final userData = await Provider.of<AuthProvider>(context, listen: false).getUserData();
    if (userData != null) {
      setState(() {
        _name = userData['name'] ?? '';
        _profileURL = userData['profileURL'] ?? '';
      });
    }
  }

  Future<void> _loadSavedVenues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedVenuesStringList = prefs.getStringList('saved_venues');

    print("Retrieved saved venues: $savedVenuesStringList");

    if (savedVenuesStringList != null) {
      try {
        setState(() {
          savedVenues = savedVenuesStringList.map((venueString) {
            Map<String, dynamic> decoded = jsonDecode(venueString);
            print("Decoded venue: $decoded");

            return {
              "name": decoded["name"]?.toString() ?? "Unknown Venue",
              "imageUrl": decoded["imageUrl"]?.toString() ?? "https://via.placeholder.com/150",
              "place": decoded["place"]?.toString() ?? "Unknown Place", // Added 'place' field
            };
          }).toList();
        });
      } catch (e) {
        print("Error decoding saved venues: $e");
        setState(() {
          savedVenues = [];
        });
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(_profileURL.isNotEmpty ? _profileURL : 'https://erms.bugemauniv.ac.ug/student/image/user_icon.png'),
              ),
              const SizedBox(height: 16),
              Text(
                _name.isNotEmpty ? _name : 'No Name',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfileScreen()),
                  );
                },
                icon: const Icon(Icons.edit, color: Colors.yellow),
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.yellow),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              const Text('Saved Venues', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (savedVenues.isEmpty)
                const Text('No saved venues yet.', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ...savedVenues.map((venue) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    venue['imageUrl'] ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                  ),
                ),
                title: Text(
                  venue['name'] ?? 'Unknown Venue',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Place: ${venue['place'] ?? 'Unknown Place'}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),

              ),
            )),

                  const SizedBox(height: 16),

                  // 👉 Add the Clear Button here
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     SharedPreferences prefs = await SharedPreferences.getInstance();
                  //     await prefs.remove('saved_venues'); // Clears old saved data
                  //     setState(() {
                  //       savedVenues.clear();
                  //     });
                  //     print("Saved venues cleared.");
                  //   },
                  //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  //   child: const Text("Clear Saved Venues", style: TextStyle(color: Colors.white)),
                  // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomBarItem(
              imagePath: "assets/icons/icon-venue.png",
              title: "Venues",
              isSelected: bottomBarItemSelectedIndex == 0,
              onTap: () {
                selectBottomBarItem(0);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            BottomBarItem(
              imagePath: "assets/icons/icon-job.png",
              title: "Services",
              isSelected: bottomBarItemSelectedIndex == 1,
              onTap: () {
                selectBottomBarItem(1);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServicesScreen()));
              },
            ),
            const SizedBox(width: 30),
            BottomBarItem(
              imagePath: "assets/icons/ic_location_marker.png",
              title: "Map",
              isSelected: bottomBarItemSelectedIndex == 2,
              onTap: () {
                selectBottomBarItem(2);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage()));
              },
            ),
            BottomBarItem(
              imagePath: "assets/icons/ic_profile.png",
              title: "Profile",
              isSelected: bottomBarItemSelectedIndex == 3,
              onTap: () {
                selectBottomBarItem(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}


class BottomBarItem extends StatelessWidget {
  String imagePath;
  String title;
  bool isSelected;
  Function onTap;

  BottomBarItem({super.key, required this.imagePath, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              width: 24,
              height: 24,
              image: AssetImage(imagePath),
              color: isSelected ? MyTheme.customPurple1 : MyTheme.grey,
            ),
            Text(
              title,
              style: TextStyle(color: isSelected ? MyTheme.customPurple1 : MyTheme.grey),
            )
          ],
        ),
      ),
    );
  }
}