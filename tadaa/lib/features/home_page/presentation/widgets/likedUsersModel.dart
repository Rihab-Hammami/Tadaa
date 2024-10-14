import 'package:flutter/material.dart';


class LikedUsersModal extends StatelessWidget {
  final List<Map<String, dynamic>> likedUsers;

  LikedUsersModal({required this.likedUsers});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: likedUsers.isEmpty
          ? Center(child: Text('No likes yet.'))
          : ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5, // Adjust max height as needed
              ),
              child: ListView.builder(
                shrinkWrap: true, 
                itemCount: likedUsers.length,
                itemBuilder: (context, index) {
                  final user = likedUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user['profilePicture'] != null
                          ? NetworkImage(user['profilePicture'])
                          : null, // Use placeholder if no profile pic
                      child: user['profilePicture'] == null
                          ? Icon(Icons.person)
                          : null,
                    ),
                    title: Text(user['name'] ?? 'Unknown User'),
                  );
                },
              ),
            ),
    );
  }
}
