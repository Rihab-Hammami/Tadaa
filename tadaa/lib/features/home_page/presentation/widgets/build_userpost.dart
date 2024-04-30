import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/home_page/presentation/widgets/post_reaction.dart';
import 'package:tadaa/models/post.dart';
import 'package:tadaa/models/user.dart';

class BuildUserPost extends StatelessWidget {
 final User user;
  final Post post;
  const BuildUserPost({super.key, required this.user, required this.post});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
                        margin: const EdgeInsets.symmetric(vertical:5.0),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                             Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(user.imgUrl),),
                                const SizedBox(width: 8.0,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    Row(
                                      children: [
                                        Text(post.dateTime,style:  TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12.0,
                                          ),),
                                          SizedBox(width: 3,),
                                        Icon(Icons.public,color: Colors.grey[600],
                                        size: 12.0,
                                        ),
                                        
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.more_vert),
                                )
                            ],
                                                  ),
                                 SizedBox(height: 5,),
                                 Padding(
                                  padding: EdgeInsets.only(left: 7),
                                   child: Column(
                                    // Align children to the start
                                    children: [
                                      Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        post.content,
                                      ),
                                    ),
                                      SizedBox(height: 5),
                                      // Display images if available
                                      if (post.imageUrls.isNotEmpty)
                                        Column(
                                          children: post.imageUrls.map((url) {
                                            return Image.network(url);
                                          }).toList(),
                                        ),
                                    ],
                                                               ),
                                 ),
                                  SizedBox(height: 5),
                                  Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Column(
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
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: Colors.pink,
                                            shape: BoxShape.circle
                                          ),
                                          child: const Icon(Icons.favorite,
                                          size: 10,color: Colors.white,),
                                        ),
                                      const SizedBox(width: 4.0,),
                                      Expanded(
                                        child: Text('${post.likes}',style:TextStyle(
                                          color: Colors.grey[600]
                                        )),
                                      ),
                                      Text(
                                        '${post.comments} '"comments",
                                        style:TextStyle(
                                        color: Colors.grey[600]
                                      )),
                                      ],
                                    )
                                  ],
                                  
                                 ),
                                 
                                ),
                                const Divider(),
                                  PostReactions(),
                                ]
                                
                                ),
                          )
      ),
    );
  }
}
class _PostHeader extends StatelessWidget{
  final Post post;
  final User user;
  const _PostHeader({
    Key? key,
    required this.post,
    required this.user,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(user.imgUrl),),
        const SizedBox(width: 8.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.w600),
                ),
              Row(
                children: [
                  Text(post.dateTime,style:  TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.0,
                    ),),
                  Icon(Icons.public,color: Colors.grey[600],
                  size: 12.0,
                  ),
                  
                ],
              )
            ],
          ),
        ),
        IconButton(
          onPressed: (){},
          icon: Icon(Icons.more),
          )
      ],
    );
  }
}
