import 'package:flutter/material.dart';
import 'package:tadaa/models/celebrationCat%C3%A9gorie.dart';


final List<CelebrationCategory> categories = [
  CelebrationCategory(
    title: 'Successful project',
    iconAssetPath: 'assets/icons/success.png',
    imagePath: 'assets/images/success.png',
    text: "Congrats on your project success! Your effort made it happen!"

  ),
  CelebrationCategory(
    title: 'Goal achieved',
    iconAssetPath: 'assets/icons/goal_acheived.png',
    imagePath: 'assets/images/goal_achieved.png',
    text: "Goal achieved! Your persistence and effort made it happen!"
  ),
  CelebrationCategory(
    title: 'Birthday',
    iconAssetPath: 'assets/icons/cake.png',
    imagePath: 'assets/images/birthday1.jpg',
    text: "Happy Birthday! Enjoy your special day to the fullest!"
  ),
  CelebrationCategory(
    title: 'Engagement',
    iconAssetPath: 'assets/icons/proposal.png',
    imagePath: 'assets/images/mariage.jpg',
    text: "Congrats on your engagement! Wishing you a lifetime of love!"
  ),
  CelebrationCategory(
    title: 'New Certification',
    iconAssetPath: 'assets/icons/certification.png',
    imagePath: 'assets/images/new_certification.png',
    text: "Congrats on your certification! Amazing job!"
  ),
  CelebrationCategory(
    title: 'New Born',
    iconAssetPath: 'assets/icons/baby.png',
    imagePath: 'assets/images/new_born.png',
    text: "Congratulations on your new arrival! Welcome to the world, little one!"
  ),
];
