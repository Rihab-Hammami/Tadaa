import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final String title;
  final String iconAssetPath;
  final Color background;
  final VoidCallback onTap; // New property for the onTap callback

  const DashboardItem({
    Key? key,
    required this.title,
    required this.iconAssetPath,
    required this.background,
    required this.onTap, // Include the onTap parameter in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Use GestureDetector to detect taps
      onTap: onTap, // Call the onTap callback when tapped
      child: Container(
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
              child: Image.asset(
                iconAssetPath,
                color: Colors.white,
                width: 24,
                height: 24,
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
      ),
    );
  }
}
