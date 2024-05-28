import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/addPost_page/presentation/widgets/itemDashboardWidget.dart';

class CelebrtionPage extends StatefulWidget {
  const CelebrtionPage({super.key});

  @override
  State<CelebrtionPage> createState() => _CelebrtionPageState();
}

class _CelebrtionPageState extends State<CelebrtionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                buildCoverImage(),
                SizedBox(height: 8,),
                Text("Celebrate with your colleagues",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  ),
                  ),
                  Divider(
                  color: Colors.blue, 
                  thickness: 2, 
                  indent: 70, 
                  endIndent: 70, 
                ),
                Text("Choose an event"),
                SizedBox(height: 15,),
                 Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                
                 child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 20,
                  children: const [
                   DashboardItem(
                    title: 'Successful project',
                    iconAssetPath: 'assets/icons/success.png',
                    background: Colors.blue,
                  ),
                  DashboardItem(
                    title: 'goal achieved',
                    iconAssetPath: 'assets/icons/goal_acheived.png',
                    background: Colors.greenAccent,
                  ),
                  DashboardItem(
                    title: 'Birthday',
                    iconAssetPath: 'assets/icons/cake.png',
                    background: Colors.purpleAccent,
                  ),
                  DashboardItem(
                    title: 'Engagement',
                    iconAssetPath: 'assets/icons/proposal.png',
                    background: Colors.redAccent,
                  ),
                  DashboardItem(
                    title: 'New Certification',
                    iconAssetPath: 'assets/icons/certification.png',
                    background: Colors.orangeAccent,
                  ),
                  DashboardItem(
                    title: 'New Born',
                    iconAssetPath: 'assets/icons/baby.png',
                    background: Color.fromARGB(255, 250, 194, 236),
                  ),
                  
                  ],
                  ),
            ),
            ],
            ),
          ),
        ),
    );
  }
  
}
Widget buildCoverImage() {
  return Container(
    width: 400,
    height: 130,
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
      image: const DecorationImage(
      image: NetworkImage("https://images.pexels.com/photos/7794006/pexels-photo-7794006.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
      fit: BoxFit.cover,
      ),
    ),
  );
}
