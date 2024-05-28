import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/sign_up_screen/presentation/pages/sign_up_screen.dart';

class LiquidSwipeWidget extends StatefulWidget {
  @override
  State<LiquidSwipeWidget> createState() => _LiquidSwipeWidgetState();
}

class _LiquidSwipeWidgetState extends State<LiquidSwipeWidget> {
  int currentPage = 0;
  late List<Container> pages;
  late SharedPreferences _prefs;
  
  @override
  void initState() {
    super.initState();
    initPages();
    initSharedPreferences();
  }

  void initPages() {
    pages = [
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has",
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
        decoration: BoxDecoration(
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has",
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
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has",
                style: TextStyle(
                  color: Color(0xff182848),
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 35),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: AppColors.bleu,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  _completeOnboarding(context);
                },
                child: Text('Get Started', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    ];
  }

  void initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    bool hasCompletedOnboarding = _prefs.getBool('hasCompletedOnboarding') ?? false;
    if (hasCompletedOnboarding) {
      _navigateToSignUpScreen();
    }
  }

  void _completeOnboarding(BuildContext context) {
    _prefs.setBool('hasCompletedOnboarding', true);
    // Navigate to the sign-up screen after onboarding is completed
    _navigateToSignUpScreen();
  }

  void _navigateToSignUpScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

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
}
