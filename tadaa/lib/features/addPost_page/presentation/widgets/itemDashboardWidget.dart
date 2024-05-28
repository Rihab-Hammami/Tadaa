import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final String title;
  final String iconAssetPath; // New property for the icon asset path
  final Color background;

  const DashboardItem({
    Key? key,
    required this.title,
    required this.iconAssetPath,
    required this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Theme.of(context).primaryColor.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Image.asset( // Use Image.asset to load the icon from assets
              iconAssetPath,
              color: Colors.white,
              width: 24, // Adjust the width as needed
              height: 24, // Adjust the height as needed
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
