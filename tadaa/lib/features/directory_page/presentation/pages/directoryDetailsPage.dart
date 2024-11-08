import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/timeLineTabView.dart';
import 'package:tadaa/features/user/userInfo.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';

class DirectoryDetailsPage extends StatefulWidget {
  final UserModel user;

  const DirectoryDetailsPage({super.key, required this.user});

  @override
  State<DirectoryDetailsPage> createState() => _DirectoryDetailsPageState();
}

class _DirectoryDetailsPageState extends State<DirectoryDetailsPage> {
  
  final profileRepository = ProfileRepository();
  final walletRepository = WalletRepository(); 
  String? userID;
  final notificationRepository = NotificationRepository();
  late final postRepository= PostRepository(
  walletRepository: walletRepository,
  profileBloc: BlocProvider.of<ProfileBloc>(context),
  notificationRepository: notificationRepository, // Add the notification repository
  );  

  Future<void> fetchUserId() async {
    final id = await UserInfo.getUserId();
    setState(() {
      userID= id;
    });
  }
  @override
  void initState() { 
  fetchUserId();   
  super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
  
  
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
            ),        
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: 120,
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    gradient: AppColors.primary_color,
                  ),
                  child: Center(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: widget.user.profilePicture != null
                            ? NetworkImage(widget.user.profilePicture!)
                            : AssetImage('assets/images/profile.jpg') as ImageProvider,
                      ),
                      title: Text(
                        widget.user.name ?? 'No Name',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        widget.user.position ?? 'No position',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
             TabBar(
            tabs: [
              Tab(text: "Posts",),
              Tab(text: "Personal Info"),
            ],
            indicatorColor: Color(0xff28BAE8),
          ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab for Posts
                    TimelineWidget(
                       userId: widget.user.uid,
                       profileRepository: profileRepository, 
                       postRepository: postRepository,
                       currentUserId:userID!,
                       ),
                   // Center(child: Text("Posts content goes here")),
                    // Tab for Personal Info
                    PersonalInfoTab(user: widget.user),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PersonalInfoTab extends StatelessWidget {
  final UserModel user;

  const PersonalInfoTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            icon: Icons.email_outlined,
            title: 'Email',
            content: user.email,
          ),
          
          if (user.aboutMe != null && user.aboutMe!.isNotEmpty)
            _buildDivider(),
          if (user.aboutMe != null && user.aboutMe!.isNotEmpty)
            _buildInfoRow(
              icon: Icons.info_outline,
              title: 'About Me',
              content: user.aboutMe!,
            ),
          if (user.birthday != null) _buildDivider(),
          if (user.birthday != null)
            _buildInfoRow(
              icon: Icons.cake_outlined,
              title: 'Birthday',
              content: DateFormat.yMMMd().format(user.birthday!),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Colors.grey[300],
        thickness: 1.0,
      ),
    );
  }
}


