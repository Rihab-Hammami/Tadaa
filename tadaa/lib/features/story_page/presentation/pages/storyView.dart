/*import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'package:story_view/story_view.dart';
class StoryViewPage extends StatefulWidget {
  final int index;
  final List<StoryModel> story;
  const StoryViewPage({super.key, required this.index, required this.story});

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
   final storyController = StoryController();
   String userName = 'Unknown User';
  String userProfileUrl = ''; 

    @override
  void dispose() {
    super.dispose();
    storyController.dispose();
  }
 void _fetchUserProfile() async {
  if (widget.story.isNotEmpty) {
    try {
      final userProfile = await ProfileRepository().getUserProfile(widget.story[widget.index].userId);
      if (userProfile != null) {
        setState(() {
          userName = userProfile.name ?? 'Unknown User'; // Fallback if name is null
          userProfileUrl = userProfile.profilePicture ?? ''; // Default to empty if null
        });
      } else {
        print('User profile is null');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  } else {
    print('Story list is empty');
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
  if (widget.index >= widget.story.length || widget.index < 0 || widget.story.isEmpty) {
    return Center(child: Text("Invalid index or no story to display"));
  }

  return Stack(
    children: [
      StoryView(
        controller: storyController,
       storyItems: [
  for (int i = widget.index; i < widget.story.length; i++)
    if (widget.story[i].type == 'image' && widget.story[i].mediaUrl != null)
      StoryItem.inlineImage(
        imageFit: BoxFit.contain,
        url: widget.story[i].mediaUrl!,
        controller: storyController,
        caption: const Text(
          "Caption Here",
          style: TextStyle(
            color: Colors.white,
            backgroundColor: Colors.black54,
            fontSize: 17,
          ),
        ),
      )
    else if (widget.story[i].type == 'text' && widget.story[i].caption != null)
      StoryItem.text(
        title: widget.story[i].caption ?? 'No caption',  // Safeguard text content
        backgroundColor: Colors.black,
        textStyle: const TextStyle(
          fontSize: 30,
          color: Colors.white,
        ),
      ),
],

        onStoryShow: (s, index) {
          print("Showing story at index: $index");
        },
        onComplete: () {
          print("Story viewing complete");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        inline: true,
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
                  userName,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  _timeElapsed(widget.story[widget.index].createdAt),
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.cancel,
            color: Colors.grey,
            size: 40,
          ),
        ),
      ),
    ],
  );
}
}*/