import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? profilePicture;
  final String? bio;
  final String? phoneNumber;
  final List<String> followers;
  final List<String> following;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.profilePicture,
    this.bio,
    this.phoneNumber,
    this.followers = const [],
    this.following = const [],
  });

  // Convert a UserModel object to a Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profilePicture': profilePicture,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'followers': followers,
      'following': following,
    };
  }

  // Create a UserModel object from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      username: map['username'],
      email: map['email'],
      profilePicture: map['profilePicture'],
      bio: map['bio'],
      phoneNumber: map['phoneNumber'],
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
    );
  }

  // Save user data to Firestore
  Future<void> saveToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('users').doc(uid).set(this.toMap());
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Update user data in Firestore
  Future<void> updateToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('users').doc(uid).update(this.toMap());
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  // Add copyWith method for easier modification
  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? profilePicture,
    String? bio,
    String? phoneNumber,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}