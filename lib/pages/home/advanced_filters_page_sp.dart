import 'package:eventease_final/my_theme.dart';
import 'package:eventease_final/pages/sp_details.dart';
import 'package:eventease_final/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:eventease_final/models/service_provider_model.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class AdvancedFiltersPageSP extends StatefulWidget {
  @override
  _AdvancedFiltersPageSPState createState() => _AdvancedFiltersPageSPState();
}

class _AdvancedFiltersPageSPState extends State<AdvancedFiltersPageSP> {
  String searchQuery = "";
  String selectedCategory = "All";
  double minPrice = 0;
  double maxPrice = 100000;
  List<ServiceProviderModel> filteredServiceProviders = [];

  final List<String> categories = [
    "All",
    "Photographer",
    "Videographer",
    "Dancer",
  ];

  void applyFilters() {
    final serviceProviderProvider = Provider.of<ServiceProviderProvider>(context, listen: false);
    List<ServiceProviderModel> serviceProviders = serviceProviderProvider.serviceProviders;

    setState(() {
      filteredServiceProviders = serviceProviders.where((sp) {
        bool matchesCategory = selectedCategory == "All" || sp.services.contains(selectedCategory);
        bool matchesSearch = sp.name.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchesPrice = false;

        // Normalize price string
        String normalizedPrice = sp.price.toLowerCase().trim();

        double? spMinPrice, spMaxPrice;

        if (normalizedPrice == "negotiable") {
          spMinPrice = 0;
          spMaxPrice = double.infinity;
          matchesPrice = true; // Always include negotiable prices
        } else if (normalizedPrice.startsWith("from ")) {
          spMinPrice = double.tryParse(normalizedPrice.replaceAll("from ", "").replaceAll(" ", ""));
          spMaxPrice = double.infinity; // No upper limit
        } else if (normalizedPrice.contains(" - ")) {
          var prices = normalizedPrice.split(" - ").map((p) => double.tryParse(p.replaceAll(" ", ""))).toList();
          if (prices.length == 2 && prices[0] != null && prices[1] != null) {
            spMinPrice = prices[0];
            spMaxPrice = prices[1];
          }
        }

        // Ensure no null values
        spMinPrice ??= 0;
        spMaxPrice ??= double.infinity;

        // Include service provider if:
        // 1. Their entire price range fits within the selected range
        // 2. OR their price is "Negotiable"
        if (matchesPrice || (spMinPrice >= minPrice && spMaxPrice <= maxPrice)) {
          matchesPrice = true;
        }


        return matchesCategory && matchesSearch && matchesPrice;
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
            Text("Category", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 120,
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
            Text("Price Range (KZT)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            RangeSlider(
              values: RangeValues(minPrice, maxPrice),
              min: 0,
              max: 250000,
              divisions: 20,
              labels: RangeLabels(minPrice.toString(), maxPrice.toString()),
              onChanged: (RangeValues values) {
                setState(() {
                  minPrice = values.start;
                  maxPrice = values.end;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              ),
              child: Text("Search", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredServiceProviders.isEmpty
                  ? Center(child: Text("No service providers found"))
                  : ListView.builder(
                      itemCount: filteredServiceProviders.length,
                      itemBuilder: (context, index) {
                        ServiceProviderModel sp = filteredServiceProviders[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SPDetailsPage(serviceProvider: sp),
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
                                  if (sp.photos.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        sp.photos[0],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sp.name,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 6),
                                        Text(sp.price, style: TextStyle(fontSize: 14, color: Colors.green)),
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
            ),
          ],
        ),
      ),
    );
  }
}
