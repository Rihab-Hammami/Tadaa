import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  const TabItem({super.key, required this.icon,required this.title,});

 final String title;
 final IconData icon;

 
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            ),
            
        ],
      ),
    );
  }
}