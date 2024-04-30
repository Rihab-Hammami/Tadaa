import 'package:flutter/material.dart';
import 'package:tadaa/models/notification.dart';
import 'package:tadaa/models/post.dart';
import 'package:tadaa/models/story.dart';

class User {
  final String name;
  final String imgUrl;
  final List<Story> stories;
  final List<Post> posts;
  final List<NotificationModel> notifications;
  
  const User({
    required this.name,
    required this.imgUrl,
    required this.stories,
    required this.posts,
    required this.notifications, 
   
  });
}
