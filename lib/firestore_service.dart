import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intec_social_app/models/comment_model.dart';
import 'package:intec_social_app/models/post_model.dart';
import 'package:intec_social_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User Operations
  Future<void> createUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? UserModel.fromMap(doc.data()!) : null;
  }

  // Upload Profile Picture
  Future<String?> uploadProfilePicture(String uid, XFile imageFile) async {
    try {
      final ref = _storage.ref().child('profile_pictures').child('$uid.jpg');
      await ref.putFile(File(imageFile.path));
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  // Post Operations
  Future<PostModel> createPost({
    required String userId,
    required XFile mediaFile,
    String? caption
  }) async {
    final postId = Uuid().v4();
    final user = await getUserProfile(userId);

    // Upload media
    final mediaRef = _storage.ref().child('posts').child('$postId');
    await mediaRef.putFile(File(mediaFile.path));
    final mediaUrl = await mediaRef.getDownloadURL();

    final post = PostModel(
      postId: postId,
      userId: userId,
      username: user?.username ?? 'Unknown',
      userProfilePic: user?.profilePicture,
      caption: caption,
      mediaUrl: mediaUrl,
      mediaType: mediaFile.path.toLowerCase().endsWith('mp4') ? 'video' : 'image',
      timestamp: DateTime.now(),
    );

    await _firestore.collection('posts').doc(postId).set(post.toMap());
    return post;
  }

  // Get Feed Posts
  Stream<List<PostModel>> getFeedPosts(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isNotEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data()))
        .toList());
  }

  // Like Post
  Future<void> likePost(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);
    await postRef.update({
      'likes': FieldValue.arrayUnion([userId])
    });
  }

  // Add Comment
  Future<CommentModel> addComment({
    required String postId,
    required String userId,
    required String text
  }) async {
    final user = await getUserProfile(userId);
    final commentId = Uuid().v4();

    final comment = CommentModel(
      commentId: commentId,
      userId: userId,
      username: user?.username ?? 'Unknown',
      userProfilePic: user?.profilePicture,
      text: text,
      timestamp: DateTime.now(),
    );

    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set(comment.toMap());

    return comment;
  }

  // Like Comment
  Future<void> likeComment(String postId, String commentId, String userId) async {
    final commentRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);

    await commentRef.update({
      'likes': FieldValue.arrayUnion([userId])
    });
  }

  // Follow/Unfollow User
  Future<void> followUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('users').doc(currentUserId).update({
      'following': FieldValue.arrayUnion([targetUserId])
    });

    await _firestore.collection('users').doc(targetUserId).update({
      'followers': FieldValue.arrayUnion([currentUserId])
    });
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    await _firestore.collection('users').doc(currentUserId).update({
      'following': FieldValue.arrayRemove([targetUserId])
    });

    await _firestore.collection('users').doc(targetUserId).update({
      'followers': FieldValue.arrayRemove([currentUserId])
    });
  }
}