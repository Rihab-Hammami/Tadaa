/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/story_view.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_bloc.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_event.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_state.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'package:tadaa/features/story_page/presentation/pages/story_item.dart';  // Import your custom StoryItemWidget

class StoryListPage extends StatefulWidget {
  const StoryListPage({Key? key}) : super(key: key);

  @override
  State<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends State<StoryListPage> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _getUserId(); 
    // Call FetchAllStoriesEvent to load all stories
    context.read<StoryBloc>().add(FetchAllStoriesEvent());
  }

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, state) {
          if (state is StoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StoryLoaded) {
            // Create PageController for horizontal scrolling
            PageController controller = PageController();

            // Group stories by userId
            final Map<String, List<StoryModel>> userStories = {};
            for (var story in state.stories) {
              userStories.putIfAbsent(story.userId, () => []).add(story);
            }

            return PageView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,  // Change to horizontal scroll
              itemCount: userStories.keys.length,
              itemBuilder: (context, index) {
                final userId = userStories.keys.elementAt(index);
                final stories = userStories[userId]!;

                return StoryItemWidget(
                  initialStoryIndex: 0,
                  stories: stories,
                  currentUserId: _userId!,
                  onClose: () {
                    Navigator.pop(context);
                  },
                 
                  onSwipeLeft: () {
                    // Move to the next user's story when swiped left
                    if (index < userStories.keys.length - 1) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    } else {
                      Navigator.pop(context); // Close if there are no more users
                    }
                  },
                  onSwipeRight: () {
                    // Move to the previous user's story when swiped right
                    if (index > 0) {
                      controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    } else {
                      Navigator.pop(context); // Close if at the first user
                    }
                  },
                  onStoryChange: (int value) { /* Handle story change */ },
                );
              },
            );
          } else if (state is StoryError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: Text('No Stories Available'));
        },
      ),
    );
  }
}
*/