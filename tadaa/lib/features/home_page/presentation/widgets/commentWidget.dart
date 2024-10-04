import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:tadaa/features/addPost_page/data/models/Comment.dart';
import 'package:tadaa/features/home_page/presentation/widgets/commentCard.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';

class CommentsWidget extends StatefulWidget {
  final String postId;
  final ProfileRepository profileRepository;
  final PostRepository postRepository;
  final Function onCommentAdded;

  const CommentsWidget({
    Key? key,
    required this.postId,
    required this.profileRepository,
    required this.postRepository,
    required this.onCommentAdded,
  }) : super(key: key);

  @override
  _CommentsWidgetState createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final TextEditingController commentEditingController = TextEditingController();
  late Future<List<CommentModel>> _commentsFuture;
  int likeCommentCount = 0;
  @override
  void initState() {
    super.initState();
    _commentsFuture = widget.postRepository.fetchComments(widget.postId);
   
  }

  void _deleteComment(CommentModel comment) async {
    try {
      await widget.postRepository.deleteComment(widget.postId, comment.id.toString());
      setState(() {
        _commentsFuture = widget.postRepository.fetchComments(widget.postId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete comment: $e')),
      );
    }
  }

  void _showUpdateDialog(CommentModel comment) {
    final TextEditingController updateController = TextEditingController(text: comment.commentText);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Comment'),
          content: TextField(
            controller: updateController,
            decoration: const InputDecoration(hintText: "Edit your comment"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                _updateComment(comment, updateController.text.trim());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateComment(CommentModel comment, String updatedText) async {
    if (updatedText.isEmpty) return;

    try {
      print('Updating comment: ${comment.id} with text: $updatedText');
      await widget.postRepository.updateComment(widget.postId, comment.id, updatedText);
      setState(() {
        _commentsFuture = widget.postRepository.fetchComments(widget.postId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update comment: $e')),
      );
    }
  }

  void _postComment(UserModel user) async {
    final commentText = commentEditingController.text.trim();

    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
      return;
    }

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Ensure unique ID
      commentText: commentText,
      userId: user.uid,
      createdAt: DateTime.now(),
    );

    try {
      await widget.postRepository.addComment(widget.postId, newComment, user.uid);
      widget.onCommentAdded(); // Notify parent about new comment
      commentEditingController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment posted')),
      );

      setState(() {
        _commentsFuture = widget.postRepository.fetchComments(widget.postId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment: $e')),
      );
    }
  }

  Future<UserModel> _fetchUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String userId = currentUser.uid;
      return await widget.profileRepository.getUserProfile(userId);
    }
    throw Exception('No user is logged in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: FutureBuilder<List<CommentModel>>(
        future: _commentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comments available'));
          }

          final comments = snapshot.data!;

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return FutureBuilder<UserModel>(
                future: widget.profileRepository.getUserProfile(comment.userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  }
                  if (!userSnapshot.hasData) {
                    return const Center(child: Text('No user data available'));
                  }

                  final user = userSnapshot.data!;
                  return CommentCard(
                  comment: comment, // Pass the CommentModel
                  profilePicture: user.profilePicture ?? 'https://example.com/default-profile.jpg', // Pass profile picture URL
                  name: user.name ?? 'Anonymous', // Pass user name
                  onDelete: () => _deleteComment(comment),
                  onUpdate: () => _showUpdateDialog(comment),
                  onLike: (commentId, userId) => _likeComment(commentId, userId),
                  userId: user.uid, // Pass user ID for liking
                );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<UserModel>(
        future: _fetchUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No user data available'));
          }

          final user = snapshot.data!;
          return SafeArea(
            child: Container(
              height: kToolbarHeight,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.profilePicture ?? 'https://example.com/default-profile.jpg',
                    ),
                    radius: 18,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: TextField(
                        controller: commentEditingController,
                        decoration: InputDecoration(
                          hintText: 'Comment as ${user.username}',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _postComment(user);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: const Text('Post', style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Implementing the like comment function
  void _likeComment(String commentId, String userId) async {
    try {
      final result = await widget.postRepository.likeComment(widget.postId, commentId, userId);
      if (result == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment liked')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to like comment: $result')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error liking comment: $e')),
      );
    }
  }
}
