// lib/features/sign_in_screen/presentation/widgets/sign_in_form.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Use Provider for state management
import 'package:tadaa/features/sign_in_screen/presentation/bloc/sign_in_bloc.dart';
import 'package:tadaa/core/utils/app_colors.dart';

class SignInForm extends StatefulWidget {
  final String realm;

  const SignInForm({Key? key, required this.realm}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

@override
  void initState() {
    super.initState();
    // Pre-fill the username and password
    _usernameController.text = "rihab";
    _passwordController.text = "rihab123";
  }

  @override
  Widget build(BuildContext context) {
    final signInBloc = Provider.of<SignInBloc>(context, listen: false);
    return Form(
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
                          onPressed: () {
                            if (_formSignInKey.currentState!.validate()) {
                              signInBloc.signIn(
                                context,
                                widget.realm,
                                _usernameController.text.trim(),
                                _passwordController.text.trim(),
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
                    child: Text("Sign In", style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
            ),
          );
      }
}
