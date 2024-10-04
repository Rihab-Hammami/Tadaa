import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tadaa/features/home_page/presentation/pages/home_page.dart';
import 'package:tadaa/features/home_page/presentation/widgets/commentWidget.dart';
import 'package:tadaa/features/notification_page/data/notificationModel.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart'; // Update with your actual import

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  //final String userId; 

  NotificationCard({
    Key? key, required this.notification, 
   //this.userId
   }) : super(key: key);
   
  Icon _getIconForAction(String actionType) {
    switch (actionType) {
      case 'comment':
        return  const Icon(Icons.comment,color: Colors.blue,);
      case 'like':
        return const Icon(Icons.favorite_sharp, color: Colors.red);
      case 'new post':
        return const Icon(Icons.article, color: Color.fromARGB(255, 160, 211, 112));
      case 'new story':
        return const Icon(Icons.article, color: Color.fromARGB(255, 160, 211, 112));
      case 'tag':  
        return const Icon(Icons.person, color: Colors.blue);
      default:
        return const Icon(Icons.card_giftcard, color: Colors.yellow);
    }
  }

  String _getActionMessage(String actionType) {
    switch (actionType) {
      case 'comment':
        return 'commented on your post';
      case 'like':
        return 'liked your post';
      case 'new post':
        return 'add new post';
       case 'new story':
      return 'add new story'; 
      case 'tag':  
        return 'mentioned you in a post.';
      default:
        return 'Appreciate You';
    }
  }
  void _navigateToAction(BuildContext context, String actionType, String actionId) {
    switch (actionType) {
      case 'comment':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        break;
      case 'like':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        break;
      case 'new post':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        break;
      default:
        // Handle other types of actions if needed
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
  String formattedTime = DateFormat('HH:mm').format(notification.date);
  String formattedDate = DateFormat('dd MMM yyyy', 'fr_FR').format(notification.date);
  
  return FutureBuilder<UserModel>(
    future: ProfileRepository().getUserProfile(notification.userId), // Fetch the user profile
    builder: (context, snapshot) {
     if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(color: Colors.white,); // Show loading indicator
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}'); 
      } else if (!snapshot.hasData) {
        return Text('User not found'); 
      } else {
        final userName = snapshot.data!.name; 
        final userImage = snapshot.data!.profilePicture; // Get the username from UserModel
        return InkWell(
          onTap: () => _navigateToAction(context, notification.actionType, notification.actionId),
          child: Card(       
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // The image
                  Stack(
                    clipBehavior: Clip.none,
                    children:[                    
                      Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage('$userImage'), // Load user image
                          fit: BoxFit.cover, // Change to cover for better aspect ratio
                        ),
                      ),
                    ),
                    Positioned(
                      top: -7,
                      left: -8,
                      child: _getIconForAction(notification.actionType)
                      ),
                    ]
                  ),
                  SizedBox(width: 12),
                  // The main content
                  Expanded( // Use Expanded here
                    child: Column( // Use Column to stack text vertically
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName, 
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          _getActionMessage(notification.actionType),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Time and Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formattedTime, // Time (e.g., 08:00)
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        formattedDate, // Date (e.g., 10 Juillet 2023)
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    },
  );
 }
}
