import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadaa/features/home_page/presentation/widgets/PostTypes/celebration_post_widget.dart';
import 'package:tadaa/features/story_page/presentation/pages/addStoryScreen.dart';

class AddStoryWidget extends StatefulWidget {
  const AddStoryWidget({super.key});

  @override
  State<AddStoryWidget> createState() => _AddStoryWidgetState();
}

class _AddStoryWidgetState extends State<AddStoryWidget> {
File? _imageFile;
Future<File?>? imageFuture;

@override
void initState(){
super.initState();
}

 Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxHeight: 520,
    maxWidth: 520,
    );
  if (pickedFile != null) {
    setState(() {
      _imageFile = File(pickedFile.path);
    });
    // Pass the selected image file to AddStoryScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStoryScreen(),  // Pass imageFile here
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Story",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card 1
              InkWell(
                 onTap: () {
                  _pickImage();               
                },
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  color: Color.fromRGBO(238, 179, 17, 1), // Background color for the card
                  child: SizedBox(
                    height: 120, // Fixed height
                    width: 300, // Fixed width
                    child: Center(
                      child: Text(
                        "Moment",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Text color
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16), // Space between cards

              // Card 2
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                color: Color.fromARGB(255, 137, 209, 74), // Background color for the card
                child: SizedBox(
                  height: 120, // Fixed height
                  width: 300, // Fixed width
                  child: Center(
                    child: Text(
                      "Daily",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16), // Space between cards

              // Card 3
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                color: Colors.lightBlueAccent, // Background color for the card
                child: SizedBox(
                  height: 120, // Fixed height
                  width: 300, // Fixed width
                  child: Center(
                    child: Text(
                      "Tips",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
