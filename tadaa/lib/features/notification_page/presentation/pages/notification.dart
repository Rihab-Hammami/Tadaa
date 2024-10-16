import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/notification_page/presentation/pages/notificationScreen.dart';
import 'package:tadaa/features/notification_page/presentation/widgets/notificationWidget.dart';
import 'package:tadaa/features/notification_page/presentation/widgets/searchWidget.dart';
import 'package:tadaa/features/wallet_page/presentation/widgets/walletWidget.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_state.dart';
import 'package:tadaa/features/story_page/presentation/widgets/storyReactions.dart';
import 'package:tadaa/features/user/userInfo.dart';
import 'package:tadaa/features/wallet_page/data/model/walletModel.dart';
import 'package:tadaa/features/wallet_page/presentation/pages/walletPage.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(     
        appBar: AppBar(
          title:
         Text(
          'Notifications',
          style: 
          TextStyle(
            fontWeight: FontWeight.bold),
            ),
            /*actions: [
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
            ],*/
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
            
           body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              final String userId = state.user.uid;  
              
              return TabBarView(
                children: [                 
                  //Center(child: Text('Notifications Content')),
                  NotificationPage(userId: userId,),
                  WalletScreen(userId: userId), 
                ],
              );
            } else {             
              return const Center(child: Text('Failed to load user data'));
            }
          },
        ),
       
      ),
    );
  }
}