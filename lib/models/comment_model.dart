class CommentModel {
  final String commentId;
  final String userId;
  final String username;
  final String? userProfilePic;
  final String text;
  final DateTime timestamp;
  final List<String> likes;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.username,
    this.userProfilePic,
    required this.text,
    required this.timestamp,
    this.likes = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'username': username,
      'userProfilePic': userProfilePic,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'],
      userId: map['userId'],
      username: map['username'],
      userProfilePic: map['userProfilePic'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
      likes: List<String>.from(map['likes'] ?? []),
    );
  }
}