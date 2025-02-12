import 'package:cloud_firestore/cloud_firestore.dart';

class VenueModel {
  final List<String> category;  // For multiple categories
  final String description;
  final GeoPoint location;
  final String name;
  final List<String> photo;  // For multiple photo URLs
  final String place;
  final String contact;
  final double rating; 
  final int capacity; 
  final int price; 
  final String priceType;
  final String link;


  VenueModel({
    required this.category,
    required this.description,
    required this.location,
    required this.name,
    required this.photo,
    required this.place,
    required this.contact,
    required this.rating, 
    required this.capacity, 
    required this.price, 
    required this.priceType, 
    required this.link, 
  });

  factory VenueModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return VenueModel(
      category: List<String>.from(data['category'] ?? []),  // Handle as list
      description: data['description'] ?? '',
      location: data['location'] ?? GeoPoint(0, 0),
      name: data['name'] ?? '',
      photo: List<String>.from(data['photo'] ?? []),  // Handle as list
      place: data['place'] ?? '',
      contact: data['contact'] ?? '',
      rating: data['rating']?.toDouble() ?? 0.0,  
      capacity: data['capacity']?.toInt() ?? 0,
      price: data['price']?.toInt() ?? 0,
      priceType: data['price_type'] ?? '',
      link: data['link'] ?? '',
    );
  }
  
}
