import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:tadaa/Providers/cartProvider.dart';
import 'package:tadaa/features/onBording_Screens/presentation/onBording_screen.dart';
import 'package:tadaa/features/sign_up_screen/data/data_sources/realm_api.dart.dart';
import 'package:tadaa/features/sign_up_screen/data/repositories_impl/realm_repository_impl.dart';
import 'package:tadaa/features/sign_up_screen/domain/repositories/realm_repository.dart';
import 'package:tadaa/features/sign_up_screen/domain/use_cases/verify_realm_use_case.dart';
import 'package:tadaa/features/sign_up_screen/presentation/blocs/sign_up_bloc.dart';
import 'package:tadaa/features/splash_screen/presentation/pages/splash_screen.dart';

void main(){
  runApp(
    /*ChangeNotifierProvider(
      create: (_) => CartProvider(),
    ),*/
     
    MyApp(),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        Provider<RealmApi>(
          create: (_) => RealmApi(
            baseUrl: 'https://auth.preprod.tadaa.work', // Provide the base URL here
            client: http.Client(),
          ),
        ),
        ProxyProvider<RealmApi, RealmRepository>(
          update: (_, api, __) => RealmRepositoryImpl(api),
        ),
        ProxyProvider<RealmRepository, VerifyRealmUseCase>(
          update: (_, repository, __) => VerifyRealmUseCase(repository),
        ),
        ProxyProvider<VerifyRealmUseCase, SignUpBloc>(
          update: (_, verifyRealmUseCase, __) => SignUpBloc(verifyRealmUseCase),
        ),
      ],
      child:
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',    
      home:  Splash_screen(),
    ));
  }
}



