import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:tadaa/core/utils/app_colors.dart';
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
    with SingleTickerProviderStateMixin , AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => false; 
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
  late String currentPosition;
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
    super.build(context); 
    return Scaffold(
        extendBodyBehindAppBar: true, 
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white),
          ),
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
                currentPosition=state.user.position ?? '';
              });
            
            }
          },
         builder: (context, state) {
    if (state is ProfileLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ProfileLoaded) {
      return  Stack(
  children: [
    Container(
      height: 315, 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
            gradient: AppColors.primary_color,
          ),
    ),
    Padding(
      padding: const EdgeInsets.only(top:70),
      child: Column(
        children: [
          SizedBox(height: 10),
          buildProfileImage(state.user.profilePicture),
          SizedBox(height: 20),
          buildProfileContainer(state.user.name, state.user.email, state.user.role, state.user.points),
          SizedBox(height: 20),
          buildTabs(state.user),
        ],
      ),
    ),
  ],
);
    } else if (state is ProfileBioUpdated) {
  return AboutWidget(
    bio: state.bio,
    position: currentPosition,
    birthday: currentBirthday, // Preserve the existing birthday
    onBioUpdated: (newBio) {
      BlocProvider.of<ProfileBloc>(context).add(UpdateBio(newBio));
    },
    onBirthdayUpdated: (newBirthday) {
      // Dispatch event or update state accordingly
      BlocProvider.of<ProfileBloc>(context).add(UpdateBirthday(newBirthday));
    },
    onPositionUpdated: (newPosition) {
      BlocProvider.of<ProfileBloc>(context).add(UpdatePosition(newPosition));
    },
  );
} else if (state is ProfilePositionUpdated) {
  return AboutWidget(
    bio: currentBio,
    birthday: currentBirthday,
    position: currentPosition, // Preserve the existing birthday
    onBioUpdated: (newBio) {
      BlocProvider.of<ProfileBloc>(context).add(UpdateBio(newBio));
    },
    onBirthdayUpdated: (newBirthday) {
      // Dispatch event or update state accordingly
      BlocProvider.of<ProfileBloc>(context).add(UpdateBirthday(newBirthday));
    },
    onPositionUpdated: (newPosition) {
      BlocProvider.of<ProfileBloc>(context).add(UpdatePosition(newPosition));
    },
  );
} 
else if (state is ProfileBirthdayUpdated) {
  return AboutWidget(
    bio: currentBio, 
    position: currentPosition,
    birthday: state.birthday,
    onBioUpdated: (newBio) {
      BlocProvider.of<ProfileBloc>(context).add(UpdateBio(newBio));
    },
    onBirthdayUpdated: (newBirthday) {
      BlocProvider.of<ProfileBloc>(context).add(UpdateBirthday(newBirthday));
    },
    onPositionUpdated: (newPosition) {
      BlocProvider.of<ProfileBloc>(context).add(UpdatePosition(newPosition));
    },
  );
}
else {
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
                _buildTab('About', 0),
                _buildTab('Timeline', 1),
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
                /////////////about/////////
                AboutWidget(
                  bio: user.aboutMe ?? 'No bio available',
                  position: user.position ?? '',
                  birthday: user.birthday ?? DateTime(2000, 1, 1),
                  onBioUpdated: (newBio) {
                    context.read<ProfileBloc>().add(UpdateBio(newBio));
                  },
                   onBirthdayUpdated: (newDate) {
                      context.read<ProfileBloc>().add(UpdateBirthday(newDate));
                    },
                    onPositionUpdated: (newPosition) {
                    context.read<ProfileBloc>().add(UpdatePosition(newPosition));
                  },
                ),
                ///////////////timeline///////
                TimelineWidget(
                userId: userId!, 
                profileRepository: profileRepository, 
                postRepository: postRepository,
                currentUserId: userId!,
              ),
               ///////////reward///////////
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
      CircleAvatar(
        radius: 70,
        backgroundColor: Colors.grey[200],
        backgroundImage: imageFile != null
            ? FileImage(imageFile!)
            : (profilePictureUrl != null
                ? NetworkImage(profilePictureUrl)
                : AssetImage("assets/images/profile.jpg")) as ImageProvider,
      ),
      Positioned(
        bottom: 8,
        right: 15,
        child: GestureDetector(
          onTap: _pickImage,
          child: Icon(
            Icons.camera_alt_sharp,
            color: Colors.white,
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
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              onTap: () {
                _pickImageFromSource(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () {
                _pickImageFromSource(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _pickImageFromSource(ImageSource source) async {
  final pickedFile = await ImagePicker().pickImage(source: source);
  if (pickedFile != null) {
    setState(() {
      imageFile = File(pickedFile.path);
    });

    try {
      final newImageUrl = await _uploadImage(File(pickedFile.path));
      print('New image URL: $newImageUrl');
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

