import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostBloc.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostEvent.dart';
import 'package:tadaa/features/addPost_page/presentation/pages/appreciationPage.dart';
import 'package:tadaa/features/home_page/presentation/widgets/commentWidget.dart';
import 'package:tadaa/features/home_page/presentation/widgets/likedUsersModel.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';


class AppreciationPostWidget extends StatefulWidget {
  final PostModel post;
  final ProfileRepository profileRepository;
  final PostRepository postRepository;
  final String currentUserId;

   const AppreciationPostWidget({
    Key? key,
    required this.post,
    required this.profileRepository,
    required this.postRepository,
    required this.currentUserId,
  }) : super(key: key);
  
  @override
  State<AppreciationPostWidget> createState() => _AppreciationPostWidgetState();
}

class _AppreciationPostWidgetState extends State<AppreciationPostWidget> {
   bool isLiked = false;
  int likeCount = 0;
  late Future<UserModel> _userFuture;
  late Future<Map<String, String>> _taggedUsersFuture;
  late Future<int> _commentCountFuture;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes?.length ?? 0;
    isLiked = widget.post.likes?.contains(widget.currentUserId) ?? false;
    _userFuture = widget.profileRepository.getUserProfile(widget.post.userId);
    _taggedUsersFuture = _fetchTaggedUsers();
    _commentCountFuture = widget.postRepository.getCommentCount(widget.post.postId);

  }
   void _refreshCommentCount() {
    setState(() {
      _commentCountFuture = widget.postRepository.getCommentCount(widget.post.postId);
    });
  }

  Future<Map<String, String>> _fetchTaggedUsers() async {
    final taggedUsersMap = <String, String>{};
    if (widget.post.taggedUsers != null && widget.post.taggedUsers!.isNotEmpty) {
      for (final userId in widget.post.taggedUsers!) {
        try {
          final user = await widget.profileRepository.getUserProfile(userId);
          taggedUsersMap[userId] = user.name ?? 'Unknown';
        } catch (e) {
          taggedUsersMap[userId] = 'Unknown';
        }
      }
    }
    return taggedUsersMap;
  }

  /*void _handleLikePost() async {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
    widget.postRepository.likePost(widget.post.postId, widget.currentUserId);
  }*/
  void _handleLikePost() async {
  setState(() {
    if (isLiked) {
      widget.post.likes?.remove(widget.currentUserId); // Remove current user from likes list
    } else {
      widget.post.likes?.add(widget.currentUserId); // Add current user to likes list
    }
    isLiked = !isLiked; // Toggle liked state
    likeCount = widget.post.likes?.length ?? 0; // Update the like count based on the updated list
  });
  
  // Call the repository to update the like status in the backend
  widget.postRepository.likePost(widget.post.postId, widget.currentUserId);
}

  void _showBottomSheet() {
     if (widget.post.userId != widget.currentUserId) {
      return; // Don't show bottom sheet if not the owner of the post.
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Update'),
                onTap: () {
                  Navigator.of(context).pop(); 
                  Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppreciationPage(initialPost: widget.post),
                  ),
                );
              },
            ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  _handleDeletePost();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleDeletePost() async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    try {
      // Dispatch the DeletePostEvent to PostBloc
      BlocProvider.of<PostBloc>(context).add(DeletePostEvent(widget.post.postId));

      // Show a success message or handle UI updates here if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $e')),
      );
    }
  }
}
 
  @override
  Widget build(BuildContext context) {
    
    final width = MediaQuery.of(context).size.width;
     bool isLikeAnimating = false;

   

    return FutureBuilder<UserModel>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final user = snapshot.data!;
      return Container(
        // boundary needed for web
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            // HEADER SECTION OF THE POST
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: user.profilePicture != null
                        ? Image.network(
                            user.profilePicture!,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/profile.jpg", // Default profile image
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                  ),
                  ),
                 Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 4.0,
                              runSpacing: 2.0,
                              children: [
                                Text(
                                  user.name ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FutureBuilder<Map<String, String>>(
                                  future: _taggedUsersFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const SizedBox.shrink();
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    }

                               final taggedUsers = snapshot.data!;
                              return taggedUsers.isNotEmpty
                              ? Row(
                                  children: [
                                    Icon(Icons.label_important_sharp, size: 15, color: Colors.grey),
                                    const SizedBox(width: 3),
                                    // Get the list of user names
                                    if (taggedUsers.length > 0) 
                                      Padding(
                                        padding: const EdgeInsets.only(right: 4),
                                        child: Text(
                                          taggedUsers.entries.first.value, // Display the first user
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    // If there are more than 1 tagged users, show the count of additional users
                                    if (taggedUsers.length > 1) 
                                      GestureDetector(
                                        onTap: () {
                                          // Show the dialog or bottom sheet with the list of users
                                          _showTaggedUsersDialog(context, taggedUsers);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 4),
                                          child: Text(
                                            '+${taggedUsers.length - 1}', // Display the count of additional users
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              : const SizedBox.shrink();

                                  },
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                DateFormat.yMMMd().format(widget.post.createdAt ?? DateTime.now()),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.post.userId == widget.currentUserId)
                    IconButton(
                      onPressed: _showBottomSheet,
                      icon: const Icon(Icons.more_vert),
                    ),
                ],
              ),
              
            ),
            // IMAGE SECTION OF THE POST
            const SizedBox(height: 5,),
            GestureDetector(
             
              
            child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 2,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      // Define all borders, but only apply color to the top
                      border: Border(
                        top: BorderSide(color: const Color.fromARGB(255, 253, 87, 75), width: 7), // Top border
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //Icon(Icons.flag, color: Colors.red),
                            Container(
                            padding: EdgeInsets.all(8), // Add padding inside the border
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 253, 87, 75), // Background color of the container
                              //border: Border.all(color: Colors.red, width: 2), // Border color and width
                              borderRadius: BorderRadius.circular(12), // Rounded corners for the border
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),

                           SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                 widget.post.action!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                           widget.post.content,
                           style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Points Badge
              Positioned(
                //bottom: 100,
                //top: -5,
                right: 30,   // Adjust the right position if needed
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.red), // Border for points badge
                  ),
                  child: Row(
                    children: [                    
                      Icon(Icons.card_giftcard,
                          color: Colors.yellow.shade700, size: 18),
                      SizedBox(width: 4),
                      Text(
                         widget.post.points?.toString() ?? '0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      
      
            ),
            // LIKE, COMMENT SECTION OF THE POST
             Row(
                children: <Widget>[
                  IconButton(
                    icon: isLiked
                        ? const Icon(Icons.favorite, size: 30, color: Colors.red)
                        : const Icon(Icons.favorite_border, size: 30),
                    onPressed: _handleLikePost,
                  ),
                  if (likeCount > 0) 
                  GestureDetector(
                    onTap: () async {
                 // Fetch liked users
                  List<Map<String, dynamic>> likedUsers = await widget.postRepository.fetchLikedUsers(widget.post.likes ?? []);

                  // Show the modal with the liked users list
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return LikedUsersModal(likedUsers: likedUsers);
                    },
                  );
                },
                    child: Text(
                    '$likeCount ',
                     style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w800),),
                  ),
                   FutureBuilder<int>(
                    future: _commentCountFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink(); // Placeholder while loading
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Handle errors gracefully
                      }
                      final commentCount = snapshot.data ?? 0; // Fallback to 0 if no data
                      return Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.comment_outlined, size: 30),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentsWidget(
                                    postId: widget.post.postId,
                                    profileRepository: widget.profileRepository,
                                    postRepository: widget.postRepository,
                                    onCommentAdded: _refreshCommentCount,
                                  ),
                                ),
                              );
                            },
                          ),
                          if (commentCount > 0) 
                          Text(
                            '$commentCount', // Display the count of comments
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
           
            
        ]
        ));
  });
  }
}
void _showTaggedUsersDialog(BuildContext context, Map<String, String> taggedUsers) {
  // Get a list of tagged users
  final List<String> userNames = taggedUsers.values.toList();

  // Create a list of additional users (excluding the first one)
  final List<String> additionalUsers = userNames.length > 1 ? userNames.sublist(1) : [];

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Set the background color to white
        title: Text(
          'Tagged Users',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.blue),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: additionalUsers.map((userName) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8), // Space between usernames
                ],
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close',style: TextStyle(color: Colors.blue),),
          ),
        ],
      );
    },
  );
}
