import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/addPost_page/presentation/pages/addPost.dart';
import 'package:tadaa/features/home_page/presentation/pages/home_screen.dart';
import 'package:tadaa/features/home_page/presentation/widgets/button_widget.dart';
import 'package:tadaa/features/notification_page/pages/notification.dart';
import 'package:tadaa/features/profile_page/presentation/pages/profile_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex=0;
  void _navigateTo(int index){
  setState(() {
    _selectedIndex=index;
  });
}
  final _pages=const[
    Home_Screen(),
    notification(),
    Text('notification'),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
     return Scaffold( 
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: ButtonNavBarWidget(        
        child: Icon(Icons.add,
        color: Colors.white,),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPost()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
       bottomNavigationBar:Container(    
        height: 80.0,
        width:double.infinity,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 19.0),
        decoration: BoxDecoration(
          color: Colors.white, //Color.fromARGB(255, 232, 233, 236),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0)
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 15.0,
              offset: Offset(0, 4),
              color: Color(0xFF0F1245).withOpacity(0.15),
            )
          ]
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 8,right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  _navigateTo(0);
                },
                child: Icon(
                Icons.home,
                size: 35,
                color: _selectedIndex==0 ? AppColors.bleu: Color(0xFF0F1245),
                ),
              ),
              GestureDetector(
                onTap: (){
                   _navigateTo(1);
                   },
                child: Icon(Icons.notifications,
                size: 35,
                color: _selectedIndex==1 ? AppColors.bleu: Color(0xFF0F1245),)
              ),
              const SizedBox(),
              GestureDetector(
                onTap: (){
                   _navigateTo(2);
                },
               child: Icon(
                Icons.store,
                size: 35,
                color: _selectedIndex == 2 ? AppColors.bleu: Color(0xFF0F1245),
              ),
              ),
              GestureDetector(
                onTap: (){
                   _navigateTo(3);
                },
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: _selectedIndex==3 ? AppColors.bleu: Color(0xFF0F1245),
                  ),
              ),
            ],
          ),
        ),
      ),
  );
  }
}