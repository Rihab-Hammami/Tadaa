import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_view/story_view.dart'; // Import story_view package
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'package:tadaa/features/story_page/domain/repositories/storyRepository.dart'; // Import StoryRepository
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart'; // Make sure to import rxdart

class StoryItemWidget extends StatefulWidget {
  final List<StoryModel> stories; // Use list of stories from the same user
  final VoidCallback onClose;
  final String currentUserId; // Current user ID to pass to viewStory method

  const StoryItemWidget({
    Key? key,
    required this.stories,
    required this.onClose,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _StoryItemWidgetState createState() => _StoryItemWidgetState();
}

class _StoryItemWidgetState extends State<StoryItemWidget> {
  late StoryController _storyController;
  String userName = 'Unknown User';
  String userProfileUrl = ''; // Initialize with empty string
  late StoryRepository _storyRepository; // Declare StoryRepository

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();

    // Initialize StoryRepository
    _storyRepository = StoryRepository(
      walletRepository: RepositoryProvider.of<WalletRepository>(context), // Get WalletRepository instance
      notificationRepository: RepositoryProvider.of<NotificationRepository>(context), // Get NotificationRepository instance
      profileBloc: BlocProvider.of<ProfileBloc>(context), // Get ProfileBloc instance
    );

    _fetchUserProfile();
    _markStoryAsViewed(); // Mark the first story as viewed
    
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  void _fetchUserProfile() async {
    if (widget.stories.isNotEmpty) {
      try {
        final userProfile = await ProfileRepository().getUserProfile(widget.stories[0].userId);
        setState(() {
          userName = userProfile.name; // Fallback if name is null
          userProfileUrl = userProfile.profilePicture ?? ''; // Default to empty if null
        });
      } catch (e) {
        print('Error fetching user profile: $e');
      }
    }
  }

  void _markStoryAsViewed() async {
    // Ensure there is at least one story to view
    if (widget.stories.isNotEmpty) {
      try {
        // Call the viewStory method to mark the story as viewed
        await _storyRepository.viewStory(widget.stories[0].storyId, widget.currentUserId);
      } catch (e) {
        print('Error viewing story: $e');
      }
    }
  }

  String _timeElapsed(DateTime? createdAt) {
    if (createdAt == null) return 'Just now'; 
    final duration = DateTime.now().difference(createdAt);
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds} seconds ago';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours ago';
    } else {
      return '${duration.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StoryView(
          storyItems: widget.stories.map((story) {
            switch (story.mediaType) {
              case MediaType.image:
                return StoryItem.inlineImage(
                  imageFit: BoxFit.contain,
                  url: story.mediaUrl,
                  controller: _storyController,
                  caption: Text(
                    story.caption?.isNotEmpty == true ? story.caption! : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.5,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              case MediaType.video:
                return StoryItem.pageVideo(
                  story.mediaUrl,
                  controller: _storyController,
                  caption: Text(
                    story.caption ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              case MediaType.text:
              default:
                return StoryItem.text(
                  title: story.caption ?? '',
                  backgroundColor: Colors.black,
                );
            }
          }).toList(),
          controller: _storyController,
          onComplete: () {
            widget.onClose(); // Close the story when all are viewed
          },
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              widget.onClose(); // Close the story when swiped down
            }
          },
          repeat: false, // Prevent looping of the story
        ),

        // Display user profile image and name
        Positioned(
          top: 50,
          left: 10,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: userProfileUrl.isNotEmpty
                    ? NetworkImage(userProfileUrl)
                    : AssetImage('assets/images/profile.jpg') as ImageProvider,
                radius: 20,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName.isNotEmpty ? userName : 'Unknown User',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    _timeElapsed(widget.stories[0].createdAt), // Time of the first story
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Close button
        Positioned(
          top: 50,
          right: 40,
          child: IconButton(
            onPressed: widget.onClose,
            icon: Icon(Icons.close, color: Colors.white, size: 25),
          ),
        ),

        // More options button (can be extended with functionality)
        Positioned(
          top: 50,
          right: 10,
          child: IconButton(
            onPressed: () {
              
            }, // Add functionality if needed
            icon: Icon(Icons.more_vert, color: Colors.white, size: 25),
          ),
        ),

        // Only show the view count if the current user is the owner of the story
        if (widget.stories[0].userId == widget.currentUserId)
          Positioned(
            bottom: 30,
            left: 10,
            child: Row(
              children: [
                Icon(Icons.visibility, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  '${widget.stories[0].views.length}', // Display view count
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
 
}
