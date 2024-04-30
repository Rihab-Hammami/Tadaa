import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final double coverHeight = 280;
  final double profileHeight = 144;
  

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight / 2;

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          buildCoverImage(),
          Positioned(
            top: top,
            child: buildProfileContainer(),
          ),
          Positioned(
            top: top / 1.5,
            child: buildProfileImage(),
          ),
          Positioned(
            top: 290,
            child: Center(
              child: Text(
                currentUser.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
         /* Positioned(
            top: coverHeight + 90, // Adjust the top position of the TabBar
            left: 20, // Adjust the left position of the TabBar
            right: 20, // Adjust the right position of the TabBar
            height: 40, // Adjust the height of the TabBar
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              
            ),
          ),*/
          /*Positioned(
            top: coverHeight + 130, // Adjust the top position of the TabBarView
            left: 20,
            right: 20,
            //bottom: 0,
            child: Container(
              height: 200, // Adjust the height of the TabBarView
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
             
            ),
          ),*/
        ],
      ),
    );
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      width: double.infinity,
      height: coverHeight,
      child: Image.asset(
        "assets/images/profile_placeholder.jpg",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProfileContainer() {
    return Container(
      width: 350,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget buildProfileImage() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            "assets/images/profile2.png",
            width: profileHeight,
            height: profileHeight,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              // Handle edit icon tap
            },
            child: Icon(
              Icons.edit,
              color: AppColors.bleu,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

}