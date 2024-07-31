import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/core/utils/app_colors.dart';


final ButtonStyle buttonPrimary=ElevatedButton.styleFrom(
  
minimumSize: Size(310,50),
backgroundColor: AppColors.bleu,
elevation:0,
shape: const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(20),
  ),
)
);