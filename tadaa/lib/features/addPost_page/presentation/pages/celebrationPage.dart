import 'package:flutter/material.dart';
import 'package:tadaa/Data/celebrationCategories.dart';
import 'package:tadaa/features/addPost_page/presentation/pages/CelebrationDetailScreen.dart';
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
              SizedBox(height: 8),
              Text(
                "Celebrate with your colleagues",
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
              SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 20,
                  children: categories.map((category) {
                    return DashboardItem(
                      title: category.title,
                      iconAssetPath: category.iconAssetPath,
                      background: Colors.blue, // Vous pouvez changer la couleur pour chaque item si nécessaire
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CelebrationDetailScreen(category: category),
                          ),
                        );
                      },
                    );
                  }).toList(),
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
