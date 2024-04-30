import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/features/story_page/presentation/widgets/profile_widget.dart';
import 'package:tadaa/features/story_page/presentation/widgets/side_bar.dart';
import 'package:tadaa/models/story.dart';
import 'package:tadaa/models/user.dart';

class StoryWidget extends StatefulWidget {
  final User user;
  final PageController controller;

  const StoryWidget({
    required this.user,
    required this.controller,
  });

  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final storyItems = <StoryItem>[];
  late StoryController controller;
  String date = '';
  bool showSidebar = false;

  void addStoryItems() {
    for (final story in widget.user.stories) {
      switch (story.mediaType) {
        case MediaType.image:
          storyItems.add(StoryItem.pageImage(
            url: story.url,
            controller: controller,
            caption: Text(story.caption),
            duration: Duration(
              milliseconds: (story.duration * 1000).toInt(),
            ),
          ));
          break;
        case MediaType.text:
          storyItems.add(
            StoryItem.text(
              title: story.caption,
              backgroundColor: story.color,
              duration: Duration(
                milliseconds: (story.duration * 1000).toInt(),
              ),
            ),
          );
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    controller = StoryController();
    addStoryItems();
    date = widget.user.stories[0].date;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleCompleted() {
    widget.controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    final currentIndex = users.indexOf(widget.user);
    final isLastPage = users.length - 1 == currentIndex;

    if (isLastPage) {
      Navigator.of(context).pop();
    }
  }

  void toggleSidebar() {
    setState(() {
      showSidebar = !showSidebar;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onVerticalDragUpdate: (details) {
      if (details.delta.dy > 0) {
        // Swipe down, navigate to previous story
        widget.controller.previousPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else if (details.delta.dy < 0) {
        // Swipe up, navigate to next story
        widget.controller.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    },
    child: Stack(
      children: <Widget>[
        Material(
          type: MaterialType.transparency,
          child: StoryView(
            storyItems: storyItems,
            controller: controller,
            onComplete: handleCompleted,
            onStoryShow: (storyItem, currentIndex) {
              if (currentIndex > 0) {
                setState(() {
                  date = widget.user.stories[currentIndex].date;
                });
              }
            },
          ),
        ),
        if (showSidebar) Positioned(
          child: SideBar(),

        ),
        Positioned(
            
          child: ProfileWidget(
            user: widget.user,
            date: date,
          ),
        ),
        /* Positioned(
          top: 40,
          left: 10,
          child: IconButton(
            onPressed: toggleSidebar, // Toggle sidebar visibility
            icon: Icon(Icons.menu, color: Colors.white, size: 40),
          ),
        ),*/
        
       
        
        Positioned(
          top: 40,
          right: 5,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, color: Colors.white, size: 30),
          ),
        ),
      ],
      
    ),
  );
}
