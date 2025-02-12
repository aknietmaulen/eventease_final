
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

  final bottomBarItemsDataList = [
    TabItemModel(
      image: "assets/icons/icon-venue.png",
      title: "Venues",
      backgroundColor: MyTheme.customRed,
    ),
    TabItemModel(
      image: "assets/icons/icon-job.png",
      title: "Services",
      backgroundColor: MyTheme.customLightPurple,
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

  void selectBottomBarItem(int index) {
    print(">> selectBottomBarItem : index = $index");
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
      final latLng = LatLng(venue.location.latitude, venue.location.longitude); // Access latitude and longitude from GeoPoint
      _markers.add(
        Marker(
          markerId: MarkerId(venue.name), // Unique marker ID
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          position: latLng,
          infoWindow: InfoWindow(
            title: venue.name,
            snippet: '${venue.place} • ${venue.capacity} people • ${venue.price} tg/${venue.priceType} • ⭐ ${venue.rating.toStringAsFixed(1)}',
          ),
          onTap: () {
            // Handle marker tap
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(venue.name),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(venue.photo.isNotEmpty ? venue.photo[0] : 'https://via.placeholder.com/150'), // Show first photo or placeholder
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
      setState(() {}); // Update the UI to show the markers
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map', style: TextStyle(fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12.0,
        ),
        markers: _markers, // Set the markers to be displayed
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomBarItem(
              imagePath: bottomBarItemsDataList[0].image,
              title: bottomBarItemsDataList[0].title,
              isSelected: bottomBarItemSelectedIndex == 0,
              onTap: () {
                selectBottomBarItem(0);
                // Navigate to the venues Page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
            BottomBarItem(
              imagePath: bottomBarItemsDataList[1].image,
              title: bottomBarItemsDataList[1].title,
              isSelected: bottomBarItemSelectedIndex == 1,
              onTap: () {
                selectBottomBarItem(1);
                // Navigate to the venues Page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ServicesScreen(),
                  ),
                );
              },
            ),
            SizedBox(width: 30), // Spacing for FAB
            BottomBarItem(
              imagePath: bottomBarItemsDataList[2].image,
              title: bottomBarItemsDataList[2].title,
              isSelected: bottomBarItemSelectedIndex == 2,
              onTap: () {
                selectBottomBarItem(2);
              },
            ),
            BottomBarItem(
              imagePath: bottomBarItemsDataList[3].image,
              title: bottomBarItemsDataList[3].title,
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

  const BottomBarItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
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
            )
          ],
        ),
      ),
    );
  }
}



// import 'package:venue_booking_app_ui/models/tab_item_model.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../my_theme.dart';
// import 'package:venue_booking_app_ui/screens/venues.dart';
// import 'package:venue_booking_app_ui/screens/home/home_screen.dart';
// import 'package:venue_booking_app_ui/screens/profile_page.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../my_theme.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   var bottomBarItemSelectedIndex = 2; // Start on Map page
//   late GoogleMapController mapController;

//   final bottomBarItemsDataList = [
//     TabItemModel(
//       image: "assets/icons/ic_explore.png",
//       title: "Explore",
//       backgroundColor: MyTheme.customRed,
//     ),
//     TabItemModel(
//       image: "assets/icons/ic_calendar.png",
//       title: "venues",
//       backgroundColor: MyTheme.customYellowWithOrangeShade,
//     ),
//     TabItemModel(
//       image: "assets/icons/ic_location_marker.png",
//       title: "Map",
//       backgroundColor: MyTheme.foodTabItemColor,
//     ),
//     TabItemModel(
//       image: "assets/icons/ic_profile.png",
//       title: "Profile",
//       backgroundColor: MyTheme.customRed,
//     ),
//   ];

//   void selectBottomBarItem(int index) {
//     print(">> selectBottomBarItem : index = $index");
//     setState(() {
//       bottomBarItemSelectedIndex = index;
//     });
//   }

