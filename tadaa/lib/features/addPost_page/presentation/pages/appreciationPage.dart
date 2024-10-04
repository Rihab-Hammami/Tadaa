import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostBloc.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostEvent.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostState.dart';
import 'package:tadaa/features/home_page/presentation/widgets/nav_bar.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/user/userInfo.dart';
import 'package:tadaa/models/user.dart';

class AppreciationPage extends StatefulWidget {
  final PostModel? initialPost;
  const AppreciationPage({Key? key, this.initialPost}) : super(key: key);

  @override
  _AppreciationPageState createState() => _AppreciationPageState();
}

class _AppreciationPageState extends State<AppreciationPage> {
  late User? _selectedUser;
  late int _selectedPoints;
  String? _selectedAction;
  Map<String, String> taggedUsers = {};
  String? userId;
  String? _selectedTaggedUserId; 
  late TextEditingController captionController;
  File? imageFile;
  Completer<void>? _dialogCompleter;
  final List<int> pointsList = [10, 20, 30, 40, 50];
  final List<String> actionsList = [
    "Efficient Project Management",
    "Positive Attitude",
    "Taking Initiative",
    "Making Work Fun"
  ];

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
  void initState() {
    super.initState();
    _selectedUser = null;
    _selectedPoints = 10;
    _selectedAction = null;
    _selectedTaggedUserId = null;
    captionController = TextEditingController(
      text: widget.initialPost?.content ?? '',
    );
    taggedUsers = {
      for (var userId in widget.initialPost?.taggedUsers ?? []) userId: ''
    };
    _fetchUserId();
  }

  bool _validateFields() {
    if (taggedUsers.isEmpty) {
      _showSnackBar("Please select at least one user to appreciate.");
      return false;
    }
    if (_selectedPoints == null) {
      _showSnackBar("Please select points.");
      return false;
    }
    if (_selectedAction == null) {
      _showSnackBar("Please select an action.");
      return false;
    }
    if (captionController.text.isEmpty) {
      _showSnackBar("Please enter a message.");
      return false;
    }
    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostLoading) {
            _showLoadingDialog(context);
          } else if (state is PostCreateSuccess) {
            _dismissLoadingDialog();
            BlocProvider.of<PostBloc>(context).add(FetchAllPostsEvent());
            Navigator.of(context).pop(); // Go back to previous screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Post created Successfully!')),
            );
            Navigator.of(context).pop(); 
          } else if (state is PostUpdateSuccess) {
            _dismissLoadingDialog();
            BlocProvider.of<PostBloc>(context).add(FetchAllPostsEvent());
            Navigator.of(context).pop(); // Go back to previous screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Post updated Successfully!')),
            );
            Navigator.of(context).pop(); 
          } else if (state is PostError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select the person to appreciate",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 15),
                Text(
                  "Send appreciation points",
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
                  child: DropdownButton<int>(
                    value: _selectedPoints,
                    isExpanded: true, 
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedPoints = newValue!;
                        print('Selected Points: $_selectedPoints'); // Debug output
                      });
                    },
                    items: pointsList.map<DropdownMenuItem<int>>((int points) {
                      return DropdownMenuItem<int>(
                        value: points,
                        child: Row(
                          children: [
                            Icon(Icons.card_giftcard, color: Colors.yellow),
                            SizedBox(width: 8),
                            Text("$points Points"),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Select the action",
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
                    child: DropdownButton<String>(
                      value: _selectedAction,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedAction = newValue;
                        });
                      },
                      items: actionsList.map<DropdownMenuItem<String>>((String action) {
                        return DropdownMenuItem<String>(
                          value: action,
                          child: Text(action),
                        );
                      }).toList(),
                      hint: Text("Select an action"), // Optional: Add hint text
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Your message",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: captionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Enter your message',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate fields before proceeding
                        if (_validateFields()) {
                          final caption = captionController.text;
                          BlocProvider.of<PostBloc>(context).add(
                            widget.initialPost == null
                            ? CreatePostEvent(
                                post: PostModel(
                                  postId: '',
                                  content: caption,
                                  taggedUsers: taggedUsers.keys.toList(),
                                  userId: userId!,
                                  createdAt: DateTime.now(),
                                  type: 'appreciation',
                                  likes: [],
                                  points: _selectedPoints,
                                  action: _selectedAction,
                                ),
                                imageFile: imageFile,
                                userId: userId!,
                              )
                            : UpdatePostEvent(
                                postId: widget.initialPost!.postId,
                                updatedPost: PostModel(
                                  postId: widget.initialPost!.postId,
                                  content: caption,
                                  taggedUsers: taggedUsers.keys.toList(),
                                  userId: userId!,
                                  createdAt: widget.initialPost!.createdAt,
                                  type: 'appreciation',
                                  points: widget.initialPost!.points,
                                  action: widget.initialPost!.action,
                                  likes: widget.initialPost!.likes,
                                ),
                                imageFile: imageFile,
                              ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, 
                        minimumSize: Size(350, 50),
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
