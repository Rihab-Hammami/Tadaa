import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';

class buildImageContainer extends StatelessWidget {
  const buildImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
      width: MediaQuery.of(context).size.width,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: Row(
                children: [
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text(
                    "Convert Your Points,",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Your Way!",
                    style: TextStyle(
                      color: AppColors.bleu,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Image.asset("assets/images/convert_coins1.png"),
                ],
              ),
            )    
          ],
        ),
      ),
        ),
    );
  }
}