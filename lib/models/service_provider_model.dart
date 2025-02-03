import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderModel {
  final String name;
  final String description;
  final List<String> services; // Specific services offered
  final List<String> photos; // Portfolio images or work samples
  final String contact;
  final String price;
 

  ServiceProviderModel({
    required this.name,
    required this.description,
    required this.services,
    required this.photos,
    required this.contact,
    required this.price,
  });

  factory ServiceProviderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ServiceProviderModel(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      services: List<String>.from(data['category'] ?? []),
      photos: List<String>.from(data['photo'] ?? []),
      contact: data['contact'] ?? '',
      price: data['price'] ?? '',
    );
  }
}
