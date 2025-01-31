import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventease_final/models/venue_model.dart';  // Ensure you import your VenueModel here
class VenueProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<VenueModel> _venues = [];
  List<VenueModel> get venues => _venues;

  List<VenueModel> _filteredVenues = []; // For filtered events based on category and search
  List<VenueModel> get filteredVenues => _filteredVenues;

  // Fetch venues from Firestore
  Future<void> fetchVenues() async {
    try {
      final querySnapshot = await _db.collection('venues').get();

      // Map Firestore documents to VenueModel
      _venues = querySnapshot.docs.map((doc) {
        return VenueModel.fromFirestore(doc);
      }).toList();

      notifyListeners();  // Notify listeners when the data is fetched
    } catch (error) {
      throw Exception('Failed to load venues: $error');
    }
  }

  // Fetch a single venue by ID
  Future<VenueModel> fetchVenueById(String venueId) async {
    try {
      final docSnapshot = await _db.collection('venues').doc(venueId).get();

      if (docSnapshot.exists) {
        return VenueModel.fromFirestore(docSnapshot);
      } else {
        throw Exception('Venue not found');
      }
    } catch (error) {
      throw Exception('Failed to fetch venue: $error');
    }
  }

  // Fetch venues by category
  Future<List<VenueModel>> fetchVenuesByCategory(String category) async {
    try {
      final querySnapshot = await _db.collection('venues')
          .where('categories', arrayContains: category) // Firestore array query
          .get();

      return querySnapshot.docs.map((doc) => VenueModel.fromFirestore(doc)).toList();
    } catch (error) {
      throw Exception('Failed to fetch venues by category: $error');
    }
  }

  // Fetch popular venues based on a rating of 4.7/5 or higher
  Future<List<VenueModel>> fetchPopularVenues() async {
    try {
      final querySnapshot = await _db.collection('venues')
          .where('rating', isGreaterThanOrEqualTo: 4.6) // Query for venues with a rating of 4.7 or higher
          .get();

      return querySnapshot.docs.map((doc) => VenueModel.fromFirestore(doc)).toList();
    } catch (error) {
      throw Exception('Failed to fetch popular venues: $error');
    }
  }

  Future<List<VenueModel>> searchVenues(String query) async {
    if (query.isEmpty) {
      return _venues; // Return all venues if no search query
    }
    final lowerCaseQuery = query.toLowerCase();
    return _venues.where((venue) =>
      venue.name.toLowerCase().contains(lowerCaseQuery) ||
      venue.category.any((cat) => cat.toLowerCase().contains(lowerCaseQuery))
    ).toList();
  }
}
