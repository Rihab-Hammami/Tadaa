import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/home_page/presentation/pages/home_screen.dart';
import 'package:tadaa/features/logout/logout.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/datePickerWidget.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/infoWidget.dart';
import 'package:http/http.dart' as http;
import 'package:tadaa/features/sign_in_screen/presentation/sign_in_screen.dart';
class AboutWidget extends StatefulWidget {
  const AboutWidget({Key? key}) : super(key: key);

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  String infoText = 'Initial Info'; // Initial value of the text
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: const Text("Info"),
                subtitle: infoText.isNotEmpty ? Text(infoText) : Text("Enter your information"), // Display the infoText
                leading: Icon(Icons.info),
                trailing: GestureDetector(
                  onTap: () {
                    // Navigate to InfoWidget and receive the entered text
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InfoWidget(
                          initialText: infoText, // Pass the initial value of infoText
                          onSubmit: (text) {
                            setState(() {
                              infoText = text; // Update the infoText with the entered text
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.edit, size: 20),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: const Text("Date of birth"),
                subtitle: selectedDate != null
                    ? Text(selectedDate.toString()) // Display the selected date
                    : Text("Tap to select date"), // Display default text
                leading: Icon(Icons.date_range),
                trailing: GestureDetector(
                  onTap: () {
                    // Show the date picker
                    _showDatePicker(context);
                  },
                  child: Icon(Icons.edit, size: 20),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: const Text("Logout"),
                subtitle: Text("tap to logout"), // Display default text
                leading: Icon(Icons.logout),
                onTap: (){},
                
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the date picker
  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
   

  
}
