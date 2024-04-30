import 'package:flutter/material.dart';
import 'dart:math' as math;
class ButtonNavBarWidget extends StatelessWidget {
  const ButtonNavBarWidget({
    Key? key,
    required this.child,
    required this.onTap
    }):super(key: key);

  final Widget child;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: math.pi/4,
        child: Container(
          alignment: Alignment.center,
          width: 55.0,
          height: 55.0,
          decoration: BoxDecoration(
            color: Color(0xFF0F1245),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Transform.rotate(
            angle: -math.pi/4,
            child: child,
          ),
        ),
      ),
    );
  }
}