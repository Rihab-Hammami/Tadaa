import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/session_manager.dart';
import 'package:tadaa/features/logout/Presentation/widgets/logoutAlertDialog.dart';
import 'package:tadaa/features/logout/Presentation/widgets/logout_widget.dart';
import 'package:tadaa/features/logout/data/logout_service.dart';
import 'package:tadaa/features/sign_in_screen/presentation/pages/sign_in_screen.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/infoWidget.dart';

class AboutWidget extends StatefulWidget {
  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  String infoText = 'Initial Info'; // Initial value of the text
  DateTime? selectedDate;
  String? realm;
  String? refreshToken; // Use refreshToken instead of accessToken

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    final sessionManager = SessionManager();
    final fetchedRealm = await sessionManager.getRealm();
    final fetchedRefreshToken = await sessionManager.getRefreshToken(); // Fetch refreshToken

    setState(() {
      realm = fetchedRealm;
      refreshToken = fetchedRefreshToken;
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return LogoutConfirmationDialog(
          onConfirm: () async {
            if (realm != null && refreshToken != null) {
              await logout(context, realm!, refreshToken!); 
            }
          },
        );
      },
    );
  }

  /*Future<void> _logout(BuildContext context) async {
    final logoutService = LogoutService();
    final success = await logoutService.logout(realm!, refreshToken!);

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen(realm: realm!)),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }*/

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
                subtitle: Text("Tap to logout"), // Display default text
                leading: Icon(Icons.logout),
                onTap: () {
                  if (realm != null && refreshToken != null) {
                    _showLogoutConfirmationDialog(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  
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
