import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventease_final/models/venue_model.dart';
import 'package:eventease_final/my_theme.dart';
import 'package:flutter/material.dart';

class HomeVenueItem extends StatelessWidget {
  final VenueModel venueModel;

  HomeVenueItem({
    super.key,
    required this.venueModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      height: 280, // Adjusted height for carousel
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 160,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: venueModel.photo.length > 1,
                  autoPlay: venueModel.photo.length > 1,
                ),
                items: venueModel.photo.map((photoUrl) {
                  return ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Image.network(
                      photoUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              venueModel.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: MyTheme.grey,
                ),
                SizedBox(width: 4),
                Text(
                  venueModel.place,
                  style: TextStyle(color: MyTheme.grey, fontSize: 16),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
