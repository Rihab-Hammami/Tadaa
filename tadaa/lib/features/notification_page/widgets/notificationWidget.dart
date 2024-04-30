import 'package:flutter/material.dart';
import 'package:tadaa/Data/notifications.dart';
import 'package:tadaa/models/notification.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notifications.length, 
        itemBuilder: (context, index) {
          NotificationModel notification = notifications[index]; 
          String userImage = notification.user.imgUrl; // Assuming there's a userImage property in the NotificationModel
          String userName = notification.user.name; // Assuming there's a userName property in the NotificationModel
          //String action = notification.action;
          return Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: ClipRRect(
                //borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 50, // Specify the desired width
                  height: 50, // Specify the desired height
                  child: Image.asset(
                    userImage,
                    fit: BoxFit.cover, // Ensure the image covers the entire box
                  ),
                ),
                
              ),
              title: Text(
                userName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(notification.message),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {              
                },
              ),
            ),
          );
        },
      ),
    );
  }
  }
