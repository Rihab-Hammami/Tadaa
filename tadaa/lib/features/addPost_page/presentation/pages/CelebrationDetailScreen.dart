import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostBloc.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostEvent.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostState.dart';
import 'package:tadaa/features/home_page/presentation/widgets/nav_bar.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/user/userInfo.dart';
import 'package:tadaa/models/celebrationCat%C3%A9gorie.dart';
import 'package:tadaa/models/user.dart';

class CelebrationDetailScreen extends StatefulWidget {
  final CelebrationCategory category;
  final PostModel? initialPost;
  CelebrationDetailScreen({required this.category, this.initialPost});
  @override
  State<CelebrationDetailScreen> createState() => _CelebrationDetailScreenState();
}

class _CelebrationDetailScreenState extends State<CelebrationDetailScreen> {
  late User? _selectedUser;
  Map<String, String> taggedUsers = {};
  String? userId;
  Completer<void>? _dialogCompleter;
  File? imageFile;
  late String? existingImageUrl;
  @override
  void initState() {
    _selectedUser = null;   
    taggedUsers = {
      for (var userId in widget.initialPost?.taggedUsers ?? [])
        userId: '' 
    };
     existingImageUrl = widget.initialPost?.image ?? null;
     _fetchUserId();
  }
  Future<Map<String, String>> _fetchAllUsers() async {
    final profileRepository = ProfileRepository();
    final users = await profileRepository.getAllUsers();
    return {for (var user in users) user.uid: user.name};
  }
  Future<void> _fetchUserId() async {
    final id = await UserInfo.getUserId();
    setState(() {
      userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //widget.category.title+" Celebration",
          "Celebration",
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
            if (state is PostLoading) {
              //_showLoadingDialog(context);
              CircularProgressIndicator();
            } else if (state is PostCreateSuccess) {
             // _dismissLoadingDialog();
              BlocProvider.of<PostBloc>(context).add(FetchAllPostsEvent());
               Navigator.of(context).pushReplacement(
               MaterialPageRoute(builder: (context) => NavBar()), // Replace HomeScreen with your actual home screen widget
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post created Successfully!')),
              );
              //Navigator.of(context).pop(); 
            } else if (state is PostUpdateSuccess) {
              //_dismissLoadingDialog();
              BlocProvider.of<PostBloc>(context).add(FetchAllPostsEvent());
              Navigator.of(context).pushReplacement(
               MaterialPageRoute(builder: (context) => NavBar()), // Replace HomeScreen with your actual home screen widget
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post updated Successfully!')),
              );
            }
            else if (state is PostError) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
        child: Padding(
          padding: const EdgeInsets.all(16.0),      
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Select the person to celebrate",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 15),
                 Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                            child: FutureBuilder<Map<String, String>>(
                              future: _fetchAllUsers(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Text('Error fetching users');
                                }
        
                                final users = snapshot.data ?? {};
                                final filteredUsers = users.entries.where((entry) => entry.key != userId).toList();
                                final multiSelectItems = filteredUsers
                                    .map((entry) => MultiSelectItem<String>(entry.key, entry.value))
                                    .toList();
        
                                return MultiSelectDialogField(
                                  items: multiSelectItems,
                                  title: Text("Select tagged users"),
                                  selectedColor: Colors.blue,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey, width: 1.0),
                                  ),
                                  buttonText: Text("Select users"),
                                  onConfirm: (results) {
                                    setState(() {
                                      taggedUsers = {for (var id in results) id: users[id]!};
                                    });
                                  },
                                  initialValue: taggedUsers.keys.toList(),
                                );
                              },
                            ),
                          ),
             /* Container(
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
                        /*...users.map<DropdownMenuItem<User>>((User user) {
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
                        }).toList(),*/
                      ],
                    ),
                  ),
                ),*/
                const SizedBox(height:15,),
                Text(
                widget.category.title,
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
              ),
                const SizedBox(height:12,),
                Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Image.asset(
                    widget.category.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              /*SizedBox(height: 15),
                Text("Your Message",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 15,),
                TextFormField(              
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),*/
              SizedBox(height: 25),
             Center(
  child: SizedBox(
    width: double.infinity, // Makes the button take the full width of the screen
    child: ElevatedButton(
      onPressed: () {
        BlocProvider.of<PostBloc>(context).add(
          widget.initialPost == null
            ? CreatePostEvent(
                post: PostModel(
                  postId: '',
                  eventName: widget.category.title,
                  content: widget.category.text,
                  taggedUsers: taggedUsers.keys.toList(),
                  userId: userId!,
                  createdAt: DateTime.now(),
                  type: 'celebration',
                  image: imageFile != null ? null : '${widget.category.imagePath}' ?? '',
                  likes: [],
                ),
                imageFile: imageFile,
                userId: userId!
              )
            : UpdatePostEvent(
                postId: widget.initialPost!.postId,
                updatedPost: PostModel(
                  postId: widget.initialPost!.postId,
                  eventName: widget.category.title,
                  content: widget.category.text.isNotEmpty
                    ? widget.category.text
                    : widget.initialPost!.content,
                  taggedUsers: taggedUsers.keys.toList(),
                  userId: userId!,
                  createdAt: widget.initialPost!.createdAt,
                  type: 'celebration',
                  image: imageFile != null ? null : widget.initialPost!.image,
                  likes: widget.initialPost!.likes,
                ),
                imageFile: imageFile,
              ),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, 
        minimumSize: Size(180, 50), // Adjust the height if needed
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(13)),
        ),
      ),
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
),

        
            ],
          ),
        ),
      ),
    );
  }

void _showLoadingDialog(BuildContext context) {
    _dialogCompleter = Completer<void>();

    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent dismissing by tapping outside
          child: Center(child: CircularProgressIndicator()),
        );
      },
    ).then((_) {
      _dialogCompleter?.complete();
    });
  }

  void _dismissLoadingDialog() {
    if (_dialogCompleter != null) {
      _dialogCompleter?.future.then((_) {
        Navigator.of(context, rootNavigator: true).pop();
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
  }