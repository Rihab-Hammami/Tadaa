import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PostReactions extends StatefulWidget {
  const PostReactions({super.key});

  @override
  State<PostReactions> createState() => _PostReactionsState();
}
enum Reaction{like,laugh,love,none}

class _PostReactionsState extends State<PostReactions> {
  Reaction _reaction = Reaction.none;
  bool _reactionView = false;
  final List<ReactionElement> reactions = [
    ReactionElement(Reaction.like, Icons.thumb_up, Colors.blue),
    ReactionElement(Reaction.love, Icons.favorite, Colors.red),
    ReactionElement(Reaction.laugh, Icons.emoji_emotions, Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (_reactionView) 
        _buildReactionButtons(),
        _buildReactionBar(),
      ],
    );
  }

  Widget _buildReactionButtons() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 40,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: reactions.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 15 + index * 15,
                child: FadeInAnimation(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _reaction = reactions[index].reaction;
                        _reactionView = false;
                      });
                    },
                    icon: Icon(reactions[index].iconData, color: reactions[index].color),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

 Widget _buildReactionBar() {
  return Row(
    children: [
      Expanded(
        child: InkWell(
          onTap: () {
            if (_reactionView) {
              _reactionView = false;
            } else {
              _reaction = _reaction == Reaction.none ? Reaction.like : Reaction.none;
            }
          },
          onLongPress: () {
            setState(() {
              _reactionView = true;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
      ),
      SizedBox(width: 16), // Add spacing between the buttons
      Expanded(
        child: InkWell(
          onTap: () {
            // Handle comment button tap
            // You can implement your logic here
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.comment,
                size: 25, // Add the icon for comment button
                color: Colors.black, // Set the color for comment button icon
              ),
              SizedBox(width: 4),
              Text(
                'Comment', // Text for the comment button
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}


}
Icon getReactionIcon(Reaction r) {
    switch(r){
      case Reaction.like:
      return const Icon (
    Icons.thumb_up,
    size: 25,
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

class ReactionElement {
  final Reaction reaction;
  final IconData iconData;
  final Color color;

  ReactionElement(this.reaction, this.iconData, this.color);
}
