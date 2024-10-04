/*import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/aboutTabView.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/timeLineTabView.dart';
import 'package:tadaa/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> 
with SingleTickerProviderStateMixin {
  final double coverHeight = 280;
  final double profileHeight = 144;
  late TabController tabController;
  int _selectedIndex = 0;
  bool isCaptionTapped = false;
   void _handleCaptionTapped(bool tapped) {
    setState(() {
      isCaptionTapped = tapped;
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double top = coverHeight - profileHeight / 2;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [             
                buildCoverImage(),
                Positioned(
                  top: 35,
                  right: 10,
                  child: Icon(Icons.more_horiz,size: 30,color: Colors.white,)
                ),
                 /*Positioned(
                  top: 35,
                  left: 10,
                  child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )

                ),*/
                Positioned(
                  top: top,
                  child: buildProfileContainer(),
                ),
                Positioned(
                  top: top / 1.5,
                  child: buildProfileImage(),
                ),
                /*Positioned(
                  top: 280,
                  child: Center(
                    child: Text(
                     currentUser.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),*/
                Positioned(
                  top: 315,
                  child: Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0xFF0F1245),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.celebration,
                      size: 20, 
                      color: Colors.white, 
                    ),
                    SizedBox(width: 6), 
                    Text(
                      '100', 
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ],
            ),
            SizedBox(height: 90),
            Container(
              height: MediaQuery.of(context).size.height,
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child:  TabBar(
                      controller: tabController,
                      tabs: [
                        _buildTab('Timeline', 0),
                        _buildTab('About', 1),        
                                  
                      ],
                      indicatorColor: Color(0xff28BAE8),
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [                     
                        //TimelineWidget(),                       
                       // AboutWidget(),
                       
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      width: double.infinity,
      height: coverHeight,
      child: Image.asset(
        "assets/images/profile1.jpg",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProfileContainer() {
    return Container(
      width: 340,
      height: 150,
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
    );
  }

  Widget buildProfileImage() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            "assets/images/profile3.png",
            width: profileHeight,
            height: profileHeight,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              // Handle edit icon tap
            },
            child: Icon(
              Icons.edit,
              color: AppColors.bleu,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
   Widget _buildTab(String text, int index) {
    bool isSelected = index == _selectedIndex;
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
*/