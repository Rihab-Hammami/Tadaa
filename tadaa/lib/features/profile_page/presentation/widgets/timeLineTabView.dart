import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostBloc.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostEvent.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostState.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/post.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/simple_Post_Widget.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/celebration_post_widget.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';
import 'package:tadaa/models/celebrationCat%C3%A9gorie.dart';

class TimelineWidget extends StatefulWidget {
  final String userId; // Pass the userId to the widget
  final ProfileRepository profileRepository;
  final PostRepository postRepository;

  TimelineWidget({
    required this.userId,
    required this.profileRepository,
    required this.postRepository,
  });

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  @override
  void initState() {
    super.initState();
    _fetchUserPosts();
  }
  // Fetch posts for the specific user
  void _fetchUserPosts() {
    final postBloc = BlocProvider.of<PostBloc>(context);
    postBloc.add(FetchPostsByUserIdEvent(widget.userId)); 
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PostUserFetchSuccess) {
          if (state.posts.isEmpty) {
            return Center(child: Text("No posts to display."));
          }
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
              
              // Render different post types (Simple, Celebration, etc.)
              if (post.type == 'simple') {
                return SimplePostWidget(
                  post: post,
                  profileRepository: widget.profileRepository,
                  postRepository: widget.postRepository,
                  currentUserId: widget.userId,
                );
              } else if (post.type == 'celebration') {
                return CelebrationPostWidget(
                  post: post,
                  profileRepository: widget.profileRepository,
                  postRepository: widget.postRepository,
                  currentUserId: widget.userId,
                  category: CelebrationCategory(
                    title: post.eventName ?? 'Unknown Event',
                    imagePath: post.image ?? '',
                    iconAssetPath: '',
                    text: post.content ?? 'No content available',
                  ),
                );
              } else if (post.type == 'appreciation') {
                      return AppreciationPostWidget(
                        post: post,
                        profileRepository: widget.profileRepository,
                        postRepository: widget.postRepository,
                        currentUserId: widget.userId!,
                      );
                      }else {
                // Handle any other post types or unknown types
                return const SizedBox.shrink();
              }
            },
          );
        } else if (state is PostError) {
          return Center(child: Text("Error fetching posts: ${state.message}"));
        } else {
          return Center(child: Text("No posts available."));
        }
      },
    );
  }
}
