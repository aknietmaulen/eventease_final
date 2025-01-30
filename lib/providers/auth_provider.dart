import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize Firestore
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Updated register method to include name and profile image URL
  Future<String?> register(String name, String email, String password, String profileURL) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user information to Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
        'profileURL': profileURL, // Save profile image URL
      });

      return "Successful registration!";
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  // Retrieve user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    if (_user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(_user?.uid).get();
      return snapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }

  // Update user information in Firestore
  Future<void> updateUser(String name, String password) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final docRef = _firestore.collection('users').doc(uid);
      await docRef.update({
        'name': name,
        'password': password,
      });

      // Update password if provided
      if (password.isNotEmpty) {
        await user.updatePassword(password);
      }
    }
  }
  Future<void> updateImageURL(String imageURL) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profileURL': imageURL,
      });
    }
  }


  Future<void> logout() async {
    await _auth.signOut();
  }
}
