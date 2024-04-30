import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';

class _PostStats extends StatelessWidget {
  
  const _PostStats({
   required Key key,
   
   }):super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: AppColors.bleu,
                shape: BoxShape.circle
              ),
              child: const Icon(Icons.thumb_up,size: 10,color: Colors.white,),
            )
          ],
        )
      ],
    );
  }
}