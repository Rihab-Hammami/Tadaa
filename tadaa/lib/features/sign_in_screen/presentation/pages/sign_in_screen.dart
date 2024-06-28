// lib/features/sign_in_screen/presentation/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadaa/core/utils/app_colors.dart';
import 'package:tadaa/features/sign_in_screen/domain/use_cases/authenticate_user_use_case.dart';
import 'package:tadaa/features/sign_in_screen/data/repositories/authentication_repository.dart';
import 'package:tadaa/features/sign_in_screen/presentation/bloc/sign_in_bloc.dart';
import 'package:tadaa/features/sign_in_screen/presentation/widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  final String realm;

  SignInScreen({Key? key, required this.realm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider<SignInBloc>(
        create: (_) => SignInBloc(
          AuthenticateUserUseCase(AuthenticationRepository()),
        ),
        dispose: (_, bloc) => bloc.dispose(),
        child: Container(
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
                      child: SignInForm(realm: realm),
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
