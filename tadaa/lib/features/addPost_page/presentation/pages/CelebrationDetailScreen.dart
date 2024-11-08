import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  child: GestureDetector(
    onTap: () async {
      // Fetch users and show the dialog when the user taps the Padding widget
      final users = await _fetchAllUsersAsList(); // Assuming you have a function that fetches the list
      await _showCustomDialog(context, users); // Show the custom dialog with the users
    },
    child: FutureBuilder<Map<String, String>>(
      future: _fetchAllUsers(), // Keep this to fetch users if needed elsewhere
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
                        border: Border.all(color: Colors.grey, width: 1), // Add border
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_drop_down), // Dropdown arrow icon
                            SizedBox(width: 8),
                            Text("Select users"), // Display a text next to the dropdown icon
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
              padding: const EdgeInsets.symmetric(horizontal: 10,),
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
                /* Padding(
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
                               final users = await _fetchAllUsersAsList();
                                return _showCustomDialog(context, users)
                              },
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