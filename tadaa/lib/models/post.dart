import 'package:flutter/material.dart';
import 'package:tadaa/models/user.dart';

class Post{
  //final User user;
  final String content;
  final String dateTime;
  final List<String> imageUrls;
  final int likes;
  final int comments;
  
   Post({
  //  required this.user,
    required this.content,
    required this.dateTime,
    required this.imageUrls, 
    required this.likes,
    required this.comments,
    
  });
}
