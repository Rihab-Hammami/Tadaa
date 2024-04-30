import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/addPost_page/presentation/widgets/publicationPage.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  int _selectedIndex = 0;
  bool isCaptionTapped = false;
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
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Post',
                  style: TextStyle(fontSize: 18, color: AppColors.bleu,),
                ),
              ),
            )
          ],
          bottom: TabBar(
            tabs: [
              _buildTab('Publication', Icons.publish, 0),
              _buildTab('Célébration', Icons.celebration, 1),
              _buildTab('Appreciation', Icons.favorite, 2),
            ],
            indicatorColor: Color(0xff28BAE8),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        body: TabBarView(
          children: [
            PublicationPage(),
            Center(child: Text('Tab2')),
            Center(child: Text('Tab3')),
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
            color: isSelected ? AppColors.bleu : Colors.grey,
          ),
          SizedBox(height: 2,),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.bleu : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
