import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tadaa/Data/points.dart';
import 'package:tadaa/Data/posts.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/home_page/presentation/widgets/build_story.dart';
import 'package:tadaa/features/home_page/presentation/widgets/build_userpost.dart';
import 'package:tadaa/features/home_page/presentation/widgets/button_widget.dart';
import 'dart:math' as math;
import 'package:tadaa/features/home_page/presentation/widgets/nav_bar.dart';
import 'package:tadaa/models/post.dart';
import 'package:tadaa/models/user.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();

  static _Home_ScreenState? of(BuildContext context) {
    int userPoints = 0;
    return context.findAncestorStateOfType<_Home_ScreenState>();
  }
}

class _Home_ScreenState extends State<Home_Screen> {
  List<Map<String, dynamic>> posts = [];
  void addPost(String caption, File? imageFile) {
  setState(() {
    posts.add({'caption': caption, 'imageFile': imageFile});
    print('Post added: $caption, ${imageFile?.path}');
   }
  );
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
                    Icon(
                      Icons.celebration,
                      size: 25,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${pointsData.firstWhere((point) => point.userId == 1).points}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      children: [
                        _buildAddContainer(),
                        SizedBox(width: 7),
                        buildStory(
                            imagePath: "assets/images/momentStory.png",
                            storyType: 'moment'),
                        SizedBox(width: 7),
                        buildStory(
                            imagePath: "assets/images/tipsStory.png",
                            storyType: 'tips'),
                        SizedBox(width: 7),
                        buildStory(
                            imagePath: "assets/images/dailyStory.png",
                            storyType: 'daily'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  height: 2,
                  color: Colors.grey[300],
                ),
                Column(
                  children: users.map((user) {
                    return Column(
                      children: [
                        ...user.posts.map((post) {
                          return Column(
                            children: [
                              BuildUserPost(user: user, post: post),
                              SizedBox(height: 5)
                            ],
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                )
              ],
            ),
          ),
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
              child: Image.network(
                currentUser.imgUrl,
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
                  onPressed: () {},
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
}
