import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';

class StoryItemWidget extends StatefulWidget {
  final List<StoryModel> stories;
  final VoidCallback onClose;
  final String currentUserId;
  final String userName; // User name for display
  final String userProfilePicture; // User profile picture for display

  const StoryItemWidget({
    Key? key,
    required this.stories,
    required this.onClose,
    required this.currentUserId,
    required this.userName, // Required for displaying user info
    required this.userProfilePicture, // Required for displaying user profile
  }) : super(key: key);

  @override
  _StoryItemWidgetState createState() => _StoryItemWidgetState();
}

class _StoryItemWidgetState extends State<StoryItemWidget> {
  late StoryController _storyController;
  int _currentStoryIndex = 0; // Keep track of the current story index

  @override
  void initState() {
    super.initState();
    _storyController = StoryController();
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  void _moveToNextStory() {
    if (_currentStoryIndex < widget.stories.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
    } else {
      // Close the story view if all stories have been viewed
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StoryView(
          storyItems: widget.stories.map((story) {
            if (story.mediaType == MediaType.image) {
              return StoryItem.inlineImage(
                imageFit: BoxFit.contain,
                url: story.mediaUrl,
                controller: _storyController,
                caption: Text(
                  story.caption ?? '',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return StoryItem.pageVideo(
                story.mediaUrl,
                controller: _storyController,
                caption: Text(
                  story.caption ?? '',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          }).toList(),
          controller: _storyController,
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pop(context); // Close the story when swiped down
            }
          },
          onComplete: () {
            // This callback is called when the story completes
            _moveToNextStory();
          },
          
        ),
        // User info header
        Positioned(
          top: 40,
          left: 10,
          right: 10,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userProfilePicture),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    formatStoryTime(widget.stories.first.createdAt),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                   Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String formatStoryTime(DateTime createdAt) {
  if (createdAt == null) return 'Just now'; 
  final difference = DateTime.now().difference(createdAt);
   if (difference.inSeconds < 60) {
    return '${difference.inSeconds}s ago';
  }
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inDays}day ago';
  }
}
