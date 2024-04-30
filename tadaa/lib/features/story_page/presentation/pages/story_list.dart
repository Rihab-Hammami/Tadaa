import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/features/story_page/presentation/pages/story_page.dart';

class StoryListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: users
                .map((user) => ListTile(
                      title: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: CircleAvatar(
                          backgroundImage: AssetImage(user.imgUrl)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StoryPage(user: user,),
                          ),
                        );
                      },
                    ))
                .toList(),
          ),
        ),
      );
}