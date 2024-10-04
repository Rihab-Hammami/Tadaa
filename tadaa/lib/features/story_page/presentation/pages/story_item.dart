import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_view/story_view.dart'; // Import story_view package
import 'package:tadaa/Data/stories.dart';
import 'package:tadaa/core/utils/assets_manager.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'package:tadaa/features/story_page/domain/repositories/storyRepository.dart'; // Import StoryRepository
import 'package:rxdart/rxdart.dart';
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
  int _currentStoryIndex = 0; // Track the current story index

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();

    // Listen to playback state changes
    _storyController.playbackNotifier.listen((state) {
      if (state == PlaybackState.next) {
        if (_currentStoryIndex < widget.stories.length - 1) {
          setState(() {
            _currentStoryIndex++; // Move to the next story
          });
        } else {
          widget.onClose(); // Close when reaching the end of stories
        }
      } else if (state == PlaybackState.previous) {
        if (_currentStoryIndex > 0) {
          setState(() {
            _currentStoryIndex--; 
          });
        }
      }
    });

   _storyRepository = StoryRepository(
  walletRepository: RepositoryProvider.of<WalletRepository>(context),         // Get WalletRepository instance
  notificationRepository: RepositoryProvider.of<NotificationRepository>(context), // Get NotificationRepository instance
  profileBloc: BlocProvider.of<ProfileBloc>(context),                          // Get ProfileBloc instance
);// Initialize StoryRepository
    _fetchUserProfile();
    _markStoryAsViewed(); // Mark the story as viewed when initialized
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  void _fetchUserProfile() async {
    if (widget.stories.isNotEmpty) {
      try {
        final userProfile = await ProfileRepository().getUserProfile(widget.stories[_currentStoryIndex].userId);
       
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
    if (createdAt == null) return 'Just now'; // Fallback if createdAt is null
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
    StoryModel currentStory = widget.stories[_currentStoryIndex]; // Get the current story

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
                    story.caption,
                    style: TextStyle(decoration: TextDecoration.none),
                  ),
                );
              case MediaType.text:
              default:
                return StoryItem.text(
                  title: story.caption,
                  backgroundColor: Colors.black,
                );
            }
          }).toList(),
          controller: _storyController,
          onComplete: () {
            widget.onClose;
          },
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              widget.onClose(); 
            } 
          },
          repeat: false,
        ),

        Positioned(
          top: 40,
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
                    _timeElapsed(currentStory.createdAt), // Using currentStory's createdAt
                    style: TextStyle(color: Colors.white70, fontSize: 12,
                    decoration: TextDecoration.none),
                  ),
                ],
              ),
            ],
          ),
        ),
      
        Positioned(
          top: 40,
          right: 40,
          child: IconButton(
            onPressed: widget.onClose,
            icon: Icon(Icons.close, color: Colors.white, size: 25),
          ),
        ),

        Positioned(
          top: 40,
          right: 10,
          child: IconButton(
            onPressed: () {}, // Add functionality if needed
            icon: Icon(Icons.more_vert, color: Colors.white, size: 25),
          ),
        ),
       /* if (currentStory.userId == widget.currentUserId) // Show views only if current user is the owner of the story
          Positioned(
            bottom: 30,
            left: 10,
            child: Row(
              children: [
                Icon(Icons.visibility, color: Colors.white), 
                SizedBox(width: 5), 
                Text(
                  '${currentStory.views.length}', // Use currentStory for view count
                  style: TextStyle(color: Colors.white, fontSize: 12,
                  decoration: TextDecoration.none),
                ),
              ],
            ),
          ),*/
      ],
    );
  }
}
