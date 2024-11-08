import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'package:tadaa/features/story_page/domain/repositories/storyRepository.dart';
import 'package:tadaa/features/story_page/presentation/pages/story_item.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';

class BuildStory extends StatefulWidget {
  final List<StoryModel> stories;
  final String currentUserId; // Add the current user ID here

  BuildStory({Key? key, required this.stories, required this.currentUserId}) : super(key: key);

  @override
  State<BuildStory> createState() => _BuildStoryState();
}

class _BuildStoryState extends State<BuildStory> {
  late StoryRepository _storyRepository;
  Map<String, List<StoryModel>> _userStories = {};
  Map<String, UserModel> _users = {};
  bool _isLoading = true;
  int _currentUserIndex = 0; // Track the current user index

  @override
  void initState() {
    super.initState();
    _storyRepository = StoryRepository(
      walletRepository: RepositoryProvider.of<WalletRepository>(context),
      notificationRepository: RepositoryProvider.of<NotificationRepository>(context),
      profileBloc: BlocProvider.of<ProfileBloc>(context),
    );
    _fetchAllStories();
  }

Future<void> _fetchAllStories() async {
  try {
    final stories = await _storyRepository.fetchAllStories();
    final Map<String, UserModel> users = {};
    final Map<String, List<StoryModel>> groupedStories = {};

    for (var story in stories) {
      final user = await ProfileRepository().getUserProfile(story.userId);
      users[story.userId] = user;

      // Check if the story is less than 24 hours old
      if (DateTime.now().difference(story.createdAt).inHours < 24) {
        groupedStories.putIfAbsent(story.userId, () => []).add(story);
      }
    }

    // Ensure the current user's stories are first
    final Map<String, List<StoryModel>> orderedStories = {};
    if (groupedStories.containsKey(widget.currentUserId)) {
      orderedStories[widget.currentUserId] = groupedStories[widget.currentUserId]!;
    }
    // Add the rest of the stories, excluding the current user
    groupedStories.forEach((userId, stories) {
      if (userId != widget.currentUserId) {
        orderedStories[userId] = stories;
      }
    });

    setState(() {
      _userStories = orderedStories;
      _users = users;
      _isLoading = false;
    });
  } catch (e) {
    print('Error fetching stories or user profiles: $e');
    setState(() {
      _isLoading = false;
    });
  }
}



  void _moveToNextUser() {
    if (_currentUserIndex < _userStories.length - 1) {
      setState(() {
        _currentUserIndex++;
      });
      final nextUserId = _userStories.keys.elementAt(_currentUserIndex);
      _openStoryPage(nextUserId);
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _openStoryPage(String userId) {
    final stories = _userStories[userId]!;
    final user = _users[userId]!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryItemWidget(
          stories: stories,
          currentUserId: widget.currentUserId, // Pass the logged-in user's ID here
          onClose: _moveToNextUser,
          userName: user.name,
          userProfilePicture: user.profilePicture!,
        ),
      ),
    ).then((_) {
      if (_currentUserIndex >= _userStories.length - 1) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _userStories.isEmpty
            ? Center(child: Text('No stories available'))
            : SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _userStories.length,
                  itemBuilder: (context, index) {
                    final userId = _userStories.keys.elementAt(index);
                    final stories = _userStories[userId]!;
                    final user = _users[userId];

                    if (user == null) return SizedBox();

                    return GestureDetector(
                      onTap: () {
                        _currentUserIndex = index;
                        _openStoryPage(userId);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                image: DecorationImage(
                                  image: NetworkImage(stories.first.mediaUrl),
                                  fit: BoxFit.fill,
                                ),
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 2,
                                ),
                              ),
                              width: 110,
                              height: 160,
                            ),
                            Positioned(
                              top: 4,
                              left: 5,
                              child: CircleAvatar(
                                backgroundImage: user.profilePicture != null
                                    ? NetworkImage(user.profilePicture!)
                                    : AssetImage('assets/images/profile.jpg') as ImageProvider,
                                radius: 12,
                              ),
                            ),
                            Positioned(
                              bottom: 3,
                              left: 5,
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 100),
                                child: Text(
                                  user.name,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
  }
}

