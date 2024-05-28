import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/features/home_page/presentation/widgets/StoryTypes/daily_storyView.dart';
import 'package:tadaa/features/home_page/presentation/widgets/StoryTypes/moment_storyView.dart';
import 'package:tadaa/features/home_page/presentation/widgets/StoryTypes/tips_storyView.dart';
import 'package:tadaa/features/home_page/presentation/widgets/storyView.dart';
import 'package:tadaa/features/story_page/presentation/pages/story_page.dart';
import 'package:tadaa/models/user.dart';

class buildStory extends StatelessWidget {
   buildStory({Key? key, required this.imagePath, required this.storyType}) : super(key: key);
  final String imagePath;
  final String storyType;
final User user = users.isNotEmpty ? users[0] : User(name: '', imgUrl: '', stories: [], posts: [], notifications: []);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (storyType) {
          case 'moment':
            Navigator.push(context, MaterialPageRoute(builder: (context) => StoryPage(user:user)));
            break;
          case 'daily':
            Navigator.push(context, MaterialPageRoute(builder: (context) => DailyStoryView()));
            break;
          case 'tips':
            Navigator.push(context, MaterialPageRoute(builder: (context) => TipsStoryView()));
            break;
          default:
            // Handle default case
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          color: Color.fromARGB(255, 167, 191, 233),
          border: Border.all(
            color: Colors.black26,
            width: 2,
          ),
        ),
        width: 110,
        height: 160,
      ),
    );
  }
}