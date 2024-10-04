import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/addPost_page/presentation/pages/SimplePost.dart';
import 'package:tadaa/features/addPost_page/presentation/pages/appreciationPage.dart';
import 'package:tadaa/features/addPost_page/presentation/pages/celebrationPage.dart';
import 'package:tadaa/features/addPost_page/presentation/pages/publicationPage.dart';

class AddPost extends StatefulWidget {
  final Function(String caption, File? imageFile) onPost;
  const AddPost({Key? key, required this.onPost}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  int _selectedIndex = 0;
  bool isCaptionTapped = false;
  final captionController = TextEditingController();
  File? imageFile;
  
   void _handleCaptionTapped(bool tapped) {
    setState(() {
      isCaptionTapped = tapped;
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Post",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
         
          bottom: TabBar(
            tabs: [
              _buildTab('Publication', Icons.publish, 0),
              _buildTab('Célébration', Icons.celebration, 1),
              _buildTab('Appreciation', Icons.favorite, 2),
            ],
            //indicatorPadding: EdgeInsets.symmetric(horizontal: 10.0),
            indicatorColor: Color(0xff28BAE8),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              }
              );
            },
          ),
        ),
        body: TabBarView(
          children: [
            PublicationPage(),
            CelebrtionPage(),
            AppreciationPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, IconData iconData, int index) {
    bool isSelected = index == _selectedIndex;
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: isSelected ? AppColors.bleu : Colors.black,
          ),
          SizedBox(width: 2,),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.bleu : Colors.black,
            ),
          ),
          
        ],
      ),
    );
  }
  
}