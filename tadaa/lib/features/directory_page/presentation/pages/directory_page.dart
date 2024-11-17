import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/directory_page/presentation/widgets/user_card.dart';
import 'package:tadaa/features/profile_page/data/models/userModel.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_bloc.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_event.dart';
import 'package:tadaa/features/directory_page/presentation/blocs/users_state.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  String searchQuery = "";
  List<UserModel> users = []; // This will hold the list of users

  @override
  void initState() {
    super.initState();
    _fetchAllUsers();
  }

  // Fetch all users from the UserBloc
  void _fetchAllUsers() {
    final userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.add(FetchAllUsers());
    // Listen to the state changes
    userBloc.stream.listen((state) {
      if (state is UsersLoaded) {
        setState(() {
          users = state.users; // Store the fetched users
        }
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Directory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background color of the search bar
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF0F1245)), // Search icon
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Update the search query
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
            UserCardWidget(
              users: users
                  .where((user) => user.name.contains(searchQuery) || (user.position?.contains(searchQuery) ?? false))
                  .toList(), 
            ),
          ],
        ),
      ),
    );
  }
}
