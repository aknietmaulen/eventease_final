import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventease_final/models/service_provider_model.dart';
import 'package:eventease_final/models/venue_model.dart';
import 'package:eventease_final/my_theme.dart';
import 'package:flutter/material.dart';

class SpItem extends StatelessWidget {
  final ServiceProviderModel spModel;

  SpItem({Key? key, required this.spModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240, // Fixed width for each venue item
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 240, // Ensure image container matches the set width
                height: 160, // Set fixed height for image carousel
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child:spModel.photos.isNotEmpty
                    ? CarouselSlider(
                        options: CarouselOptions(
                          height: 160,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                        ),
                        items: spModel.photos.map((photoUrl) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              width: 240,
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                            ),
                          );
                        }).toList(),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                      ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              spModel.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: MyTheme.grey,
                  size: 16,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    spModel.price,
                    style: TextStyle(color: MyTheme.grey, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}