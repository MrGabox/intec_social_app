import 'package:intec_social_app/models/comment_model.dart';

class PostModel {
  final String postId;
  final String userId;
  final String username;
  final String? userProfilePic;
  final String? caption;
  final String mediaUrl;
  final String mediaType; // 'image' or 'video'
  final DateTime timestamp;
  final List<String> likes;
  final List<CommentModel> comments;

  PostModel({
    required this.postId,
    required this.userId,
    required this.username,
    this.userProfilePic,
    this.caption,
    required this.mediaUrl,
    required this.mediaType,
    required this.timestamp,
    this.likes = const [],
    this.comments = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'userProfilePic': userProfilePic,
      'caption': caption,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
      'comments': comments.map((comment) => comment.toMap()).toList(),
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'],
      userId: map['userId'],
      username: map['username'],
      userProfilePic: map['userProfilePic'],
      caption: map['caption'],
      mediaUrl: map['mediaUrl'],
      mediaType: map['mediaType'],
      timestamp: DateTime.parse(map['timestamp']),
      likes: List<String>.from(map['likes'] ?? []),
      comments: (map['comments'] as List?)
          ?.map((commentMap) => CommentModel.fromMap(commentMap))
          .toList() ?? [],
    );
  }
}