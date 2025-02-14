import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventease_final/models/service_provider_model.dart';  // Ensure you import your model here

class ServiceProviderProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ServiceProviderModel> _serviceProviders = [];
  List<ServiceProviderModel> get serviceProviders => _serviceProviders;

  List<ServiceProviderModel> _filteredServiceProviders = []; // For filtered services based on category and search
  List<ServiceProviderModel> get filteredServiceProviders => _filteredServiceProviders;

  // Fetch service providers from Firestore
  Future<void> fetchServiceProviders() async {
    try {
      final querySnapshot = await _db.collection('serviceProviders').get();

      // Map Firestore documents to ServiceProviderModel
      _serviceProviders = querySnapshot.docs.map((doc) {
        return ServiceProviderModel.fromFirestore(doc);
      }).toList();

      notifyListeners();  // Notify listeners when the data is fetched
    } catch (error) {
      throw Exception('Failed to load service providers: $error');
    }
  }

  // Fetch service providers by category
  Future<List<ServiceProviderModel>> fetchServiceProvidersByCategory(String category) async {
    try {
      final querySnapshot = await _db.collection('service_providers')
          .where('category', arrayContains: category) // Firestore array query
          .get();

      return querySnapshot.docs.map((doc) => ServiceProviderModel.fromFirestore(doc)).toList();
    } catch (error) {
      throw Exception('Failed to fetch service providers by category: $error');
    }
  }

  Future<List<ServiceProviderModel>> searchServiceProviders(String query) async {
    if (query.isEmpty) {
      return _serviceProviders; // Return all service providers if no search query
    }
    final lowerCaseQuery = query.toLowerCase();
    return _serviceProviders.where((provider) =>
      provider.name.toLowerCase().contains(lowerCaseQuery) ||
      provider.services.any((cat) => cat.toLowerCase().contains(lowerCaseQuery))
    ).toList();
  }
}
