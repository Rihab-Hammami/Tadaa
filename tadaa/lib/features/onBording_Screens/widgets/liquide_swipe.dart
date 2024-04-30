import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/onBording_Screens/widgets/button.dart';
import 'package:tadaa/features/sign_up_screen/presentation/sign_up_screen.dart';

class LiquidSwipeWidget extends StatefulWidget {
  @override
  State<LiquidSwipeWidget> createState() => _LiquidSwipeWidgetState();
}

class _LiquidSwipeWidgetState extends State<LiquidSwipeWidget> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return LiquidSwipe(
      pages: pages,
      enableLoop: false,
      fullTransitionValue: 300,
      enableSideReveal:true,
      slideIconWidget:  Icon(
        Icons.arrow_back_ios,
        size: 30,
        color: currentPage == 1 ? Colors.blue : Color(0xffe8eaed),
      ),
      positionSlideIcon: 0.5,    
      waveType: WaveType.liquidReveal,
      onPageChangeCallback: (page) {
        setState(() {
          currentPage = page;
        });
      },
    );
  }

  final pages = [
   Container(
    width: double.infinity,
    color: Color(0xffe8eaed),
     
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Image.asset(
          "assets/images/img1.png",
          height: 300,
          width: 300,
        ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            "Appreciate",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
            ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has",
            style: TextStyle(
              color: Color(0xff182848),
              fontSize: 17,
            ),
             textAlign: TextAlign.center,
          ),
      ),
      ],
    ),
   ),
   
   Container(
     //color: Color(0xff182848),
    decoration: 
        BoxDecoration(
          gradient: AppColors.primary_color,
        ),
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Image.asset(
          "assets/images/img2.png",
          height: 300,
          width: 300,
        ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            "Celebrate",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
            ),
        ),
          const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
             textAlign: TextAlign.center,
          ),
      ),
      ],
    ),
   ),
   Container(
   color: Color(0xffe8eaed),
   width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Image.asset(
          "assets/images/img3.png",
          height: 300,
          width: 300,
        ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            "Reward",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),
            ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has",
            style: TextStyle(
              color: Color(0xff182848),
              fontSize: 17,
            ),
             textAlign: TextAlign.center,
          ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 35),
        child: Builder(
          builder: (context) => ElevatedButton(
            style: buttonPrimary,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
            child: Text('Get Started', style: TextStyle(color: Colors.white)),
          ),
        ),)
      
      ],
    ),
   ),
 ];
}