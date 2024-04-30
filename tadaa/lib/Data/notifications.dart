import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/models/notification.dart';
import 'package:tadaa/models/user.dart';
final List<NotificationModel> notifications = [
  NotificationModel(
    //userName: users[0].name,
    user: users[0],
    message: '${users[0].name} reacted to your photo',
    type: 'reaction',
    postId: 'post456',
    commentId: 'comment123',
    createdAt: DateTime.now(),
  ),
  NotificationModel(
   // userName: users[1].name,
   user: users[1],
    message: '${users[1].name} commented on your post',
    type: 'reaction',
    postId: 'post456',
    commentId: 'comment123',
    createdAt: DateTime.now(),
  ),
  NotificationModel(
   // userName: users[2].name,
   user: users[2],
    message: '${users[2].name} commented your post',
    type: 'reaction',
    postId: 'post456',
    commentId: 'comment123',
    createdAt: DateTime.now(),
  ),
];