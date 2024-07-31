import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/models/post.dart';


final posts = [
  Post( 
    //user: users[0],
    content: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ",
    dateTime:"2 hours ago",
    imageUrls: ["https://anafronius.com/cdn/shop/products/image_43e4028e-2a14-49e2-8f4e-51be9bc130a1_530x@2x.png?v=1581425228.png"],
    likes:100,
    comments: 60,
  ),
  Post( 
   // user: users[0],
    content: "Hello",
    dateTime:"2 hours ago",
    imageUrls: ["https://i.pinimg.com/236x/3b/b1/10/3bb110a013ea35c1bb3f873fe515ef76.jpg"],
    likes:100,
    comments: 60,
  ),
  Post( 
    //user: users[0],
    content: "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ",
    dateTime:"2 hours ago",
    imageUrls: ["https://i.pinimg.com/236x/3b/b1/10/3bb110a013ea35c1bb3f873fe515ef76.jpg"],
    likes:100,
    comments: 60,
  ),
];
final posts2=[
  Post(
    content:"Good Morning",
    dateTime: "2h ago",
    imageUrls: ["https://www.forbes.com/advisor/wp-content/uploads/2022/03/Image_-_Facebook_job_post_.jpeg-900x510.jpg"],
    likes: 100, 
    comments: 20)
];
final posts3=[
  Post(
    content:"Good Morning",
    dateTime: "2h ago",
    imageUrls: ["https://hireology.com/wp-content/uploads/2012/07/AdobeStock_200421067-1-1024x684.jpeg"],
    likes: 100, 
    comments: 20)
];