import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadaa/features/addPost_page/data/models/Post.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostBloc.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostEvent.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostState.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/user/userInfo.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PublicationPage extends StatefulWidget {
  final PostModel? initialPost;

  const PublicationPage({super.key, this.initialPost});

  @override
  State<PublicationPage> createState() => _PublicationPageState();
}

class _PublicationPageState extends State<PublicationPage> {
  File? imageFile;
  late String? existingImageUrl;
  late TextEditingController captionController;
  Map<String, String> taggedUsers = {};
  String? userId;
  Completer<void>? _dialogCompleter;
 

  ValueNotifier<bool> isPostButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    captionController = TextEditingController(
      text: widget.initialPost?.content ?? '',
    );
    taggedUsers = {
      for (var userId in widget.initialPost?.taggedUsers ?? [])
        userId: '' // You will need to fetch and set the user names here
    };
     existingImageUrl = widget.initialPost?.image ?? null;
    _fetchUserId();
     captionController.addListener(_updatePostButtonState);
  }
  

  void _updatePostButtonState() {
    final hasCaption = captionController.text.trim().isNotEmpty;
    final hasTaggedUsers = taggedUsers.isNotEmpty;
    final hasImage = imageFile != null || existingImageUrl != null;
    isPostButtonEnabled.value = hasCaption || hasTaggedUsers|| hasImage;
  }
    @override
  void dispose() {
    captionController.dispose();
    isPostButtonEnabled.dispose(); // Dispose ValueNotifier
    super.dispose();
  }
  
  Future<void> _fetchUserId() async {
    final id = await UserInfo.getUserId();
    setState(() {
      userId = id;
    });
  }

  Future<UserModel?> _fetchUserProfile(String userId) async {
    final profileRepository = ProfileRepository();
    return await profileRepository.getUserProfile(userId);
  }

  /*Future<Map<String, String>> _fetchAllUsers() async {
    final profileRepository = ProfileRepository();
    final users = await profileRepository.getAllUsers();
    return {for (var user in users) user.uid: user.name};
  }*/
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Simple Post'),
        centerTitle: false, // Center the title
        backgroundColor: Colors.transparent, // Set your preferred color
      ),*/
      body: SafeArea(
        child: BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostLoading) {
             // _showLoadingDialog(context);
             CircularProgressIndicator();
            } else if (state is PostCreateSuccess) {
               Navigator.pop(context);
              //_dismissLoadingDialog();
              BlocProvider.of<PostBloc>(context).add(FetchAllPostsEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post created Successfully!')),
              );
              /*Navigator.of(context).pop(); 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post created Successfully!')),
              );
              Navigator.of(context).pop(); */
            } else if (state is PostUpdateSuccess) {
              Navigator.pop(context);
              BlocProvider.of<PostBloc>(context).add(FetchAllPostsEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post updated Successfully!')),
              );
              //_dismissLoadingDialog();
              BlocProvider.of<PostBloc>(context).add(FetchAllPostsEvent());
              /*Navigator.of(context).pop(); 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post updated Successfully!')),
              );
              Navigator.of(context).pop(); */
            }else if (state is PostError) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FutureBuilder<UserModel?>(
                      future: userId != null ? _fetchUserProfile(userId!) : null,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          );
                        }
                        final user = snapshot.data;
                        final profilePictureUrl = user?.profilePicture ?? 'https://example.com/default-profile.jpg';
                        return Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(profilePictureUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    FutureBuilder<Map<String, String?>>(
                      future: _getUserInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error fetching user info');
                        }
                        final userInfo = snapshot.data ?? {};
                        final username = userInfo['username'] ?? 'Unknown';
                        final lastname = userInfo['lastname'] ?? 'Unknown';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$username $lastname', // Info of user who created the post
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                            ),
                            
                          ],
                        ),
                           SizedBox(height: 10), // Add some spacing
                            // Caption Input
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: TextField(
                                controller: captionController,
                                decoration: InputDecoration(
                                  hintText: 'Write a caption...',
                                  border: InputBorder.none,
                                ),
                                maxLines: null, // Allow multiple lines
                                textAlignVertical: TextAlignVertical.top, // Start from top
                              ),
                            ),
                          ],
                        ),
                      ),
                        const Divider(),
                          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                      _updatePostButtonState();
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
                        if (imageFile != null || existingImageUrl != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                // The image (either newly selected or existing)
                                Container(
                                  width: 500,
                                  height: 400,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: imageFile != null
                                          ? FileImage(imageFile!) as ImageProvider
                                          : NetworkImage(existingImageUrl!) as ImageProvider,
                                    ),
                                    border: Border.all(width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                
                                // The remove icon
                                Positioned(
                                  top: 10,
                                  right:10 ,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      //color: Colors.black54,
                                      color: Colors.grey[300]
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.close, color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          // Clear both the imageFile and existingImageUrl
                                          imageFile = null;
                                          existingImageUrl = null;
                                        });
                                        _updatePostButtonState();
                                      },
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        
            


                        /*Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            searchable: true, // Enables the search bar
            searchHint: 'Search users', // Optional: Text displayed in the search bar
            title: Text(
              "Select user",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            selectedColor: Colors.blue,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            buttonText: Text("Select users"),
            onConfirm: (results) {
              setState(() {
                taggedUsers = {for (var id in results) id: users[id]!};
                _updatePostButtonState();
              });
            },
            initialValue: taggedUsers.keys.toList(),
          );
                             
                            },
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () => getImage(source: ImageSource.camera),
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () => getImage(source: ImageSource.gallery),
                        ),
                        const SizedBox(width: 15),
                        IconButton(icon: Icon(Icons.person_add),
                        
                         onPressed: () async {
                          // Fetch all users
                          final users = await _fetchAllUsersAsList();
                          
                          // Call the method to show the custom dialog
                          await _showCustomDialog(context, users);
                        },),
                        const SizedBox(width: 15),
                        
                        /*GestureDetector(
                          onTap: () {
                            BottomModalSheet();
                          },
                          child: const Icon(Icons.more_horiz),
                        ),*/
                      ],
                    ),
                     ValueListenableBuilder<bool>(
              valueListenable: isPostButtonEnabled,
              builder: (context, isEnabled, child) {
                return TextButton(
                  onPressed: isEnabled
                      ? () {
                          final caption = captionController.text;
                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error fetching user ID')),
                            );
                            return;
                          }
                          final shouldRemoveImage = imageFile == null && existingImageUrl == null;
                          BlocProvider.of<PostBloc>(context).add(
                            widget.initialPost == null
                                ? CreatePostEvent(
                                    post: PostModel(
                                      postId: '',
                                      content: caption,
                                      taggedUsers: taggedUsers.keys.toList(),
                                      userId: userId!,
                                      createdAt: DateTime.now(),
                                      type: 'simple',
                                      image: imageFile != null ? null : '',
                                      likes: [],
                                    ),
                                    imageFile: imageFile,
                                    userId: userId!
                                  )
                                : UpdatePostEvent(
                                    postId: widget.initialPost!.postId,
                                    updatedPost: PostModel(
                                      postId: widget.initialPost!.postId,
                                      content: caption,
                                      taggedUsers: taggedUsers.keys.toList(),
                                      userId: userId!,
                                      createdAt: widget.initialPost!.createdAt,
                                      type: 'simple',
                                      image: shouldRemoveImage
                                          ? ''
                                          : widget.initialPost!.image,
                                      likes: widget.initialPost!.likes,
                                    ),
                                    imageFile: imageFile,
                                  ),
                                 
                          );
                           //Navigator.pop(context);
                        }
                      : null, // Disable button if not enabled
                  child: Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? Colors.blue : Colors.grey, // Adjust color when disabled
                    ),
                  ),
                );
                
              },
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

  
   
  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);   
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        existingImageUrl = null;
      });
       _updatePostButtonState();
    }
  }

 void BottomModalSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(5, 0),
                blurRadius: 1,
                color: Colors.grey.withOpacity(.6),
                spreadRadius: 0.5,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  createPostNavigationItem(title: "Take photo", iconData: Icons.camera_alt),
                  const SizedBox(height: 20),
                  createPostNavigationItem(title: "Add photo", iconData: Icons.image),
                  const SizedBox(height: 25),
                  createPostNavigationItem(title: "Add Person", iconData: Icons.person_add),
                  
                ],
              ),
            ),
          ),
        );
      },
    );
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
        _updatePostButtonState();
      });
    }
  });
}
 

  Future<Map<String, String?>> _getUserInfo() async {
    final username = await UserInfo.getUsername();
    final lastname = await UserInfo.getLastname();
    return {'username': username, 'lastname': lastname};
  }

  Widget createPostNavigationItem({required String title, required IconData iconData}) {
    return Row(
      children: [
        Icon(iconData, size: 25),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }
}
