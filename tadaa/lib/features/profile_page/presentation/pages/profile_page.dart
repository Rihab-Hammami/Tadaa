import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_event.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_state.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/aboutTabView.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/rewardsTabView.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/timeLineTabView.dart';
import 'package:tadaa/features/user/userInfo.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final double profileHeight = 144;
  late TabController tabController;
  int _selectedIndex = 0;
  File? imageFile;
  final profileRepository = ProfileRepository();
  //final postRepository = PostRepository();
  final walletRepository = WalletRepository(); 
  final notificationRepository = NotificationRepository();
  late final postRepository; 
  String? userId;
  late String currentBio;
  late DateTime currentBirthday;

  Future<void> _fetchUserId() async {
    final id = await UserInfo.getUserId();
    setState(() {
      userId = id;
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    _fetchUserId();
postRepository = PostRepository(
  walletRepository: walletRepository,
  profileBloc: BlocProvider.of<ProfileBloc>(context),
  notificationRepository: notificationRepository, // Add the notification repository
);     
super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    profileBloc.add(FetchProfile(widget.uid));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            } else if (state is ProfileLoaded) {
              setState(() {
                currentBio = state.user.aboutMe ?? 'No bio available';
                currentBirthday = state.user.birthday ?? DateTime(2000, 1, 1);
              });
            
              // Optionally handle any additional logic when profile is loaded
            }
          },
         builder: (context, state) {
    if (state is ProfileLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ProfileLoaded) {
      return Column(
        children: [
          // Profile picture remains unchanged unless it's specifically updated
          buildProfileImage(state.user.profilePicture),
          buildProfileContainer(state.user.name, state.user.email, state.user.role,state.user.points),
          SizedBox(height: 20),
          buildTabs(state.user),
        ],
      );
    } else if (state is ProfileBioUpdated) {
  // Update only the bio without reloading the entire profile
  return AboutWidget(
    bio: state.bio,
    birthday: currentBirthday, // Preserve the existing birthday
    onBioUpdated: (newBio) {
      // Dispatch event or update state accordingly
      BlocProvider.of<ProfileBloc>(context).add(UpdateBio(newBio));
    },
    onBirthdayUpdated: (newBirthday) {
      // Dispatch event or update state accordingly
      BlocProvider.of<ProfileBloc>(context).add(UpdateBirthday(newBirthday));
    },
  );
} else if (state is ProfileBirthdayUpdated) {
  // Update only the birthday without reloading the entire profile
  return AboutWidget(
    bio: currentBio, // Preserve the existing bio
    birthday: state.birthday,
    onBioUpdated: (newBio) {
      // Dispatch event or update state accordingly
      BlocProvider.of<ProfileBloc>(context).add(UpdateBio(newBio));
    },
    onBirthdayUpdated: (newBirthday) {
      // Dispatch event or update state accordingly
      BlocProvider.of<ProfileBloc>(context).add(UpdateBirthday(newBirthday));
    },
  );
}else {
    // Fallback widget in case none of the states match
    return Center(
      child: Text('Unknown state. Please try again later.'),
    );
  }

  },
        ),
      ),
    );
  }

  Widget buildTabs(UserModel user) {
    return Container(
      height: MediaQuery.of(context).size.height - profileHeight - 20,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: TabBar(
              controller: tabController,
              tabs: [
                _buildTab('Timeline', 0),
                _buildTab('About', 1),
                _buildTab('Rewards', 2),
              ],
              indicatorColor: Color(0xff28BAE8),
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // Add your content for the tabs here
                //Center(child: Text('Timeline View Placeholder')),
               TimelineWidget(
                userId: userId!, 
                profileRepository: profileRepository, 
                postRepository: postRepository,
              ),
                AboutWidget(
                  bio: user.aboutMe ?? 'No bio available',
                  birthday: user.birthday ?? DateTime(2000, 1, 1),
                  onBioUpdated: (newBio) {
                    context.read<ProfileBloc>().add(UpdateBio(newBio));
                  },
                   onBirthdayUpdated: (newDate) {
                      context.read<ProfileBloc>().add(UpdateBirthday(newDate));
                    },
                ),
                // Center(child: Text('Rewards View Placeholder')),
                RewardsWidget(),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileContainer(String name, String email, String role,int points) {
    return Container(
      width: 340,
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
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
              ],
            ),
          ),
          SizedBox(height: 2),
          Text(
            email,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
             color: Color(0xFF0F1245),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                      "assets/icons/coins.png",
                      height: 30,
                      width: 30,
                    ),
                SizedBox(width: 6),
                Text(
                  '$points',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileImage(String? profilePictureUrl) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: imageFile != null
              ? Image.file(
                  imageFile!,
                  width: profileHeight,
                  height: profileHeight,
                  fit: BoxFit.cover,
                )
              : (profilePictureUrl != null
                  ? Image.network(
                      profilePictureUrl,
                      width: profileHeight,
                      height: profileHeight,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/profile.jpg", // Default profile image
                      width: profileHeight,
                      height: profileHeight,
                      fit: BoxFit.cover,
                    )),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: _pickImage,
            child: Icon(
              Icons.edit,
              color: Colors.blue,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String text, int index) {
    bool isSelected = index == _selectedIndex;
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      imageFile = File(pickedFile.path);
    });

    try {
      // Upload the image and get the new image URL
      final newImageUrl = await _uploadImage(File(pickedFile.path));
      print('New image URL: $newImageUrl');

      // Dispatch the event to update the profile picture URL
      BlocProvider.of<ProfileBloc>(context).add(UpdateProfilePicture(newImageUrl));
    } catch (e) {
      print('Error uploading image or updating profile: $e');
    }
  }
}


Future<String> _uploadImage(File imageFile) async {
  try {
    // Create a reference to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref();

    // Create a unique file name
    String fileName = path.basename(imageFile.path);

    // Create a reference to the file location in Firebase Storage
    final fileRef = storageRef.child('profile_images/$fileName');

    // Upload the file to Firebase Storage
    final uploadTask = fileRef.putFile(imageFile);

    // Monitor the upload progress
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
    });

    // Wait for the upload to complete
    final snapshot = await uploadTask;
    print('Upload completed successfully.');

    // Get the download URL of the uploaded file
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('Download URL: $downloadUrl');

    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    throw Exception('Error uploading image: $e');
  }
}



}

