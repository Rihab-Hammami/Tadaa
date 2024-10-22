import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tadaa/core/utils/session_manager.dart';
import 'package:tadaa/features/logout/Presentation/widgets/logout_widget.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/infoWidget.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/listTileWidget.dart';
import 'package:tadaa/features/profile_page/presentation/widgets/positionWidget.dart';


class AboutWidget extends StatefulWidget {
  final String bio;
  final DateTime birthday;
  final String position;
  final ValueChanged<String> onBioUpdated;
  final ValueChanged<DateTime> onBirthdayUpdated;
  final ValueChanged<String> onPositionUpdated;
  const AboutWidget({
    Key? key,
    required this.bio,
    required this.birthday,
    required this.onBioUpdated,
    required this.onBirthdayUpdated,
    required this.onPositionUpdated, 
    required this.position,
  }) : super(key: key);

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  late String infoText;
  late String positionText;
  late DateTime selectedDate;
  String? realm;
  String? refreshToken;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
    infoText = widget.bio;
    selectedDate = widget.birthday;
    positionText=widget.position;
     
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
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Confirm Logout',
      desc: 'Are you sure you want to logout?',
      btnCancelOnPress: () {
        // This will just close the dialog
      },
      btnOkOnPress: () async {
        if (realm != null && refreshToken != null) {
          await logout(context, realm!, refreshToken!);
        }
      },
      
      btnOkText: 'Logout',
      btnCancelText: 'Cancel',
      btnOkColor: Colors.blue, // Confirm button color
      btnCancelColor: Colors.grey,
      
    ).show();
  }
 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTileWidget(
            child: ListTile(
              title: const Text("About Me",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF0F1245)),),
              subtitle: infoText.isNotEmpty
                  ? Text(infoText)
                  : Text("Enter your information"),
              leading: Icon(Icons.person,color: Color(0xFF0F1245)),
              trailing: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoWidget(
                        initialText: infoText,
                        onSubmit: (text) {
                          setState(() {
                            infoText = text;
                          });
                          widget.onBioUpdated(text);
                        },
                      ),
                    ),
                  );

                  if (result != null && result is String) {
                    setState(() {
                      infoText = result;
                    });
                    widget.onBioUpdated(result);
                  }
                },
                child: Icon(Icons.arrow_forward_ios_outlined, size: 20,color: Color(0xFF0F1245),),
              ),
            ),
          ),
          SizedBox(height: 8),
          ListTileWidget(
            child: ListTile(
              title: const Text("Date of birth",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF0F1245))),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
              leading: Icon(Icons.date_range,color: Color(0xFF0F1245),),
              trailing: GestureDetector(
                onTap: () {
                  _showDatePicker(context);
                },
                child: Icon(Icons.arrow_forward_ios_outlined, size: 20,color: Color(0xFF0F1245),),
              ),
            ),
          ),
          SizedBox(height: 8),
          ListTileWidget(
            child: ListTile(
              title: const Text("Position",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF0F1245))),
              subtitle:positionText.isNotEmpty
                  ? Text(positionText)
                  : Text("Enter your position"),
              leading: Icon(Icons.business_center,color: Color(0xFF0F1245),),
              trailing: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PositionWidget(
                        initialText: positionText,
                        onSubmit: (text) {
                          setState(() {
                            positionText = text;
                          });
                          widget.onPositionUpdated(text);
                        },
                      ),
                    ),
                  );

                  if (result != null && result is String) {
                    setState(() {
                      positionText = result;
                    });
                    widget.onPositionUpdated(result);
                  }
                },
                child: Icon(Icons.arrow_forward_ios_outlined, size: 20,color: Color(0xFF0F1245),),
              ),
            ),
          ),
          SizedBox(height: 8),
          ListTileWidget(
            child: ListTile(
              title: const Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF0F1245))),
              subtitle: Text("Tap to logout"),
              leading: Icon(Icons.logout,color: Color(0xFF0F1245),),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ),
           
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      widget.onBirthdayUpdated(pickedDate);
    }
  }

}
