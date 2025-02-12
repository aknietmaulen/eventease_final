//final with random time sorted in chronological order
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventease_final/my_theme.dart';
import 'package:eventease_final/pages/home/services_screen.dart';
import 'package:eventease_final/pages/map_page.dart';
import 'package:eventease_final/pages/profile_page.dart';
import 'package:eventease_final/pages/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:eventease_final/models/venue_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';

class VenueDetailsPage extends StatefulWidget {
  final VenueModel venue;

  const VenueDetailsPage({super.key, required this.venue});

  @override
  _VenueDetailsPageState createState() => _VenueDetailsPageState();
}

class _VenueDetailsPageState extends State<VenueDetailsPage> {

  var bottomBarItemSelectedIndex = 0;

  void selectBottomBarItem(int index) {
    setState(() {
      bottomBarItemSelectedIndex = index;
    });
  }

  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfVenueIsSaved();
    _generateRandomAvailability();
  }

  Future<void> _checkIfVenueIsSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedVenuesList = prefs.getStringList('saved_venues') ?? [];

    // Encode venue as JSON
    String venueJson = jsonEncode({
      "name": widget.venue.name,
      "imageUrl": widget.venue.photo[0],
      "place": widget.venue.place, // Ensure 'place' is included

    });

    setState(() {
      isSaved = savedVenuesList.contains(venueJson);
    });
  }

  void _toggleSaveVenue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedVenuesList = prefs.getStringList('saved_venues') ?? [];

    // Ensure 'photo' is treated as an array
    String venueJson = jsonEncode({
      "name": widget.venue.name,
      "imageUrl": widget.venue.photo[0], // Store full array instead of a string
      "place": widget.venue.place, // Ensure 'place' is included

    });

    setState(() {
      if (isSaved) {
        savedVenuesList.remove(venueJson);
        isSaved = false;
      } else {
        savedVenuesList.add(venueJson);
        isSaved = true;
      }
    });

    await prefs.setStringList('saved_venues', savedVenuesList);
  }


  void _showFullScreenImage(List<String> images, int startIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black, // Full dark background
      builder: (context) {
        return Stack(
          children: [
            // Full-screen PageView
            PageView.builder(
              itemCount: images.length,
              controller: PageController(initialPage: startIndex),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(), // Tap anywhere to close
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 1,
                    maxScale: 4,
                    child: Container(
                      color: Colors.black, // Ensures full black background
                      alignment: Alignment.center,
                      child: Image.network(
                        images[index],
                        fit: BoxFit.contain, // Prevents cropping
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Close Button (Top-Right)
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Color(0xFF800080), size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }



  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<String>> availableTimes = {};

  final List<String> possibleTimes = [
    '9:00 AM', '10:00 AM', '11:00 AM', '1:00 PM', '2:00 PM', '3:00 PM',
    '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM'
  ];

  void _generateRandomAvailability() {
    final random = Random();
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day; // Get total days in the month

    for (int i = 0; i < 15; i++) { // Generate availability for 10 random days
      int day = random.nextInt(daysInMonth) + 1;
      DateTime date = DateTime(now.year, now.month, day);

      List<String> times = [];
      int timeSlots = random.nextInt(4) + 1; // Each day gets 1 to 4 random time slots

      for (int j = 0; j < timeSlots; j++) {
        String randomTime = possibleTimes[random.nextInt(possibleTimes.length)];
        if (!times.contains(randomTime)) {
          times.add(randomTime);
        }
      }

      availableTimes[date] = times;
    }
  }

  void _showAvailableTimes(DateTime date) {
    List<String> times = availableTimes[DateTime(date.year, date.month, date.day)] ?? [];

    times.sort((a, b) {
      int aHour = int.parse(a.split(':')[0]);
      int bHour = int.parse(b.split(':')[0]);
      String aPeriod = a.split(' ')[1];
      String bPeriod = b.split(' ')[1];
      
      if (aPeriod == bPeriod) {
        return aHour.compareTo(bHour);
      }
      return aPeriod == "AM" ? -1 : 1;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Available Times"),
          content: times.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: times.map((time) => ListTile(title: Text(time))).toList(),
                )
              : Text("No available times for this date."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.venue.name, style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF800080)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: Colors.purple),
            onPressed: _toggleSaveVenue,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Images
            if (widget.venue.photo.length >= 3) ...[
              // Large Top Image
              GestureDetector(
                onTap: () => _showFullScreenImage(widget.venue.photo, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.venue.photo[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
              SizedBox(height: 8),

              // Two Smaller Images Below
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showFullScreenImage(widget.venue.photo, 1),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.venue.photo[1],
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showFullScreenImage(widget.venue.photo, 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.venue.photo[2],
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
            // Venue Information Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.venue.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.redAccent),
                        SizedBox(width: 6),
                        Expanded(child: Text(widget.venue.place, style: TextStyle(fontSize: 16, color: Colors.grey[700]))),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.blueAccent),
                            SizedBox(width: 6),
                            Text('${widget.venue.capacity} people', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text(widget.venue.rating.toStringAsFixed(1), style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.attach_money, color: Colors.green),
                        SizedBox(width: 6),
                        Text('${widget.venue.price} tg / ${widget.venue.priceType}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // About the Venue
            SizedBox(height: 8),
            Text('About the Venue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(thickness: 1),
            SizedBox(height: 8),
            Text(widget.venue.description.replaceAll('- ', '\n- '), style: TextStyle(fontSize: 16, color: Colors.grey[800])),
            SizedBox(height: 24),

            // Categories Section
            Text("Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(thickness: 1),
            Wrap(
              spacing: 8.0,
              children: widget.venue.category.map((cat) {
                return Chip(
                  label: Text(cat, style: TextStyle(fontWeight: FontWeight.w500)),
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                );
              }).toList(),
            ),
            SizedBox(height: 24),

            // Calendar Section
            Text("Select a Date", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(thickness: 1),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _selectedDate,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
                _showAvailableTimes(selectedDay);
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            SizedBox(height: 32),

            // Contact Venue Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(widget.venue.link);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not open the chat link")));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF800080), padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [Text("Contact Venue", style: TextStyle(fontSize: 16, color: Colors.white)), SizedBox(width: 8), Icon(Icons.chat, color: Colors.white)]),
              ),
            ),
            SizedBox(height: 32),
            ReviewsSection(venueName: widget.venue.name),
          ],
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
              },
            ),
            BottomBarItem(
              imagePath: "assets/icons/icon-job.png",
              title: "Services",
              isSelected: bottomBarItemSelectedIndex == 1,
              onTap: () {
                selectBottomBarItem(1);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServicesScreen(),
                  ),
                );
              },
            ),
            SizedBox(width:3), // Spacing for FAB
            BottomBarItem(
              imagePath: "assets/icons/ic_location_marker.png",
              title: "Map",
              isSelected: bottomBarItemSelectedIndex == 2,
              onTap: () {
                selectBottomBarItem(2);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                );
              },
            ),
            BottomBarItem(
              imagePath: "assets/icons/ic_profile.png",
              title: "Profile",
              isSelected: bottomBarItemSelectedIndex == 3,
              onTap: () {
                selectBottomBarItem(3);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class BottomBarItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isSelected;
  final Function onTap;

  BottomBarItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Container(
        margin: EdgeInsets.only(top: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              width: 24,
              height: 24,
              image: AssetImage(imagePath),
              color: (isSelected) ? MyTheme.customPurple1 : MyTheme.grey,
            ),
            Text(
              title,
              style: TextStyle(
                color: (isSelected) ? MyTheme.customPurple1 : MyTheme.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
