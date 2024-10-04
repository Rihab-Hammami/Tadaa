import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/home_page/presentation/widgets/nav_bar.dart';
import 'package:tadaa/features/onBording_Screens/presentation/onBording_screen.dart';

class Splash_screen extends StatefulWidget {
  const Splash_screen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash_screen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<Decoration> _decorationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _decorationAnimation = DecorationTween(
      begin: BoxDecoration(
        gradient: AppColors.primary_color,
      ),
      end: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
              Color(0xff0061ff),
             Color(0xFF60efff),
             
            
            
          ],
        ),
      ),
    ).animate(_controller);

    _controller.repeat(reverse: true);
    _goHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            decoration: _decorationAnimation.value,
            child: Center(
              child: Container(
                width: 200,
                height: 400,
                child: Image.asset("assets/logo/logo_white.png"),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Future<void> _goHome() async {
    await Future.delayed(Duration(seconds: 6));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>OnBording_screen(),
      ),
    );
  }
}
