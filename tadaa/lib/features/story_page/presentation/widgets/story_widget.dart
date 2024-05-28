import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/features/story_page/presentation/widgets/profile_widget.dart';
import 'package:tadaa/features/story_page/presentation/widgets/storyReactions.dart';
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
   late AnimationController animationController;
   bool _isFavorited = false;
  final storyItems = <StoryItem>[];
  late StoryController controller;
  String date = '';

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
    if (widget.user.stories.isNotEmpty) {
      date = widget.user.stories[0].date;
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Expanded(
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
                  Positioned(         
                  child: ProfileWidget(
                    user: widget.user,
                    date: date,
                  ),
              ),
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
            ),
           Row(
            children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Add Comment...',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Handle send comment action
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            _isFavorited ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            setState(() {
              _isFavorited = !_isFavorited;
            });
          },
        ),   
      ],
    )
          ],
        ),
      ),
    );
  }
}
 