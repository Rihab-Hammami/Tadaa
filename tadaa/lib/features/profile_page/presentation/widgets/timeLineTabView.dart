import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/post.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/simple_Post_Widget.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/celebration_post_widget.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/userPost_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/userPost_event.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/userPost_state.dart';
import 'package:tadaa/models/celebrationCat%C3%A9gorie.dart';

class TimelineWidget extends StatefulWidget {
  final String userId; 
  final ProfileRepository profileRepository;
  final PostRepository postRepository;
  final String currentUserId;
  TimelineWidget({
    required this.userId,
    required this.profileRepository,
    required this.postRepository, 
    required this.currentUserId,
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

  void _fetchUserPosts() {
    final userPostBloc = BlocProvider.of<UserPostBloc>(context);
    userPostBloc.add(FetchUserPosts(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPostBloc, UserPostState>(
      builder: (context, state) {
        if (state is UserPostLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserPostLoaded) {
          return ListView.separated(
            itemCount: state.posts.length,
            separatorBuilder: (context, index) => Container(
              height: 3, 
              color: Colors.grey[300], 
            ),
            itemBuilder: (context, index) {
              final post = state.posts[index];
              Widget postWidget;
              if (post.type == 'simple') {
                postWidget = SimplePostWidget(
                  post: post,
                  profileRepository: widget.profileRepository,
                  postRepository: widget.postRepository,
                  currentUserId: widget.currentUserId,
                );
              } else if (post.type == 'celebration') {
                postWidget = CelebrationPostWidget(
                  post: post,
                  profileRepository: widget.profileRepository,
                  postRepository: widget.postRepository,
                  currentUserId: widget.currentUserId,
                  category: CelebrationCategory(
                    title: post.eventName ?? 'Unknown Event',
                    imagePath: post.image ?? '',
                    iconAssetPath: '',
                    text: post.content ?? 'No content available',
                  ),
                );
              } else if (post.type == 'appreciation') {
                postWidget = AppreciationPostWidget(
                  post: post,
                  profileRepository: widget.profileRepository,
                  postRepository: widget.postRepository,
                  currentUserId: widget.currentUserId,
                );
              } else {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0), // Adjust padding
                child: postWidget,
              );
            },
          );
        } else if (state is UserPostError) {
          return Center(child: Text("Error fetching posts: ${state.message}"));
        } else {
          return Center(child: Text("No posts available."));
        }
      },
    );
  }
}
