import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/home_page/presentation/widgets/build_userpost.dart';
import 'package:tadaa/features/notification_page/widgets/notificationWidget.dart';
import 'package:tadaa/features/notification_page/widgets/searchWidget.dart';
import 'package:tadaa/features/story_page/presentation/widgets/storyReactions.dart';

class notification extends StatelessWidget {
  const notification({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        
        appBar: AppBar(
          title:
         Text(
          'Notification',
          style: 
          TextStyle(
            fontWeight: FontWeight.bold),
            ),
            actions: [
              /*Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.search,size:30,),
              )*/
              IconButton(
                onPressed: (){
                 showSearch(
                  context: context,
                  delegate: SearchWidget());
                }, 
                icon: Icon(Icons.search))
            ],
            bottom: TabBar(
          indicatorColor: AppColors.bleu,
          labelColor: AppColors.bleu,
            tabs: [
              Tab(
                text: 'Notifications', 
              ),
              Tab(
                text: 'Points', 
              ),
            ],
          ),
            ),
            
            body: TabBarView(
          children: [
            NotificationWidget(),
            Center(
              child: Text('Points Content'),
            ),
          ],
        ),
        
      ),
    );
  }
}