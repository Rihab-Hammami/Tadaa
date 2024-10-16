import 'package:flutter/material.dart';
import 'package:tadaa/features/directory_page/presentation/widgets/user_card.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({super.key});

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directory',style: TextStyle(fontWeight: FontWeight.bold),),
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
            // Handle search input changes if needed
            print('Search query: $value');
          },
        ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:18.0,vertical: 8),
              child: Container(
                height: 1,
                color: Colors.grey,
              ),
            ),
            UserCardWidget(),           
          ],
        ),
      ),
    );
  }
}