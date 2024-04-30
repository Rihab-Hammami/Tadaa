import 'dart:async';
import 'package:flutter/material.dart';

class StoryView extends StatefulWidget {
  final String imagePath;
  final String username;
  
  const StoryView({
    Key? key,
    required this.imagePath,
    required this.username,
    
  }) : super(key: key);

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {

  double percent=0.0;
  late Timer _timer;
  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 3), (timer) {
      setState(() {
        percent += 0.001;
      if (percent > 1) {
        _timer.cancel();
        Navigator.pop(context);
      }
      });
    });
  }
  @override
  void initState() {
    startTimer();
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 36.0, horizontal: 8.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: percent,
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(widget.imagePath),
                      radius: 30.0,
                    ),
                    SizedBox(width: 7),
                    Text(
                      widget.username,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


