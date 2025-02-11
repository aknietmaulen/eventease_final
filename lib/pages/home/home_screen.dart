import 'package:eventease_final/models/tab_item_model.dart';
import 'package:eventease_final/models/venue_model.dart';
import 'package:eventease_final/pages/all_venues.dart';
import 'package:eventease_final/pages/home/services_screen.dart';
import 'package:eventease_final/pages/map_page.dart';
import 'package:eventease_final/pages/profile_page.dart';
import 'package:eventease_final/pages/venue_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../my_theme.dart';
import './widgets/top_container.dart';
import './widgets/home_venue_item.dart';
import 'package:provider/provider.dart';
import '../../providers/venue_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";
  String _selectedCategory = ""; // Initially no category selected

  @override
  void initState() {
    super.initState();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _searchQuery = ""; // Clear search when selecting a category
    });
  }

  List<TabItemModel> tabItemsList = [
    TabItemModel(image: "assets/icons/heart.png", title: "Wedding", backgroundColor: MyTheme.pinkWedding),
    TabItemModel(image: "assets/icons/briefcase.png", title: "Corporate event", backgroundColor: MyTheme.blueCorporate),
    TabItemModel(image: "assets/icons/balloon.png", title: "Birthday", backgroundColor: MyTheme.yellowBirthday),
    TabItemModel(image: "assets/icons/photograph.png", title: "Photoshoot", backgroundColor: MyTheme.orangePhotoshoot),
    TabItemModel(image: "assets/icons/formal.png", title: "Conference", backgroundColor: MyTheme.redConference),
  ];

  var bottomBarItemSelectedIndex = 0;

  void selectBottomBarItem(int index) {
    setState(() {
      bottomBarItemSelectedIndex = index;
    });
  }

  Future<List<VenueModel>> _getFilteredVenues() async {
    final venuesProvider = Provider.of<VenueProvider>(context, listen: false);

    await venuesProvider.fetchVenues();
    List<VenueModel> venues = venuesProvider.venues;

    if (_searchQuery.isNotEmpty) {
      return venuesProvider.searchVenues(_searchQuery);
    } 
    if (_selectedCategory.isNotEmpty) {
      return venuesProvider.fetchVenuesByCategory(_selectedCategory);
    }

    return venuesProvider.fetchPopularVenues(); // Show only popular venues if no search or category selected
  }

  Future<List<VenueModel>> _getVenuesForYou() async {
    final venuesProvider = Provider.of<VenueProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> selectedCategories = prefs.getStringList('selectedCategories') ?? [];

    return venuesProvider.getVenuesBySelection(selectedCategories);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopContainer(
              tabItemsList: tabItemsList,
              onSearch: _onSearch,
              onCategorySelected: _onCategorySelected,
            ),
            SizedBox(height: 27),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _searchQuery.isNotEmpty
                          ? "Search Results"
                          : _selectedCategory.isNotEmpty
                              ? "Venues for $_selectedCategory"
                              : "Popular Venues",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (_searchQuery.isEmpty && _selectedCategory.isEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => VenuesPage()),
                        );
                      },
                      child: Row(
                        children: [Text("See All"), Icon(Icons.arrow_right)],
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 240,
              child: FutureBuilder<List<VenueModel>>(
                future: _getFilteredVenues(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final venues = snapshot.data ?? [];

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: venues.length,
                    itemBuilder: (ctx, index) {
                      final venueModel = venues[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VenueDetailsPage(venue: venueModel),
                            ),
                          );
                        },
                        child: HomeVenueItem(venueModel: venueModel),
                      );
                    },
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  );
                },
              ),
            ),
            SizedBox(height: 3),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Venues for You",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 240,
              child: FutureBuilder<List<VenueModel>>(
                future: _getVenuesForYou(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  final venues = snapshot.data ?? [];

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: venues.length,
                    itemBuilder: (ctx, index) {
                      final venueModel = venues[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VenueDetailsPage(venue: venueModel),
                            ),
                          );
                        },
                        child: HomeVenueItem(venueModel: venueModel),
                      );
                    },
                    padding: EdgeInsets.symmetric(horizontal: 12),
                  );
                },
              ),
            ),
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