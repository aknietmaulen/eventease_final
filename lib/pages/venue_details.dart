
import 'package:flutter/material.dart';
import 'package:eventease_final/models/venue_model.dart';

class VenueDetailsPage extends StatelessWidget {
  final VenueModel venue;

  const VenueDetailsPage({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(venue.name, style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Images
            if (venue.photo.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  venue.photo[0],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              SizedBox(height: 10),
              if (venue.photo.length > 1)
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          venue.photo[1],
                          fit: BoxFit.cover,
                          height: 120,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    if (venue.photo.length > 2)
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            venue.photo[2],
                            fit: BoxFit.cover,
                            height: 120,
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
                    Text(
                      venue.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.redAccent),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            venue.place,
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Capacity & Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.blueAccent),
                            SizedBox(width: 6),
                            Text(
                              '${venue.capacity} people',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            SizedBox(width: 4),
                            Text(
                              venue.rating.toStringAsFixed(1),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Price Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.attach_money, color: Colors.green),
                        SizedBox(width: 6),
                        Text(
                          '${venue.price} tg / ${venue.priceType}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // About the Venue
            Text(
              'About the Venue',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 1),
            SizedBox(height: 8),
            Text(
              venue.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 24),

            // Categories Section
            Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(thickness: 1),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: venue.category.map((cat) {
                return Chip(
                  label: Text(cat, style: TextStyle(fontWeight: FontWeight.w500)),
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                );
              }).toList(),
            ),
            SizedBox(height: 32),

            // Contact Venue Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle venue contact or booking action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Contact Venue", style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(Icons.phone),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
