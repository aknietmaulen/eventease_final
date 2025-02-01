import 'package:flutter/material.dart';
import 'package:eventease_final/models/venue_model.dart';

class VenueDetailsPage extends StatelessWidget {
  final VenueModel venue;

  const VenueDetailsPage({super.key, required this.venue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(venue.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (venue.photo.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  venue.photo[0],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              SizedBox(height: 8),
              if (venue.photo.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    SizedBox(width: 8),
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

            Text(
              venue.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  venue.place,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Capacity and Rating in One Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${venue.capacity} people',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            SizedBox(height: 16),

            // Price and Price Type Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${venue.price} / ${venue.priceType}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),

            Text(
              'About the Venue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              venue.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),

            Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: venue.category.map((cat) {
                return Chip(label: Text(cat));
              }).toList(),
            ),
            SizedBox(height: 32),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle venue contact or booking action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
