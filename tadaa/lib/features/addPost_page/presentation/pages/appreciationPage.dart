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

  Future<List<Map<String, String>>> _fetchAllUsersAsList() async {
  final profileRepository = ProfileRepository();
  final users = await profileRepository.getAllUsers();

  // Map the users to a list of maps containing the desired fields
  return users.map((user) {
    return {
      'uid': user.uid,
      'name': user.name,
      'profilePicture': user.profilePicture ?? '', // Provide a default if null
    };
  }).toList();
}

  Future<void> _fetchUserId() async {
    final id = await UserInfo.getUserId();
    if (mounted) {
      setState(() {
        userId = id;
      });
    }
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
  @override
void dispose() {
  captionController.dispose(); 
  super.dispose();
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
    resizeToAvoidBottomInset: true, // Ensure the layout resizes when the keyboard shows
    body: BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostLoading) {
          CircularProgressIndicator();
        } else if (state is PostCreateSuccess) {
          Navigator.pop(context);
          BlocProvider.of<PostBloc>(context).add(FetchAllPostsEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post created Successfully!')),
          );
        } else if (state is PostUpdateSuccess) {
          Navigator.pop(context);
          BlocProvider.of<PostBloc>(context).add(FetchAllPostsEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post updated Successfully!')),
          );
        } else if (state is PostError) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: SingleChildScrollView( // Wrap everything in a SingleChildScrollView
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
                child: GestureDetector(
                  onTap: () async {
                    final users = await _fetchAllUsersAsList();
                    await _showCustomDialog(context, users);
                  },
                  child: FutureBuilder<Map<String, String>>(
                    future: _fetchAllUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error fetching users');
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_drop_down),
                                SizedBox(width: 8),
                                Text("Select users"),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (taggedUsers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: taggedUsers.isNotEmpty
                      ? Row(
                          children: [
                            Flexible(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: taggedUsers.entries.map((entry) {
                                    return Chip(
                                      label: Text(entry.value),
                                      onDeleted: () {
                                        setState(() {
                                          taggedUsers.remove(entry.key);
                                        });
                                      },
                                      deleteIcon: Icon(Icons.cancel, size: 18),
                                      deleteIconColor: Colors.red,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
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
                "Enter message",
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
              SizedBox(height: 25),
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
       if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    } else {
       if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
   Future<void> _showCustomDialog(BuildContext context, List<Map<String, String>> users) async {
  // Filter out the current user (userId) from the list
  final filteredUsers = users.where((user) => user['uid'] != userId).toList();

  // Create a TextEditingController for the search input
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> displayedUsers = List.from(filteredUsers);

  // Set to keep track of selected user IDs
  Set<String> selectedUserIds = {};

  // Function to filter users based on the search query
  void _filterUsers(String query) {
    if (query.isEmpty) {
      displayedUsers = List.from(filteredUsers);
    } else {
      displayedUsers = filteredUsers.where((user) {
        return user['name']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      // StatefulBuilder to allow rebuilding the dialog
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), // Rounded corners
            elevation: 5,
            backgroundColor: Colors.white,
            child: Container(
              padding: EdgeInsets.all(15),
              width: 350,  // Set width to be consistent and not too wide
              child: Column(
                mainAxisSize: MainAxisSize.min, // Allow content to adjust based on size
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  TextField(
                    controller: searchController,
                    onChanged: (query) {
                      _filterUsers(query);
                      setState(() {}); // Update the displayed list when search query changes
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Display the "No results" message if there are no filtered users
                  if (displayedUsers.isEmpty)
                    Center(child: Text('No users found', style: TextStyle(color: Colors.grey))),
                  // User list
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListBody(
                        children: displayedUsers.map((user) {
                          final profilePicture = user['profilePicture'] ?? '';
                          final isSelected = selectedUserIds.contains(user['uid']);

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? Colors.blue[50] : Colors.transparent, // Highlight selected item
                             
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: profilePicture.isNotEmpty
                                    ? NetworkImage(profilePicture)
                                    : null,
                                child: profilePicture.isEmpty
                                    ? Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              title: Text(
                                user['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle, color: Colors.blue) // Checkmark for selected
                                  : Icon(Icons.radio_button_unchecked, color: Colors.grey), // Unchecked icon for non-selected
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    // Remove from selected users if already selected
                                    selectedUserIds.remove(user['uid']);
                                  } else {
                                    // Add to selected users if not selected
                                    selectedUserIds.add(user['uid']!);
                                  }
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                 
                  

                  // Action buttons at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog without any changes
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // On confirm, return the selected users
                          Navigator.of(context).pop(selectedUserIds.toList());
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ).then((selectedIds) {
    // When the dialog closes, process the selected users (if any)
    if (selectedIds != null && selectedIds.isNotEmpty) {
      setState(() {
        taggedUsers = {for (var id in selectedIds) id: users.firstWhere((user) => user['uid'] == id)['name']!};
        
      });
    }
  });
}
  
}
