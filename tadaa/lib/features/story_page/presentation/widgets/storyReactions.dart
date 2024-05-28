import 'package:flutter/material.dart';


const double buttonSize=80;
class StoryReactionsFlow extends StatefulWidget {
  const StoryReactionsFlow({super.key});

  @override
  State<StoryReactionsFlow> createState() => _StoryReactionsFlowState();
}

class _StoryReactionsFlowState extends State<StoryReactionsFlow> with SingleTickerProviderStateMixin{
  late AnimationController controller;

   @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Flow(
      children:<IconData> [
          Icons.mail,
          Icons.send,
          Icons.notifications,
      ].map<Widget>(buildItem).toList(),
      delegate: FlowMenuDelegate(controller:controller),
      );   
  }

  Widget buildItem(IconData icon)=>SizedBox(
  width: buttonSize,
  height: buttonSize,
  child: FloatingActionButton(
    elevation: 0,
    splashColor: Colors.black,
    child: Icon(icon,color: Colors.white,size: 45,),   
    onPressed: (){
      if(controller.status==AnimationStatus.completed){
        controller.reverse();
      }else{
        controller.forward();
      }   
    },
  ),
 );
}

class FlowMenuDelegate extends FlowDelegate{
  final Animation<double> controller;

  FlowMenuDelegate({ required this.controller}):super(repaint:controller);
  @override
  void paintChildren(FlowPaintingContext context) {
    final size=context.size;
    final xStart=size.width-buttonSize;
    final yStart=size.height-buttonSize;

    for(int i=context.childCount-1; i>=0;i--){
      final margin=8;
      final childSize=context.getChildSize(i)!.width;
      final dx=(childSize+margin)*i;
      final x=xStart;
      final y=yStart-dx*controller.value;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(x,y,0)
      );
    }
  }
  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    throw UnimplementedError();
  }
}