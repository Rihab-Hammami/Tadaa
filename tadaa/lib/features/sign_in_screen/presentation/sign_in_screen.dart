import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/home_page/presentation/pages/home_screen.dart';
import 'package:tadaa/features/home_page/presentation/widgets/nav_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();

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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
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
                            "Please Sign In to continue",
                            style: TextStyle(
                              color: Color.fromARGB(213, 163, 157, 157),
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            /*validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Email';
                              }
                              return null;
                            },*/
                            decoration: InputDecoration(
                              label: const Text(
                                "Email",
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              hintText: "Enter Email",
                              prefixIcon: Icon(Icons.email_rounded),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            obscureText: true,
                            /*validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your password';
                              }
                              return null;
                            },*/
                            decoration: InputDecoration(
                              label: const Text(
                                "Password",
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              hintText: "Enter Password",
                              prefixIcon: Icon(Icons.password_sharp),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formSignInKey.currentState!.validate()) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => NavBar()),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColors.bleu,
                                onPrimary: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text("Sign In", style: TextStyle(fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
