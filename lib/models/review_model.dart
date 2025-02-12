import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String venueName;
  final String username;
  final double rating;
  final String comment;
  final Timestamp timestamp;

  ReviewModel({
    required this.id,
    required this.venueName,
    required this.username,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  // Convert Firestore document to ReviewModel
  factory ReviewModel.fromMap(String id, Map<String, dynamic> data) {
    return ReviewModel(
      id: id,
      venueName: data['venueName'] ?? '',
      username: data['userName'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      comment: data['comment'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert ReviewModel to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'venueName': venueName,
      'userName': username,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}
