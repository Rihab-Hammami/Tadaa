import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/notification_page/data/notificationModel.dart';
import 'package:tadaa/features/notification_page/presentation/blocs/notification_bloc.dart';
import 'package:tadaa/features/notification_page/presentation/blocs/notification_event.dart';
import 'package:tadaa/features/notification_page/presentation/blocs/notification_state.dart';
import 'package:tadaa/features/notification_page/presentation/widgets/notificationWidget.dart';

class NotificationPage extends StatelessWidget {
  final String userId;

  const NotificationPage({Key? key, required this.userId,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch notifications when the page is built
    BlocProvider.of<NotificationBloc>(context).add(FetchNotificationsEvent(userId:userId));

    return Scaffold(  
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(
                child: 
                Text('No notifications yet.',
                style: TextStyle(fontWeight: FontWeight.bold),));
            }
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                NotificationModel notification = state.notifications[index];
                //String userId= notification.userId;
                return NotificationCard(notification: notification,);
              },
            );
          } else if (state is NotificationError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No Notifications'));
          }
        },
      ),
    );
  }
}
