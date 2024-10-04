import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';

class StoryPage extends StatefulWidget {
  final List<List<StoryModel>> allStories; // List of stories for each user
  final List<UserModel> users; // List of users
  final int initialUserIndex; // Initial index of the user whose story to display

  const StoryPage({
    Key? key,
    required this.allStories,
    required this.users,
    this.initialUserIndex = 0,
  }) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late StoryController _storyController;
  late List<StoryItem> _storyItems;
  int _currentUserIndex = 0; // Current user's index in the list

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();
    _currentUserIndex = widget.initialUserIndex;
    _loadStoriesForUser(_currentUserIndex); // Load the stories for the initial user
  }

  @override
  void dispose() {
    _storyController.dispose(); // Dispose the controller properly
    super.dispose();
  }

  // Load stories for a specific user
  void _loadStoriesForUser(int userIndex) {
    if (userIndex < 0 || userIndex >= widget.allStories.length) {
      print("Invalid user index: $userIndex");
      return; 
    }

    setState(() {
      _storyItems = widget.allStories[userIndex].map((story) {
        switch (story.mediaType) {
          case MediaType.image:
            return StoryItem.inlineImage(
              url: story.mediaUrl,
              imageFit: BoxFit.contain,
              controller: _storyController,
              caption: Text(
                story.caption,
                style: TextStyle(color: Colors.white, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            );
          case MediaType.video:
            return StoryItem.pageVideo(
              story.mediaUrl,
              controller: _storyController,
              caption: Text(
                story.caption,
                style: TextStyle(color: Colors.white),
              ),
            );
          case MediaType.text:
          default:
            return StoryItem.text(
              title: story.caption,
              backgroundColor: Colors.black,
              textStyle: TextStyle(color: Colors.white),
            );
        }
      }).toList();
    });
    print("Loaded stories for user index: $userIndex");
  }

  // Move to the next user's story
  void _moveToNextUser() {
    if (_currentUserIndex < widget.users.length - 1) {
      setState(() {
        _currentUserIndex++;
        _loadStoriesForUser(_currentUserIndex); // Load the stories for the next user
      });
    } else {
      Navigator.pop(context); // Close the story if there are no more users
    }
  }

  // Handle swipe to move to the next user
  void _onHorizontalSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) 
    return;

    // Detect swipe direction
    if (details.primaryVelocity! < 0) {
      _moveToNextUser(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onHorizontalSwipe, // Detect horizontal swipe gestures
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 20) {
          // Optional: handle right swipe (e.g., go back)
        } else if (details.delta.dx < -20) {
          _moveToNextUser(); // Move to the next user on swipe left
        }
      },
      child: Stack(
        children: [
          StoryView(
            storyItems: _storyItems,
            controller: _storyController,
            onComplete: _moveToNextUser,
            onVerticalSwipeComplete: (direction) {
              if (direction == Direction.down) {
                Navigator.pop(context); 
              }
            },
          ),
          
          Positioned(
            top: 40,
            left: 10,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.users[_currentUserIndex].profilePicture != null
                      ? NetworkImage(widget.users[_currentUserIndex].profilePicture!)
                      : AssetImage('assets/images/profile.jpg') as ImageProvider,
                  radius: 20,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.users[_currentUserIndex].name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _timeElapsed(widget.allStories[_currentUserIndex].isNotEmpty
                          ? widget.allStories[_currentUserIndex][_storyItems.length - 1].createdAt
                          : null),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Close button at the top-right corner
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context); // Close the story page
              },
              icon: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Format the time elapsed for the story
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
}
