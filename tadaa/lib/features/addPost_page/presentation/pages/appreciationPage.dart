import 'package:flutter/material.dart';
import 'package:tadaa/Data/users.dart';
import 'package:tadaa/models/user.dart';

class AppreciationPage extends StatefulWidget {
  const AppreciationPage({Key? key}) : super(key: key);

  @override
  _AppreciationPageState createState() => _AppreciationPageState();
}

class _AppreciationPageState extends State<AppreciationPage> {
  late User? _selectedUser;
  late int _selectedPoints;
  String? _selectedAction;

  @override
  void initState() {
    super.initState();
    // Set the initially selected user to null
    _selectedUser = null;
    // Initialize the selected points to 0
    _selectedPoints = 0;
    // Initialize the selected action to null
    _selectedAction = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select the person to appreciate",
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
                  child: DropdownButton<User>(
                    value: _selectedUser,
                    onChanged: (User? newValue) {
                      setState(() {
                        _selectedUser = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<User>(
                        value: null,
                        child: Text("Select person"), // Default text
                      ),
                      ...users.map<DropdownMenuItem<User>>((User user) {
                        return DropdownMenuItem<User>(
                          value: user,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  user.imgUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(user.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedPoints,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedPoints = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            SizedBox(width: 10),
                            Text("10 Point"),
                          ],
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            SizedBox(width: 10),
                            Text("20 Points"),
                          ],
                        ),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            SizedBox(width: 10),
                            Text("30 Points"),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAction = newValue;
                      });
                    },
                    items: [
                      
                      DropdownMenuItem<String>(
                      value: "Faire preuve de gentillesse et de compréhension",
                      child: SizedBox(
                        width: 200, // Set maximum width here
                        child: Text("Faire preuve de gentillesse et de compréhension"),
                      ),
                    ),
                      DropdownMenuItem<String>(
                        value: "Prise d'initiative",
                        child: Text("Prise d'initiative"),
                      ),
                      DropdownMenuItem<String>(
                        value: "Rendre le travail amusant",
                        child: Text("Rendre le travail amusant"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text("Votre message",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(height: 15,),
              TextFormField(              
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your message',
                    border: OutlineInputBorder(),
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
