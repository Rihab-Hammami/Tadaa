/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/sign_in_screen/presentation/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignUpKey = GlobalKey<FormState>();
  final _realmController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {      
    super.initState();
    _checkIfSignedUp();
  }

  Future<void> _checkIfSignedUp() async {
    final prefs = await SharedPreferences.getInstance();
    final bool signedUp = prefs.getBool('signedUp') ?? false;
    final String? accessToken = prefs.getString('accessToken');
    final String? realm = prefs.getString('realm');

    if (signedUp && accessToken != null && realm != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen(realm: realm)),
      );
    }
  }

  Future<void> verifyRealm(BuildContext context) async {
    final String realm = _realmController.text.trim();

    if (realm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: please enter your domain', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: const Color.fromARGB(255, 243, 169, 71),
        ),
      );
      return;
    }

    final response = await http.get(
      Uri.parse('https://auth.preprod.tadaa.work/realms/$realm/.well-known/openid-configuration'),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('signedUp', true);
      await prefs.setString('realm', realm);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen(realm: realm)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: Realm does not exist', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Color.fromARGB(255, 243, 169, 71),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primary_color,
        ),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Image.asset(
                        "assets/logo/logo_white1.png",
                        width: 230,
                        height: 150,
                      ),
                    ),
                    Text(
                      '"Tadaa always present for the best projects"',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.fromLTRB(25.0, 35, 25.0, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formSignUpKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter Domain",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Enter Your Company Domain",
                            style: TextStyle(
                              color: Color.fromARGB(213, 163, 157, 157),
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
                            controller: _realmController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Domain';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text(
                                "Domain name",
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              hintText: "Enter Domain",
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => verifyRealm(context),
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.bleu,
                                onPrimary: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text("Submit", style: TextStyle(fontSize: 15)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
