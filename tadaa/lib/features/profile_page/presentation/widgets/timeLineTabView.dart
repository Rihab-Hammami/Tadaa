import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/features/home_page/presentation/widgets/build_userpost.dart';

class TimelineWidget extends StatefulWidget {
  const TimelineWidget({super.key});

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
        ...currentUser.posts.map((post) {
          return Column(
            children: [
              BuildUserPost(user: currentUser, post: post),
              SizedBox(
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: Container(color: Colors.grey[300],),) // Add some vertical space between posts
            ],
          );
        }).toList(),
          ],
        ),
      ),
    );

  }
}