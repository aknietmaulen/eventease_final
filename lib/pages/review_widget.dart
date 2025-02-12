import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/review_provider.dart';
import '../models/review_model.dart';

class ReviewsSection extends StatefulWidget {
  final String venueName;

  const ReviewsSection({super.key, required this.venueName});

  @override
  _ReviewsSectionState createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 5.0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Add a new review to Firestore
  void _addReview() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You need to be logged in to add a review")),
    );
    return;
  }

  // Try to get the display name; if null, fetch from Firestore
  String username = user.displayName ?? "Anonymous";

  if (username == "Anonymous") {
    // Get user profile from Firestore if available
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') // Ensure you have a 'users' collection in Firestore
        .doc(user.uid)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      username = (userDoc.data() as Map<String, dynamic>)['name'] ?? "Anonymous";
    }
  }

  final review = ReviewModel(
    id: '', // Firestore will auto-generate an ID
    venueName: widget.venueName,
    username: username,
    rating: _rating,
    comment: _commentController.text,
    timestamp: Timestamp.now(),
  );

  await Provider.of<ReviewProvider>(context, listen: false).addReview(review);
  _commentController.clear();
  setState(() {
    _rating = 5.0;
  });
}


  /// UI for adding a review
  Widget _buildAddReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Add Your Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Write a review...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addReview,
              child: Text("Post"),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text("Your rating: ${_rating.toStringAsFixed(1)} ⭐"),
        Slider(
          value: _rating,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: (value) {
            setState(() {
              _rating = value;
            });
          },
        ),
      ],
    );
  }

  /// Build UI for the review section
  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Divider(thickness: 1),
        SizedBox(height: 8),

        // StreamBuilder to display reviews
        StreamBuilder<List<ReviewModel>>(
          stream: reviewProvider.getReviews(widget.venueName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error loading reviews"));
            }

            final reviews = snapshot.data ?? [];

            if (reviews.isEmpty) {
              return Center(child: Text("No reviews yet. Be the first to add one!"));
            }

            return Column(
              children: reviews.map((review) => _reviewTile(review)).toList(),
            );
          },
        ),

        SizedBox(height: 16),
        _buildAddReviewSection(),
      ],
    );
  }

  /// UI for displaying individual review tiles
  Widget _reviewTile(ReviewModel review) {
    final user = FirebaseAuth.instance.currentUser;
    bool isUserReview = user != null && review.username == user.displayName;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: ListTile(
        title: Text(review.username, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("⭐ ${review.rating.toStringAsFixed(1)}"),
            Text(review.comment),
            if (isUserReview)
              Row(
                children: [
                  TextButton(
                    onPressed: () => _editReview(review),
                    child: Text("Edit"),
                  ),
                  TextButton(
                    onPressed: () => _deleteReview(review.id),
                    child: Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Edit a review
  void _editReview(ReviewModel review) {
    TextEditingController editController = TextEditingController(text: review.comment);
    double editRating = review.rating;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Edit Review"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editController,
                    decoration: InputDecoration(hintText: "Edit your review"),
                  ),
                  Slider(
                    min: 1,
                    max: 5,
                    divisions: 4,
                    value: editRating,
                    onChanged: (value) {
                      setDialogState(() {
                        editRating = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                TextButton(
                  onPressed: () async {
                    await Provider.of<ReviewProvider>(context, listen: false)
                        .updateReview(review.id, editController.text.trim(), editRating);
                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Delete a review
  void _deleteReview(String reviewId) async {
    await Provider.of<ReviewProvider>(context, listen: false).deleteReview(reviewId);
  }
}
