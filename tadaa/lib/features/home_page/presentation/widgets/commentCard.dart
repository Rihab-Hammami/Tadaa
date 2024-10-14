import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tadaa/features/addPost_page/data/models/Comment.dart'; // Make sure to import your CommentModel

class CommentCard extends StatefulWidget {
  final CommentModel comment; // Pass the CommentModel
  final String profilePicture; // Profile picture URL
  final String name; // Name of the user
  final VoidCallback onDelete; // Callback for delete action
  final VoidCallback onUpdate; // Callback for update action
  final Function(String, String) onLike; // Callback for like action
  final String userId; // ID of the user liking the comment
  final String postOwnerId; 
  const CommentCard({
    Key? key,
    required this.comment, // Accept CommentModel
    required this.profilePicture,
    required this.name,
    required this.onDelete,
    required this.onUpdate,
    required this.onLike,
    required this.userId, 
    required this.postOwnerId, // ID of the user
  }) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late bool _isLiked;
  int likeCount = 0;
 
  @override
  void initState() {
    super.initState();
    _isLiked = widget.comment.likes.contains(widget.userId); 
    likeCount = widget.comment.likes.length; // No need for null check, as likes will be initialized
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked; // Toggle the liked state
      likeCount += _isLiked ? 1 : -1;
    });
    widget.onLike(widget.comment.id, widget.userId); // Call the like action
  }

  @override
  Widget build(BuildContext context) {
    final bool isCommentOwner = widget.comment.userId == widget.userId;
    final bool isPostOwner=widget.postOwnerId==widget.userId;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.profilePicture),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${widget.name} ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: widget.comment.commentText, // Access comment text from CommentModel
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(widget.comment.createdAt), // Access createdAt from CommentModel
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              // Text showing the like count
              Text(
                '$likeCount',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w800),
              ),
              // No Padding or SizedBox added
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                  color: _isLiked ? Colors.red : Colors.black,
                ),
                onPressed: _toggleLike, // Handle like action
              ),
              // No Padding or SizedBox added
              
            
                if (isCommentOwner || isPostOwner) // Show menu if comment owner or post owner
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      widget.onDelete(); // Trigger delete action
                    } else if (value == 'update' && isCommentOwner) {
                      widget.onUpdate(); // Trigger update action only if the current user is the comment owner
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    // Conditional items based on ownership
                    if (isPostOwner && isCommentOwner) {
                      // If the user is both the post owner and the comment owner
                      return [
                        const PopupMenuItem(value: 'update', child: Text('Update')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ];
                    } else if (isPostOwner) {
                      // If the user is only the post owner
                      return [
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ];
                    } else if (isCommentOwner) {
                      // If the user is only the comment owner
                      return [
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        const PopupMenuItem(value: 'update', child: Text('Update')),
                      ];
                    }
                    return []; 
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    size: 16,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
