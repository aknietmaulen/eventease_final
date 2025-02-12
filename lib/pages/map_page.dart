import 'package:eventease_final/models/tab_item_model.dart';
import 'package:eventease_final/models/venue_model.dart';
import 'package:eventease_final/pages/all_venues.dart';
import 'package:eventease_final/pages/home/home_screen.dart';
import 'package:eventease_final/pages/home/services_screen.dart';
import 'package:eventease_final/pages/profile_page.dart';
import 'package:eventease_final/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../my_theme.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var bottomBarItemSelectedIndex = 2; // Start on Map page
  late GoogleMapController mapController;

  final Set<Marker> _markers = {}; // Set of markers to be displayed on the map

  void selectBottomBarItem(int index) {
    setState(() {
      bottomBarItemSelectedIndex = index;
    });
  }

  // Initial position for the map
  static const LatLng _initialPosition = LatLng(51.16693117041015, 71.42941761898858); // Coordinates for Astana, Kazakhstan

  @override
  void initState() {
    super.initState();
    _fetchvenues(); // Fetch venues when the map page is initialized
  }

  Future<void> _fetchvenues() async {
    await Provider.of<VenueProvider>(context, listen: false).fetchVenues();
    final venues = Provider.of<VenueProvider>(context, listen: false).venues;
    _setMarkers(venues);
  }

  void _setMarkers(List<VenueModel> venues) {
    for (var venue in venues) {
      final latLng = LatLng(venue.location.latitude, venue.location.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId(venue.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          position: latLng,
          infoWindow: InfoWindow(
            title: venue.name,
            snippet: '${venue.place} • ${venue.capacity} people • ${venue.price} tg/${venue.priceType} • ⭐ ${venue.rating.toStringAsFixed(1)}',
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(venue.name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(venue.photo.isNotEmpty ? venue.photo[0] : 'https://via.placeholder.com/150'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.redAccent),
                          const SizedBox(width: 6),
                          Expanded(child: Text(venue.place, style: TextStyle(fontSize: 16, color: Colors.grey[700]))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.people, color: Colors.blueAccent),
                              const SizedBox(width: 6),
                              Text('${venue.capacity} people', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(venue.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.attach_money, color: Colors.green),
                          const SizedBox(width: 6),
                          Text('${venue.price} tg / ${venue.priceType}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        markers: _markers,
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
                selectBottomBarItem(1);
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
            SizedBox(width: 3), // Spacing for FAB
            BottomBarItem(
              imagePath: "assets/icons/ic_location_marker.png",
              title: "Map",
              isSelected: bottomBarItemSelectedIndex == 2,
              onTap: () => selectBottomBarItem(2),
            ),
            BottomBarItem(
              imagePath: "assets/icons/ic_profile.png",
              title: "Profile",
              isSelected: bottomBarItemSelectedIndex == 3,
              onTap: () {
                selectBottomBarItem(3);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
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