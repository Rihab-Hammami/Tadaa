/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/features/home_page/presentation/widgets/StoryTypes/daily_storyView.dart';
import 'package:tadaa/features/home_page/presentation/widgets/StoryTypes/moment_storyView.dart';
import 'package:tadaa/features/home_page/presentation/widgets/StoryTypes/tips_storyView.dart';
import 'package:tadaa/features/home_page/presentation/widgets/storyView.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'package:tadaa/features/story_page/domain/repositories/storyRepository.dart';
import 'package:tadaa/features/story_page/presentation/pages/story_list_page.dart';
import 'package:tadaa/features/story_page/presentation/pages/story_page.dart';
import 'package:tadaa/models/user.dart';

class buildStory extends StatefulWidget {
  buildStory({Key? key, required this.imagePath, required this.storyType,}) : super(key: key);
  final String imagePath;
  final String storyType;
  

  @override
  State<buildStory> createState() => _buildStoryState();
}

class _buildStoryState extends State<buildStory> {


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        switch (widget.storyType) {
          case 'moment':
            Navigator.push(context, MaterialPageRoute(builder: (context) => StoryListPage(storyType: 'moment')));
            break;
          case 'daily':
            Navigator.push(context, MaterialPageRoute(builder: (context) => StoryListPage(storyType: 'daily')));
            break;
          case 'tips':
            Navigator.push(context, MaterialPageRoute(builder: (context) => TipsStoryView()));
            break;
          default:         
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          image: DecorationImage(
            image: AssetImage(widget.imagePath),
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
}*/