//   // Initial position for the map
//   static const LatLng _initialPosition = LatLng(51.16693117041015, 71.42941761898858); // Coordinates for Almaty, Kazakhstan


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map'),
//         automaticallyImplyLeading: false,
//       ),
//       body: GoogleMap(
//         onMapCreated: (GoogleMapController controller) {
//           mapController = controller;
//         },
//         initialCameraPosition: CameraPosition(
//           target: _initialPosition,
//           zoom: 12.0,
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             BottomBarItem(
//               imagePath: bottomBarItemsDataList[0].image,
//               title: bottomBarItemsDataList[0].title,
//               isSelected: bottomBarItemSelectedIndex == 0,
//               onTap: () {
//                 selectBottomBarItem(0);
//                 // Navigate to the venues Page
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => HomeScreen(
//                       //savedvenues: venueList, // Pass the saved venues here
//                     ),
//                   ),
//                 );
//               },
//             ),
//             BottomBarItem(
//               imagePath: bottomBarItemsDataList[1].image,
//               title: bottomBarItemsDataList[1].title,
//               isSelected: bottomBarItemSelectedIndex == 1,
//               onTap: () {
//                 selectBottomBarItem(1);

//                 // Navigate to the venues Page
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => venuesPage(
//                       //savedvenues: venueList, // Pass the saved venues here
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(width: 30), // Spacing for FAB
//             BottomBarItem(
//               imagePath: bottomBarItemsDataList[2].image,
//               title: bottomBarItemsDataList[2].title,
//               isSelected: bottomBarItemSelectedIndex == 2,
//               onTap: () {
//                 selectBottomBarItem(2);
//               },
//             ),
//             BottomBarItem(
//               imagePath: bottomBarItemsDataList[3].image,
//               title: bottomBarItemsDataList[3].title,
//               isSelected: bottomBarItemSelectedIndex == 3,
//               onTap: () {
//                 selectBottomBarItem(3);

//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => ProfilePage(
//                       //savedvenues: venueList, // Pass the saved venues here
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BottomBarItem extends StatelessWidget {
//   String imagePath;
//   String title;
//   bool isSelected;
//   Function onTap;

//   BottomBarItem(
//       {super.key,
//       required this.imagePath,
//       required this.title,
//       required this.isSelected,
//       required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         onTap.call();
//       },
//       child: Container(
//         margin: EdgeInsets.only(top: 6),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image(
//               width: 24,
//               height: 24,
//               image: AssetImage(imagePath),
//               color: (isSelected) ? MyTheme.customBlue1 : MyTheme.grey,
//             ),
//             Text(
//               title,
//               style: TextStyle(
//                   color: (isSelected) ? MyTheme.customBlue1 : MyTheme.grey),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TabItemsList extends StatelessWidget {
//   const TabItemsList({
//     super.key,
//     required this.tabItemsList,
//   });

//   final List<TabItemModel> tabItemsList;

//   @override
//   Widget build(BuildContext context) {
//     final query = MediaQuery.of(context);
//     return Container(
//       height: 40,
//       width: query.size.width,
//       margin: EdgeInsets.symmetric(vertical: 12),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (ctx, index) {
//           final item = tabItemsList[index];
//           return TabItem(
//             image: item.image,
//             title: item.title,
//             backgroundColor: item.backgroundColor,
//           );
//         },
//         itemCount: tabItemsList.length,
//       ),
//     );
//   }
// }

// class TabItem extends StatelessWidget {
//   String image;
//   String title;
//   Color backgroundColor;
//   TabItem({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.backgroundColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(right: 14),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(24)),
//         color: backgroundColor,
//       ),
//       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Image(
//             image: AssetImage(image),
//             width: 18,
//             height: 18,
//           ),
//           const SizedBox(width: 10),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





// // // class MapPage extends StatefulWidget {
// // //   final String selectedCity; // Add this line
// // //   const MapPage({super.key, required this.selectedCity}); // Modify the constructor

// // //   @override
// // //   State<MapPage> createState() => _MapPageState();
// // // }

// // // class _MapPageState extends State<MapPage> {
// // //   var bottomBarItemSelectedIndex = 2; // Start on Map page
// // //   late GoogleMapController mapController;

// // //   late LatLng _initialPosition; // Change to late initialization

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initialPosition = getCoordinatesForCity(widget.selectedCity); // Get the coordinates based on city
// // //   }

// // //   // Method to get coordinates based on city name
// // //   LatLng getCoordinatesForCity(String city) {
// // //     switch (city) {
// // //       case 'Astana':
// // //         return LatLng(51.1694, 71.4491); // Coordinates for Astana
// // //       // You can add more cities here if needed
// // //       default:
// // //         return LatLng(51.1694, 71.4491); // Default to Astana if city not found
// // //     }
// // //   }

// // //   void selectBottomBarItem(int index) {
// // //     print(">> selectBottomBarItem : index = $index");
// // //     setState(() {
// // //       bottomBarItemSelectedIndex = index;
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Map - ${widget.selectedCity}'),
// // //       ),
// // //       body: GoogleMap(
// // //         onMapCreated: (GoogleMapController controller) {
// // //           mapController = controller;
// // //         },
// // //         initialCameraPosition: CameraPosition(
// // //           target: _initialPosition,
// // //           zoom: 10.0,
// // //         ),
// // //         myLocationEnabled: true,
// // //         // Add other map configurations if needed
// // //       ),
// // //       bottomNavigationBar: BottomAppBar(
// // //         child: Row(
// // //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// // //           children: [
// // //             BottomBarItem(
// // //               imagePath: "assets/icons/ic_explore.png",
// // //               title: "Explore",
// // //               isSelected: bottomBarItemSelectedIndex == 0,
// // //               onTap: () {
// // //                 selectBottomBarItem(0);
// // //                 Navigator.of(context).push(
// // //                   MaterialPageRoute(
// // //                     builder: (context) => HomeScreen(),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //             BottomBarItem(
// // //               imagePath: "assets/icons/ic_calendar.png",
// // //               title: "venues",
// // //               isSelected: bottomBarItemSelectedIndex == 1,
// // //               onTap: () {
// // //                 selectBottomBarItem(1);
// // //                 Navigator.of(context).push(
// // //                   MaterialPageRoute(
// // //                     builder: (context) => venuesPage(),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //             BottomBarItem(
// // //               imagePath: "assets/icons/ic_location_marker.png",
// // //               title: "Map",
// // //               isSelected: bottomBarItemSelectedIndex == 2,
// // //               onTap: () {
// // //                 selectBottomBarItem(2);
// // //               },
// // //             ),
// // //             BottomBarItem(
// // //               imagePath: "assets/icons/ic_profile.png",
// // //               title: "Profile",
// // //               isSelected: bottomBarItemSelectedIndex == 3,
// // //               onTap: () {
// // //                 selectBottomBarItem(3);
// // //                 Navigator.of(context).push(
// // //                   MaterialPageRoute(
// // //                     builder: (context) => ProfilePage(),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // class BottomBarItem extends StatelessWidget {
// // //   final String imagePath;
// // //   final String title;
// // //   final bool isSelected;
// // //   final Function onTap;

// // //   BottomBarItem({
// // //     super.key,
// // //     required this.imagePath,
// // //     required this.title,
// // //     required this.isSelected,
// // //     required this.onTap,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return InkWell(
// // //       onTap: () {
// // //         onTap.call();
// // //       },
// // //       child: Container(
// // //         margin: EdgeInsets.only(top: 6),
// // //         child: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             Image(
// // //               width: 24,
// // //               height: 24,
// // //               image: AssetImage(imagePath),
// // //               color: (isSelected) ? MyTheme.customBlue1 : MyTheme.grey,
// // //             ),
// // //             Text(
// // //               title,
// // //               style: TextStyle(
// // //                 color: (isSelected) ? MyTheme.customBlue1 : MyTheme.grey,
// // //               ),
// // //             )
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
