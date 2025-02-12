import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/review_model.dart';

class ReviewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch reviews for a specific venue
  Stream<List<ReviewModel>> getReviews(String venueName) {
    return _firestore
        .collection('reviews')
        .where('venueName', isEqualTo: venueName)
        // .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return []; // Ensure it returns an empty list instead of null
          }
          return snapshot.docs.map((doc) => ReviewModel.fromMap(doc.id, doc.data())).toList();
        });
  }

  // Add a new review
  Future<void> addReview(ReviewModel review) async {
    await _firestore.collection('reviews').add(review.toMap());
  }

  // Edit an existing review
  Future<void> updateReview(String reviewId, String comment, double rating) async {
    await _firestore.collection('reviews').doc(reviewId).update({
      'comment': comment,
      'rating': rating,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Delete a review
  Future<void> deleteReview(String reviewId) async {
    await _firestore.collection('reviews').doc(reviewId).delete();
  }
}
