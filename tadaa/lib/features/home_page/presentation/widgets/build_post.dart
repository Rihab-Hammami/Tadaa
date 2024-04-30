import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tadaa/core/utils/app_colors.dart';

enum Reaction{like,laugh,love,none}

class buildPost extends StatefulWidget {
  const buildPost({super.key});

  @override
  State<buildPost> createState() => _buildPostState();
}

class _buildPostState extends State<buildPost> {
  Reaction _reaction=Reaction.none;
  bool _reactionView=false;
  final List<ReactionElement> reactions=[
    ReactionElement(
      Reaction.like,
      const Icon(
        Icons.thumb_up_off_alt_rounded,
        color: Colors.blue,) 
    ),
    ReactionElement(
      Reaction.love,
      const Icon(
        Icons.favorite,
        color: Colors.red,) 
    ),
    ReactionElement(
      Reaction.laugh,
      const Icon(
        Icons.emoji_emotions,
        color: Colors.purple,) 
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
                        margin: const EdgeInsets.symmetric(vertical:5.0),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundImage: AssetImage("assets/images/profile1.jpg"),
                                    ),
                                    SizedBox(width: 5,),
                                    Column(
                                      children: [
                                        Text(
                                          "Amine Guesmi",
                                          style: TextStyle(                                          
                                            fontWeight: FontWeight.bold
                                            ),),
                                            Text(
                                          "Amine Guesmi",
                                          style: TextStyle(                          
                                          color: Colors.grey[250]
                                            ),),
                                                  
                                      ],
                                    ),
                                    
                                  ],
                                ),
                                Icon(Icons.more_vert),
                              ],                             
                            ),
                            SizedBox(height: 5,),
                            Text("Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, "),
                            SizedBox(height: 5,),
                            Image.asset("assets/images/story_img.jpg"),
                             SizedBox(height: 5,),
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
                                    child: Text('110',style:TextStyle(
                                      color: Colors.grey[600]
                                    )),
                                  ),
                                  Text('110 comments',style:TextStyle(
                                    color: Colors.grey[600]
                                  )),
                                  ],
                                )
                              ],
                              
                             ),
                             
                            ),
                            const Divider(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if(_reactionView)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 40,
                                    width: 140,
                                    decoration:BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(50)),
                                      child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: reactions.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 375),
                                          child: SlideAnimation(
                                            verticalOffset: 15+index*15,
                                            child: FadeInAnimation(
                                              child: IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    _reaction=reactions[index].reaction;
                                                    _reactionView=false;
                                                  });
                                                }, icon: reactions[index].icon),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                      
                                  ),
                                ),
                                Row(
                                  children: [
                                    
                                     InkWell(
                                      onTap: (){
                                        if(_reactionView){
                                          _reactionView=false;
                                        }else{
                                          if(_reaction==Reaction.none){
                                            _reaction=Reaction.like;
                                          }else{
                                            _reaction=Reaction.none;
                                          }
                                        }
                                      },
                                      onLongPress: (){
                                        setState(() {
                                          _reactionView=true;
                                        });
                                      },
                                         child: Row(
                                        children: [
                                          getReactionIcon(_reaction),
                                          SizedBox(width: 4),
                                          Text(
                                            'Like',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                       
                                     ),
                                     ),
                                  ],
                                ),
                              ],
                            )
                          ],

                        ),
                      );
  }
  
  Icon getReactionIcon(Reaction r) {
    switch(r){
      case Reaction.like:
      return const Icon (
    Icons.thumb_up,
    color: Colors.blue,
   );
   case Reaction.love:
   return const Icon (
    Icons.favorite,
    color: Colors.red,
   );
    case Reaction.laugh:
   return const Icon (
    Icons.emoji_emotions,
    color: Colors.purple,
   );
   default:
   return const Icon(
    Icons.thumb_up,
   );

    }
  }
}
class ReactionElement{
  final Reaction reaction;
  final Icon icon;
  ReactionElement(this.reaction,this.icon);
}

