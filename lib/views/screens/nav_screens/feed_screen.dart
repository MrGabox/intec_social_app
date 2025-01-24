import 'package:flutter/material.dart';
import 'package:intec_social_app/models/comment_model.dart';
import 'package:intec_social_app/models/post_model.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  // Lista simulada de publicaciones
  List<PostModel> posts = [
    PostModel(
      postId: '1',
      userId: 'user1',
      username: 'User1',
      userProfilePic: 'https://via.placeholder.com/150',
      caption: 'This is a test post #1.',
      mediaUrl: 'https://via.placeholder.com/400x200',
      mediaType: 'image',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      likes: [],
      comments: [
        CommentModel(
          commentId: 'c1',
          userId: 'user2',
          username: 'User2',
          userProfilePic: 'https://via.placeholder.com/150',
          text: 'Great post!',
          timestamp: DateTime.now().subtract(Duration(minutes: 45)),
        ),
      ],
    ),
    PostModel(
      postId: '2',
      userId: 'user2',
      username: 'User2',
      userProfilePic: 'https://via.placeholder.com/150',
      caption: 'This is a test post #2.',
      mediaUrl: 'https://via.placeholder.com/400x200',
      mediaType: 'image',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      likes: ['user1'],
      comments: [],
    ),
  ];

  // Función para alternar likes
  void toggleLike(String postId, String userId) {
    setState(() {
      final post = posts.firstWhere((post) => post.postId == postId);
      if (post.likes.contains(userId)) {
        post.likes.remove(userId);
      } else {
        post.likes.add(userId);
      }
    });
  }

  // Función para añadir un comentario
  void addComment(String postId, String userId, String text) {
    setState(() {
      final post = posts.firstWhere((post) => post.postId == postId);
      post.comments.add(CommentModel(
        commentId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        username: 'CurrentUser', // Simulación del usuario actual
        userProfilePic: 'https://via.placeholder.com/150',
        text: text,
        timestamp: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del usuario y menú
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(post.userProfilePic ?? ''),
                  ),
                  title: Text(post.username),
                  subtitle: Text('${post.timestamp.hour}h ago'),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ),
                // Imagen o video
                Image.network(
                  post.mediaUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                // Botones de interacción
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          post.likes.contains('user1') // Simulación del usuario actual
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: post.likes.contains('user1') ? Colors.red : null,
                        ),
                        onPressed: () {
                          toggleLike(post.postId, 'user1');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => _buildCommentsSection(post),
                          );
                        },
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                // Cantidad de likes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${post.likes.length} likes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Descripción
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('${post.username}: ${post.caption}'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Construye la sección de comentarios
  Widget _buildCommentsSection(PostModel post) {
    final TextEditingController commentController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: post.comments.length,
              itemBuilder: (context, index) {
                final comment = post.comments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                    NetworkImage(comment.userProfilePic ?? ''),
                  ),
                  title: Text(comment.username),
                  subtitle: Text(comment.text),
                );
              },
            ),
          ),
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    addComment(post.postId, 'user1', commentController.text);
                    commentController.clear();
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
