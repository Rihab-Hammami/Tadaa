import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tadaa/features/home_page/presentation/pages/home_page.dart';
import 'package:tadaa/features/home_page/presentation/widgets/nav_bar.dart';
import 'package:tadaa/features/story_page/data/models/storyModel.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_bloc.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_event.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_state.dart';
import 'package:tadaa/features/user/userInfo.dart'; // SharedPreferences for user info

class AddStoryScreen extends StatefulWidget {
  //final File? imageFile;

  const AddStoryScreen({Key? key, }) : super(key: key);
  @override
  _AddStoryScreenState createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  String? userId;
  File? _imageFile;
  final TextEditingController _captionController = TextEditingController(); // Caption controller

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    String? fetchedUserId = await UserInfo.getUserId();
    setState(() {
      userId = fetchedUserId;
    });
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
   
  }
}
  @override
  void dispose() {
    _captionController.dispose(); // Dispose of the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Story', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<StoryBloc, StoryState>(
        listener: (context, state) {
          if (state is StoryAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Story added successfully!')),
            );
          } else if (state is StoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is StoryAdding) {
            return Center(child: CircularProgressIndicator());
          }

          if (userId == null) {
            return Center(child: Text('Loading user info...')); // Loading userId
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
  height: 200,
  width: double.infinity,
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.grey, // Border color
      width: 1.0, // Border width
    ),
    borderRadius: BorderRadius.circular(8.0), // Rounded corners
  ),
  child: Stack( // Use a Stack to overlay the close button on top of the image
    children: [
      Center(
        child: _imageFile != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            : GestureDetector(
                onTap: _pickImage, // Trigger image picker
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.grey, // Icon color when no image is selected
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tap to pick an image',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
      ),
      // Close Button - Only show when an image is selected
              if (_imageFile != null) // Show close button only if the image is selected
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 30),
                    onPressed: () {
                      setState(() {
                        _imageFile = null; // Remove the image when close button is pressed
                      });
                    },
                  ),
                ),
            ],
          ),
        ),

                      
                      SizedBox(height: 16), // Space between image and text field
            
                    // Caption input field
                    TextFormField(
                      controller: _captionController, // Link controller to text field
                      decoration: InputDecoration(
                        labelText: 'Enter a caption',
                        border: OutlineInputBorder(),
                        
                      ),
                      maxLines: 1, // Allow multiline input
                    ),
                   
                    SizedBox(height: 16), // Space between text field and button
            
                    ElevatedButton(
                      onPressed: () {
                        if (_imageFile == null &&_captionController.text.isEmpty) {
                          // Show toast-like message if the image or caption is empty
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Story cannot be empty! Please add image or caption.'),
                              backgroundColor: Colors.red, // Set background color of SnackBar
                            ),
                          );
                        } else {
                          final storyId = FirebaseFirestore.instance.collection('stories').doc().id;
                          if (userId != null ) {
                            final story = StoryModel(
                              storyId: storyId,  // Firebase will generate the story ID
                              userId: userId!,   // Use the fetched userId
                              mediaUrl: '',      // Will be set after image upload
                              mediaType: _imageFile != null ? MediaType.image : MediaType.text, 
                              createdAt: DateTime.now(),
                              expiresAt: DateTime.now().add(Duration(hours: 24)),
                              views: [],
                              type: 'moment',
                              caption: _captionController.text, 
                              likes: [], 
                            );
                            
                            // Dispatch the AddStoryEvent with the selected image and caption
                            context.read<StoryBloc>().add(
                              AddStoryEvent(story: story, imageFile: _imageFile),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => NavBar()), // Assuming HomePage is defined
                              (route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User ID or image not found')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, 
                        onPrimary: Colors.white, 
                        elevation: 3, // Elevation
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Padding inside the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Rounded corners
                        ),
                        textStyle: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                        ),
                      ),
                      child: Text('Add Story'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

