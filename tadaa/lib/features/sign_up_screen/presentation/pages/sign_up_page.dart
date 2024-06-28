import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/core/utils/session_manager.dart';
import 'package:tadaa/features/sign_in_screen/presentation/pages/sign_in_screen.dart';
import 'package:tadaa/features/sign_up_screen/presentation/blocs/sign_up_bloc.dart'; // Import your SignUpBloc and related state classes

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
    context.read<SignUpBloc>().checkIfSignedUp();
  }

  /*oid _submit() {
    if (_formSignUpKey.currentState!.validate()) {
      context.read<SignUpBloc>().verifyRealm(_realmController.text.trim());
    }
  }*/
  void _submit() {
  if (_formSignUpKey.currentState!.validate()) {
    final realm = _realmController.text.trim();
    SessionManager().setRealm(realm);
    context.read<SignUpBloc>().verifyRealm(realm);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSignedUp) { // Ensure SignUpSignedUp is recognized here
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen(realm: state.realm)),
            );
          } else if (state is SignUpVerified) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen(realm: state.realm)),
            );
          } else if (state is SignUpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color.fromARGB(255, 243, 169, 71),
              ),
            );
          }
        },
        child: Container(
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
                                onPressed: _submit,
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
      ),
    );
  }
}
