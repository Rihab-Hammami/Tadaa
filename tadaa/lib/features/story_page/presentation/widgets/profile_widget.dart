import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';

class ProfileWidget extends StatelessWidget {
  final String userId; // Retrieve user ID dynamically
  final StoryModel story;   // The story object, which contains the date

  const ProfileWidget({
    required this.userId,
    required this.story,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RepositoryProvider.of<ProfileRepository>(context).getUserProfile(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error fetching profile data');
        } else if (!snapshot.hasData) {
          return Text('No profile found');
        } else {
          final profile = snapshot.data!; // Assuming Profile model is returned

          return Material(
            type: MaterialType.transparency,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 48),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(profile.profilePicture!), // Dynamic profile image
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          profile.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          formatStoryDate(story.createdAt), // Retrieve and format date from story
                          style: TextStyle(color: Colors.white38),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // You can adjust this to format the date in any style you prefer
  String formatStoryDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}'; // Example date format
  }
}
