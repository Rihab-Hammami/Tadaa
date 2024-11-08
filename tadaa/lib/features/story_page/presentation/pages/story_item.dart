import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_view/story_view.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'package:tadaa/features/story_page/domain/repositories/storyRepository.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_bloc.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_event.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';

class StoryItemWidget extends StatefulWidget {
  final List<StoryModel> stories;
  final VoidCallback onClose;
  final String currentUserId;
  final String userName;
  final String userProfilePicture;

  const StoryItemWidget({
    Key? key,
    required this.stories,
    required this.onClose,
    required this.currentUserId,
    required this.userName,
    required this.userProfilePicture,
  }) : super(key: key);

  @override
  _StoryItemWidgetState createState() => _StoryItemWidgetState();
}

class _StoryItemWidgetState extends State<StoryItemWidget> {
  late StoryController _storyController;
  int _currentStoryIndex = 0;
  late StoryRepository _storyRepository;
  bool _isLiked= false;
  @override
  void initState() {
    super.initState();
    _storyController = StoryController();
    _storyRepository = StoryRepository(
      walletRepository: RepositoryProvider.of<WalletRepository>(context),
      notificationRepository: RepositoryProvider.of<NotificationRepository>(context),
      profileBloc: BlocProvider.of<ProfileBloc>(context),
    );

    _initiateStoryView(widget.stories[_currentStoryIndex]);
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  void _moveToNextStory() {
    if (_currentStoryIndex < widget.stories.length - 1) {
      // Move to the next story for the same user
      setState(() {
        _currentStoryIndex++;
      });
      _initiateStoryView(widget.stories[_currentStoryIndex]);
    } else {
      // No more stories for this user, close and move to next user
      widget.onClose(); 
    }
  }

 
  
   void _onLikeStory() {
    setState(() {
      _isLiked = !_isLiked; // Toggle the local like state
    });

    // Dispatch the like event to the Bloc
    BlocProvider.of<StoryBloc>(context).add(
      LikeStoryEvent(
        storyId: widget.stories[_currentStoryIndex].storyId,
        userId: widget.currentUserId,
      ),
    );
  }
   Future<void> _initiateStoryView(StoryModel story) async {
    try {
      await _storyRepository.viewStory(story.storyId, widget.currentUserId);
    } catch (e) {
      print('Error marking story as viewed: $e');
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
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          
          onComplete: () {
            _moveToNextStory(); // Move to the next story when the current one completes
          },
        ),
        
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
                  // Display the correct time for the current story
                  Text(
                    formatStoryTime(widget.stories[_currentStoryIndex].createdAt),
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
              
              IconButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
          ),
        ),
        
        if (widget.stories[_currentStoryIndex].userId == widget.currentUserId)
          Positioned(
            bottom: 30,
            left: 10,
            child: Row(
              children: [
                Icon(Icons.visibility, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  '${widget.stories[_currentStoryIndex].views.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
     if (widget.stories[_currentStoryIndex].userId != widget.currentUserId)
          Positioned(
            bottom: 30,
            right: 10,
            child: Row(
              children: [
                
                Text(
                  '${widget.stories[_currentStoryIndex].likes.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    decoration: TextDecoration.none,
                  ),
                ),
                 SizedBox(width: 3),
                IconButton(
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    
                  ),
                  onPressed: () {
                    _onLikeStory();
                  },
                ), 
               
              ],
            ),
          ),

      ],
    );
  }
}


String formatStoryTime(DateTime createdAt) {
  final difference = DateTime.now().difference(createdAt);
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} s ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} h ago';
  } else {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  }
}
