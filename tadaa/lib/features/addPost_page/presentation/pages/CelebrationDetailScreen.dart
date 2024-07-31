import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/features/onBording_Screens/widgets/button.dart';
import 'package:tadaa/models/celebrationCat%C3%A9gorie.dart';
import 'package:tadaa/models/user.dart';

class CelebrationDetailScreen extends StatefulWidget {
  final CelebrationCategory category;

  CelebrationDetailScreen({required this.category});

  @override
  State<CelebrationDetailScreen> createState() => _CelebrationDetailScreenState();
}

class _CelebrationDetailScreenState extends State<CelebrationDetailScreen> {
  late User? _selectedUser;

  @override
  void initState() {
    _selectedUser = null;   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.title+" Celebration",
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Select the person to celebrate",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 15),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<User>(
                    value: _selectedUser,
                    onChanged: (User? newValue) {
                      setState(() {
                        _selectedUser = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<User>(
                        value: null,
                        child: Text("Select person"), // Default text
                      ),
                      ...users.map<DropdownMenuItem<User>>((User user) {
                        return DropdownMenuItem<User>(
                          value: user,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  user.imgUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(user.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              SizedBox(height:10,),
              Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  widget.category.imagePath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: TextButton(
              onPressed: (){},
              style: buttonPrimary,
              child: Text(
                'Post',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          ],
        ),
      ),
    );
  }
}
