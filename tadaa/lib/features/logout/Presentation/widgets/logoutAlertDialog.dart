import 'package:flutter/material.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmationDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Logout'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Are you sure you want to logout?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text('Logout'),
          onPressed: () {
           // Close the dialog
            onConfirm(); // Perform logout
          },
        ),
      ],
    );
  }
}
