import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/home_page/presentation/widgets/nav_bar.dart';

class SignInScreen extends StatefulWidget {
  final String realm;
  const SignInScreen({Key? key, required this.realm});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn() async {
    final String usernametextfield = _usernameController.text.trim();
    final String passwordtextfield = _passwordController.text.trim();

    if (usernametextfield.isEmpty || passwordtextfield.isEmpty) {
      String message = "";
      if (usernametextfield.isEmpty && passwordtextfield.isEmpty) {
        message = 'Failed: please enter username and password';
      } else if (usernametextfield.isEmpty) {
        message = 'Failed: please enter username';
      } else {
        message = 'Failed: please enter password';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 243, 169, 71),
        ),
      );
      return;
    }

    final Map<String, dynamic> requestBody = {
      'client_id': 'back',
      'client_secret': 'gwvIopPjoe6Dipn9Qd5VkmeH5PRO5Yrs',
      'username': usernametextfield,
      'password': passwordtextfield,
      'grant_type': 'password',
    };

    final response = await http.post(
      Uri.parse('https://auth.preprod.tadaa.work/realms/${widget.realm}/protocol/openid-connect/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: requestBody.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&'),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final accessToken = responseData['access_token'];
      final refreshToken = responseData['refresh_token'];

      // Save tokens in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
      await prefs.setString('realm', widget.realm);

      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );

      // Print access token and refresh token
      print('Access Token: $accessToken');
      print('Refresh Token: $refreshToken');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid username or password',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(255, 243, 169, 71),
        ),
      );
      print('Error signing in: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primary_color,
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
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
              flex: 3,
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
                      key: _formSignInKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Please sign in to continue",
                            style: TextStyle(
                              color: Color.fromARGB(213, 163, 157, 157),
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 30,),
                          TextFormField(
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Username';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text(
                                "Username",
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              hintText: "Enter Username",
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
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text(
                                "Password",
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              hintText: "Enter Password",
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
                              onPressed: () => signIn(),
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.bleu,
                                onPrimary: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text("Sign In", style: TextStyle(fontSize: 15)),
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
}
