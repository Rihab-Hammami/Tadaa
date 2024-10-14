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
  final List<StoryModel> stories; // List of stories passed to the widget
  BuildStory({Key? key, required this.stories}) : super(key: key);

  @override
  State<BuildStory> createState() => _BuildStoryState();
}

class _BuildStoryState extends State<BuildStory> with TickerProviderStateMixin {
  late Animation<double> gap;
  late Animation<double> base;
  late Animation<double> reverse;
  late AnimationController controller;
  late StoryRepository _storyRepository;
  Map<String, List<StoryModel>> _userStories = {}; // Grouped stories by user ID
  Map<String, UserModel> _users = {}; // User data for each story's user
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 15.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });

     controller.forward();
    _storyRepository = StoryRepository(
  walletRepository: RepositoryProvider.of<WalletRepository>(context),         // Get WalletRepository instance
  notificationRepository: RepositoryProvider.of<NotificationRepository>(context), // Get NotificationRepository instance
  profileBloc: BlocProvider.of<ProfileBloc>(context),                          // Get ProfileBloc instance
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

      // Check if the story is still valid (not older than 24 hours)
      if (DateTime.now().difference(story.createdAt).inHours < 24) {
        if (!groupedStories.containsKey(story.userId)) {
          groupedStories[story.userId] = [];
        }
        groupedStories[story.userId]!.add(story);
      }
    }

    setState(() {
      _userStories = groupedStories;
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


  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _userStories.isEmpty
            ? Center(child: Text('No stories available'))
            : Container(
                height: 160, 
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _userStories.length, // We now count users, not individual stories
                  itemBuilder: (context, index) {
                    final userId = _userStories.keys.elementAt(index);
                    final stories = _userStories[userId]!;
                    
                    final user = _users[userId];
                     PageController controller = PageController();
                    if (user == null) {
                      return SizedBox(); 
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryItemWidget(
                
                            stories: stories,
                            currentUserId: userId,
                            onClose: () {
                              Navigator.pop(context);
                            },
                 
                          ),
                          ),
                        );
                      },
                      child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                image: DecorationImage(
                                  image: NetworkImage(stories.first.mediaUrl), // Show the first story's image
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
                              child:  Container(
                                    constraints: BoxConstraints(maxWidth: 100),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
}



  

