import 'package:eventease_final/models/venue_model.dart';
import 'package:eventease_final/my_theme.dart';
import 'package:eventease_final/pages/home/home_screen.dart';
import 'package:eventease_final/pages/map_page.dart';
import 'package:eventease_final/pages/profile_page.dart';
import 'package:eventease_final/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VenuesPage extends StatefulWidget {
  const VenuesPage({super.key});

  @override
  State<VenuesPage> createState() => _VenuesPageState();
}

class _VenuesPageState extends State<VenuesPage> {
  var bottomBarItemSelectedIndex = 1; // Start on Venues page

  void selectBottomBarItem(int index) {
    setState(() {
      bottomBarItemSelectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch venues when the widget initializes
    Provider.of<VenueProvider>(context, listen: false).fetchVenues();
  }

  @override
  Widget build(BuildContext context) {
    final venueProvider = Provider.of<VenueProvider>(context);
    final venueList = venueProvider.venues;

    return Scaffold(
      appBar: AppBar(
        title: Text('Venues'),
        automaticallyImplyLeading: false,
      ),
      body: venueList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: venueList.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (ctx, index) {
                final venueModel = venueList[index];
                return GestureDetector(
                  onTap: () {
                    // Just for now, we do nothing on tap
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Display photo (small size)
                          if (venueModel.photo.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                venueModel.photo[0],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          SizedBox(width: 12),
                          // Venue details (name, place, description)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Venue name
                                Text(
                                  venueModel.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Venue place
                                Text(
                                  venueModel.place,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Venue description (truncate if too long)
                                Text(
                                  venueModel.description,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomBarItem(
              imagePath: "assets/icons/ic_explore.png",
              title: "Explore",
              isSelected: bottomBarItemSelectedIndex == 0,
              onTap: () {
                selectBottomBarItem(1);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
            BottomBarItem(
              imagePath: "assets/icons/ic_calendar.png",
              title: "Events",
              isSelected: bottomBarItemSelectedIndex == 1,
              onTap: () {
                selectBottomBarItem(1);
              },
            ),
            SizedBox(width: 30), // Spacing for FAB
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
