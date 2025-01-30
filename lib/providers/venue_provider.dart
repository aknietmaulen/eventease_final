import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eventease_final/models/venue_model.dart';  // Ensure you import your VenueModel here

class VenueProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<VenueModel> _venues = [];

  List<VenueModel> get venues => _venues;

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

  // Optionally, you can add a function to fetch a single venue by ID
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
}
