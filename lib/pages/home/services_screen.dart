import 'package:eventease_final/models/tab_item_model.dart';
import 'package:eventease_final/my_theme.dart';
import 'package:eventease_final/pages/home/home_screen.dart';
import 'package:eventease_final/pages/home/widgets/top_container.dart';
import 'package:eventease_final/pages/home/widgets/top_container_sp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/service_provider_model.dart';
import '../../providers/service_provider.dart';
import '../sp_details.dart';
import '../map_page.dart';
import '../profile_page.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _searchQuery = "";
  
  @override
  void initState() {
    super.initState();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }
  
  List<TabItemModel> tabItemsList = [
    TabItemModel(image: "assets/icons/heart.png", title: "Wedding", backgroundColor: MyTheme.pinkWedding),
    TabItemModel(image: "assets/icons/briefcase.png", title: "Corporate event", backgroundColor: MyTheme.blueCorporate),
    TabItemModel(image: "assets/icons/balloon.png", title: "Birthday", backgroundColor: MyTheme.yellowBirthday),
    TabItemModel(image: "assets/icons/photograph.png", title: "Photoshoot", backgroundColor: MyTheme.orangePhotoshoot),
    TabItemModel(image: "assets/icons/formal.png", title: "Conference", backgroundColor: MyTheme.redConference),
  ];


  Future<List<ServiceProviderModel>> _getFilteredProviders() async {
    final provider = Provider.of<ServiceProviderProvider>(context, listen: false);
    await provider.fetchServiceProviders();
    
    if (_searchQuery.isNotEmpty) {
      return provider.searchServiceProviders(_searchQuery);
    }
    return provider.serviceProviders;
  }

  var bottomBarItemSelectedIndex = 1;

  void selectBottomBarItem(int index) {
    setState(() {
      bottomBarItemSelectedIndex = index;
    });
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopContainerSP(
            tabItemsList: [],
            onSearch: _onSearch,
            onCategorySelected: (_) {},
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<ServiceProviderModel>>(
              future: _getFilteredProviders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                final providers = snapshot.data ?? [];

                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: providers.length,
                  itemBuilder: (ctx, index) {
                    final provider = providers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SPDetailsPage(serviceProvider: provider),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(provider.photos.isNotEmpty ? provider.photos[0] : 'https://via.placeholder.com/150'),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider.name,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      provider.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 6),
                                    Wrap(
                                      spacing: 6,
                                      children: provider.services.map((service) {
                                        return Chip(
                                          label: Text(service, style: TextStyle(fontSize: 12)),
                                          backgroundColor:  Color(0xFFFFD700),
                                        );
                                      }).toList(),
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
                );
              },
            ),
          ),
        ],
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            ),
            BottomBarItem(
              imagePath: "assets/icons/icon-job.png",
              title: "Services",
              isSelected: bottomBarItemSelectedIndex == 1,
              onTap: () {
                selectBottomBarItem(1);
              },
            ),
            SizedBox(width: 3),
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
