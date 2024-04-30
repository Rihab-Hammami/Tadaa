import 'package:flutter/material.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/sign_in_screen/presentation/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignUpKey=GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        decoration: BoxDecoration(
          gradient: AppColors.primary_color
         
        ),
        
       child: Column(
        children: [
          SizedBox(height: 20,),
          /*const Expanded(
            flex: 1,
            child:SizedBox(height: 5,) 
          ),*/
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
                  topRight: Radius.circular(40.0)
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         "Enter Domain",
                         style:
                         TextStyle(
                           fontSize: 25,
                           fontWeight: FontWeight.bold,
                           ),),
                           Text(
                           "Enter Your Company Domain",
                           style: TextStyle(
                            color: Color.fromARGB(213, 163, 157, 157),
                            fontSize: 20),),
                            SizedBox(height: 30,),
                  
                        TextFormField(
                          validator: (value){
                            if(value==null|| value.isEmpty){
                              return 'Please Enter Domain';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("Domain name",
                            style: TextStyle(fontSize: 18,color: Colors.black),),
                            hintText: "Enter Domain",
                            hintStyle: const TextStyle(
                              color: Colors.grey
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              )
                            )
                          ),
                        ),
                        SizedBox(height: 20,),
                  
                        Center(
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(builder: (context) => SignInScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            // Background color
                            primary: AppColors.bleu,
                            onPrimary: Colors.white, // Text color
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Button padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Button border radius
                            ),
                          ),
                          child: Text("Submit",style: TextStyle(fontSize: 15),),
                        ),
                      ),
                  
                      ],
                    ),
                  ),
                ),
              ),
            )
          )
        ],
       ),
      ),
    );
  }
}