import 'package:eventease_final/my_theme.dart';
import 'package:eventease_final/pages/venue_details.dart';
import 'package:eventease_final/providers/venue_provider.dart';
import 'package:flutter/material.dart';
import 'package:eventease_final/models/venue_model.dart'; // Ensure you have a VenueModel
import 'package:provider/provider.dart'; // Ensure you fetch data from repository

class AdvancedFiltersPage extends StatefulWidget {
  @override
  _AdvancedFiltersPageState createState() => _AdvancedFiltersPageState();
}

class _AdvancedFiltersPageState extends State<AdvancedFiltersPage> {
  String searchQuery = "";
  String selectedCategory = "All";
  double minPrice = 0;
  double maxPrice = 10000;
  double minCapacity = 0;
  double maxCapacity = 500;
  List<VenueModel> filteredVenues = [];
  

  final List<String> categories = [
    "All",
    "Wedding",
    "Corporate event",
    "Birthday",
    "Photoshoot",
    "Conference"
  ];

  void applyFilters() async {
    final venuesProvider = Provider.of<VenueProvider>(context, listen: false);
    List<VenueModel> venues = venuesProvider.venues;
    setState(() {
      filteredVenues = venues.where((venue) {
        bool matchesCategory = selectedCategory == "All" || venue.category.contains(selectedCategory);
        bool matchesPrice = venue.price >= minPrice && venue.price <= maxPrice;
        bool matchesCapacity = venue.capacity >= minCapacity && venue.capacity <= maxCapacity;
        bool matchesSearch = venue.name.toLowerCase().contains(searchQuery.toLowerCase());

        return matchesCategory && matchesPrice && matchesCapacity && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advanced Filters", style: TextStyle(fontWeight: FontWeight.bold)), 
        backgroundColor: MyTheme.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF800080)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter
            Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 180, // Adjust height for scrolling
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    title: Text(categories[index]),
                    value: categories[index],
                    groupValue: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value.toString();
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),

            // Price Range Filter
            Text("Price Range (KZT)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            RangeSlider(
              values: RangeValues(minPrice, maxPrice),
              min: 0,
              max: 50000,
              divisions: 20,
              labels: RangeLabels(minPrice.toString(), maxPrice.toString()),
              onChanged: (RangeValues values) {
                setState(() {
                  minPrice = values.start;
                  maxPrice = values.end;
                });
              },
            ),

            // Capacity Filter
            Text("Capacity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            RangeSlider(
              values: RangeValues(minCapacity, maxCapacity),
              min: 0,
              max: 500,
              divisions: 10,
              labels: RangeLabels(minCapacity.toString(), maxCapacity.toString()),
              onChanged: (RangeValues values) {
                setState(() {
                  minCapacity = values.start;
                  maxCapacity = values.end;
                });
              },
            ),

            SizedBox(height: 20),

            // Search Button
            ElevatedButton(
              onPressed: applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: Text("Search", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),

            SizedBox(height: 20),

            // Filtered Venues List
            // Filtered Venues List
Expanded(
  child: filteredVenues.isEmpty
      ? Center(child: Text("No venues found"))
      : ListView.builder(
          itemCount: filteredVenues.length,
          itemBuilder: (context, index) {
            VenueModel venue = filteredVenues[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VenueDetailsPage(venue: venue),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Venue Photo
                      if (venue.photo.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            venue.photo[0],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(width: 12),
                      
                      // Venue Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              venue.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              venue.place,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.people, size: 16, color: Colors.blue),
                                SizedBox(width: 4),
                                Text(
                                  '${venue.capacity} people',
                                  style: TextStyle(fontSize: 14, color: Colors.blue),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.attach_money, size: 16, color: Colors.green),
                                SizedBox(width: 4),
                                Text(
                                  '${venue.price} tg',
                                  style: TextStyle(fontSize: 14, color: Colors.green),
                                ),
                              ],
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
)

          ],
        ),
      ),
    );
  }
}
