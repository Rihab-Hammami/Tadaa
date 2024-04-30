import 'package:flutter/material.dart';
import 'package:tadaa/features/onBording_Screens/presentation/onBording_screen.dart';
import 'package:tadaa/features/splash_screen/presentation/pages/splash_screen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      
      home:  Splash_screen(),
    );
  }
}



