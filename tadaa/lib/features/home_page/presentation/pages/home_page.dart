
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostBloc.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostEvent.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostState.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/celebration_post_widget.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/post.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/simple_Post_Widget.dart';
import 'package:tadaa/features/home_page/presentation/widgets/buildStory.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_event.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_state.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'package:tadaa/features/story_page/domain/repositories/storyRepository.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_bloc.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_event.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_state.dart';
import 'package:tadaa/features/story_page/presentation/pages/addStoryScreen.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';
import 'package:tadaa/features/wallet_page/presentation/bloc/walletBloc.dart';
import 'package:tadaa/features/wallet_page/presentation/bloc/walletState.dart';
import 'package:tadaa/models/celebrationCat%C3%A9gorie.dart'; // Import the SimplePost model

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final profileRepository = ProfileRepository();
  //final postRepository = PostRepository();
  final walletRepository = WalletRepository(); 
  final notificationRepository = NotificationRepository();
  late final postRepository; 
  String? _profilePictureUrl;
  String? _userId; 
  int _userPoints= 0;
  File? _imageFile;
  bool _isLoading = true;
 List<StoryModel> _stories = [];

  @override
  void initState() {
    super.initState();
    _getUserId(); 
    _fetchStories();
    _fetchPosts();
    _fetchProfile();
    
  postRepository = PostRepository(
  walletRepository: walletRepository,
  profileBloc: BlocProvider.of<ProfileBloc>(context),
  notificationRepository: notificationRepository, 
 ); 
}
void _fetchStories() {
  final storyBloc = BlocProvider.of<StoryBloc>(context);
  storyBloc.add(FetchAllStoriesEvent());
}
/*void _fetchStories() {
  final storyRepository = StoryRepository();
  storyRepository.fetchAllStories().then((fetchedStories) {
    setState(() {
      _stories = fetchedStories;
      _isLoading = false; // Assign stories to a state variable
    });
  }).catchError((error) {
    print("Failed to fetch stories: $error");
  });
}*/
 void _fetchPosts() {
  final postBloc = BlocProvider.of<PostBloc>(context);
  postBloc.add(FetchAllPostsEvent());
}

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('uid'); 

    if (_userId != null) {
      _fetchProfile(); 
    }
  }

  void _fetchProfile() {
    if (_userId == null) 
    return;
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(FetchProfile(_userId!)); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 242, 243),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          shadowColor: Colors.grey[300],
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Container(
              color: Colors.white,
            ),
          ),
          elevation: 0.0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(23),
              bottomRight: Radius.circular(23),
            ),
          ),
          title: Row(
            children: [
              Image.asset(
                'assets/logo/logo_bleu.png',
                width: 90,
                height: 90,
                fit: BoxFit.contain,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF0F1245),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    Image.asset(
                      "assets/icons/coins.png",
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(width: 4),
                    BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileLoaded) {
                        // Update the points directly from the state
                        return Text(
                          '${state.user.points}',
                           
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } /*else if (state is ProfileLoading) {
                        // Show a loader or placeholder while loading
                        return CircularProgressIndicator(
                          color: Colors.white,
                        );
                      } */else {
                        return Text(
                          '', // Default or placeholder value
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body:  MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded) {
              _profilePictureUrl = state.user.profilePicture;
              } else if (state is ProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load profile')),
                );
              }
            },
          ),
          BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if (state is PostError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
           BlocListener<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WalletSuccess) {
              if (_userId != null) {
                setState(() {
                 context.read<ProfileBloc>().add(FetchProfile(_userId!));
                });             
              }
            } else if (state is WalletError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<StoryBloc, StoryState>(
      listener: (context, state) {
        if (state is StoryAdded) {
          // Possibly fetch stories again or refresh the view
          context.read<StoryBloc>().add(FetchAllStoriesEvent());
        }
      },)
        ],
        
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, postState) {
            if (postState is PostLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (postState is PostFetchSuccess) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text(
                            "Stories",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                     BlocBuilder<StoryBloc, StoryState>(
                        builder: (context, storyState) {
                          if (storyState is StoryLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (storyState is StoryLoaded) {
                            return Row(
                              children: [
                                _buildAddContainer(),
                                SizedBox(width: 5),
                                Expanded(
                                  child: storyState.stories.isNotEmpty
                                      ? BuildStory(stories: storyState.stories)
                                      : Center(child: Text('No stories available')),
                                ),
                              ],
                            );
                          } else if (storyState is StoryError) {
                            return Center(child: Text('Failed to load stories'));
                          } else {
                            return Center(child: Text('No stories available'));
                          }
                        },
                      ),
                  
                      SizedBox(height: 10),
                      
                  ListView.separated(
                  shrinkWrap: true, // Adjust based on your requirements
                  physics: NeverScrollableScrollPhysics(), // Use this if the parent is already scrollable
                  itemCount: postState.posts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16), // Adds separation between posts
                  itemBuilder: (context, index) {
                    final post =postState.posts[index];
                    if (post.type == 'simple') {
                      return SimplePostWidget(
                        post: post,
                        profileRepository: profileRepository,
                        postRepository: postRepository,
                         currentUserId: _userId!,
                      );
                    } else if (post.type == 'celebration') {
                      CelebrationCategory category = CelebrationCategory(
                      title: post.eventName ?? 'Unknown Event',   // or wherever the title is stored
                      imagePath: post.image ?? '',    
                      iconAssetPath: '', 
                      text: post.content ?? 'No content available', // or wherever the image path is stored
                    );
                      return CelebrationPostWidget(
                        post: post,
                        profileRepository: profileRepository,
                        postRepository: postRepository,
                        currentUserId: _userId!,
                        category: category
                      );
                      }else if (post.type == 'appreciation') {
                      return AppreciationPostWidget(
                        post: post,
                        profileRepository: profileRepository,
                        postRepository: postRepository,
                        currentUserId: _userId!,
                      );
                      }else {
                      return const SizedBox.shrink(); // Fallback for unknown types
                    }
                    
                  },
                ),                  
                  ]),
                ),
              );
            } else {
              return Center(child: Text('No posts found'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildAddContainer() {
    return Stack(
      children: [
        Container(
          width: 110,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Colors.transparent,
            border: Border.all(color: Colors.black26),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 140 * 0.7,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
              color: Colors.grey[300],
              border: Border.all(color: Colors.black26),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
              child: _profilePictureUrl != null
                ? CachedNetworkImage(
                    imageUrl: _profilePictureUrl!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                : Image.asset(
                    "assets/images/profile.jpg", // Default profile image
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
            ),
          ),
        ),
        Positioned(
          bottom: 43,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddStoryScreen()), // Use MaterialPageRoute
                  );
                  },
                  icon: Icon(Icons.add),
                  iconSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 23,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "Add Story",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
 /*Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxHeight: 520,
    maxWidth: 520,
    );
  if (pickedFile != null) {
    setState(() {
      _imageFile = File(pickedFile.path);
    });
    // Pass the selected image file to AddStoryScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStoryScreen(imageFile: _imageFile),  // Pass imageFile here
      ),
    );
  }
}*/
}
