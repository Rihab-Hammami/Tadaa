import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/onBording_Screens/widgets/liquide_swipe.dart';

class OnBording_screen extends StatelessWidget {
   OnBording_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:LiquidSwipeWidget(),
    );
  }
  
}