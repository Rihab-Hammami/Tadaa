
import 'package:flutter/material.dart';
import 'package:tadaa/features/home_page/presentation/widgets/storyView.dart';


class DailyStoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoryView(
      imagePath: "assets/images/profileimage.jpg",
      username: "Amine guesmi", 
      
      //storyType: "daily",
    );
  }
}