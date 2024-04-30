import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/addPost_page/presentation/widgets/bottomSheet.dart';
import 'package:tadaa/features/onBording_Screens/widgets/button.dart';

class PublicationPage extends StatefulWidget {
  const PublicationPage({super.key});

  @override
  State<PublicationPage> createState() => _PublicationPageState();
}

class _PublicationPageState extends State<PublicationPage> {
  @override
  void initState() {
    //OpenBottomModelSheet();
    super.initState();
  }
  final caption=TextEditingController();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
   // OpenBottomModelSheet();
   BottomModalSheet();
    });
   
    return Scaffold(
    body: SafeArea(
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,

        children:[ 
          Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Row(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        image: DecorationImage(
                        image: NetworkImage(currentUser.imgUrl), // Use the current user's image URL
                        fit: BoxFit.cover,
                      ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.name, 
                          style: TextStyle(fontSize: 16),
                          ),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: TextField(
                            controller: caption,
                            decoration: InputDecoration(
                              hintText: 'Write a caption...',
                              border: InputBorder.none,
                              ),  
                          ),
                        ),
                      ],
                    ),
                  ],
                ),         
                ),
                const Divider(),
                
                //Spacer(),
                /*Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom:20.0),
                  child: ElevatedButton(
                  style: buttonPrimary,
                  onPressed: () {
                    
                  },
                  child: Text('Post', style: TextStyle(color: Colors.white)),
                            ),
                ),
                ),*/
          
              ],
            ),
            ),
        ),
        Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 13),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.camera_alt,
                          ),
                          const SizedBox(width: 15,),
                          const Icon(
                            Icons.video_call,
                          ),
                          const SizedBox(width: 15,),
                          const Icon(
                            Icons.image,
                          ),
                          const SizedBox(width: 15,),
                          GestureDetector(
                            onTap: (){
                              BottomModalSheet();
                            },
                            child: const Icon(
                              Icons.more_horiz,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
        ]

      )
        ),
    );
  }
  BottomModalSheet(){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      barrierColor:Colors.transparent,
      context: context,
      builder: (context){
        return Container(
          decoration: 
          BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(5, 0),
                blurRadius: 1,
                color: Colors.grey.withOpacity(.6),
                spreadRadius: 0.5,)
              
            ]), 
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    createPostNavigationItem(title:"Add photo",IconData:Icons.image),
                    const SizedBox(height: 25,),
                    createPostNavigationItem(title:"Add a video",IconData:Icons.video_call),
                    const SizedBox(height: 25,),
                    createPostNavigationItem(title:"Add a document",IconData:Icons.document_scanner),
                  ],
                ),
              ),
              
              ),  
             
        );
      }
      );
  }
  
  createPostNavigationItem({required String title, required IconData IconData}) {
    return Row(
      children: [
        Icon(IconData,size: 25,),
        const SizedBox(width: 10,),
        Text("$title",style: TextStyle(fontSize: 16,color: Colors.black),)
      ],
    );
  }
  
 /*OpenBottomModelSheet (){
    showModalBottomSheet(
      isScrollControlled: false,
      enableDrag: true,
      isDismissible: false,
      context: context,
      builder:(context){
        return Column(
          children: [
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              height: 110,
              decoration: 
              const BoxDecoration(color: Colors.grey,boxShadow: [
                BoxShadow(
                  offset: Offset(0, 2),
                  color: Colors.white12,
                  blurRadius: 5,
                )
              ])
            )
          ],
        );
      }
    );

}*/
}




