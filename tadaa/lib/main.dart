import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tadaa/features/addPost_page/domain/repositories/post_repository.dart';
import 'package:tadaa/features/addPost_page/presentation/blocs/PostBloc.dart';
import 'package:tadaa/features/marketPlace_page/domain/repositories/cartRepository.dart';
import 'package:tadaa/features/marketPlace_page/domain/repositories/productRepository.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/cart_bloc.dart';
import 'package:tadaa/features/marketPlace_page/presentation/blocs/product_bloc.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/notification_page/presentation/blocs/notification_bloc.dart';
import 'package:tadaa/features/profile_page/domain/repositories/profileRepository.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/sign_up_screen/data/data_sources/realm_api.dart.dart';
import 'package:tadaa/features/sign_up_screen/data/repositories_impl/realm_repository_impl.dart';
import 'package:tadaa/features/sign_up_screen/domain/repositories/realm_repository.dart';
import 'package:tadaa/features/sign_up_screen/domain/use_cases/verify_realm_use_case.dart';
import 'package:tadaa/features/sign_up_screen/presentation/blocs/sign_up_bloc.dart';
import 'package:tadaa/features/splash_screen/presentation/pages/splash_screen.dart';
import 'package:tadaa/features/story_page/domain/repositories/storyRepository.dart';
import 'package:tadaa/features/story_page/presentation/blocs/story_bloc.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';
import 'package:tadaa/features/wallet_page/presentation/bloc/walletBloc.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import this for initializing locales

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'AIzaSyCdl2HqEFyXf2DUXA4Thu0L0LJPr0SibtE',
    appId: '1:372528255087:android:77d7705d8d5c8b5a6f7d9a',
    messagingSenderId: '372528255087',
    projectId: 'tadaaapp-33206',
    storageBucket: 'tadaaapp-33206.appspot.com',
  )
);
  await initializeDateFormatting('fr_FR', null);

   final storyRepository = StoryRepository(
    walletRepository: WalletRepository(),
    notificationRepository: NotificationRepository(),
    profileBloc: ProfileBloc(ProfileRepository(),)
  );
  await storyRepository.expireStories();

  
  runApp(
    MultiProvider(
      providers: [      
        Provider<RealmApi>(
          create: (_) => RealmApi(
            baseUrl: 'https://auth.preprod.tadaa.work',
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

        Provider<ProfileRepository>(
          create: (_) => ProfileRepository(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(context.read<ProfileRepository>()),
        ), 
         Provider<WalletRepository>(
      create: (_) => WalletRepository(), // Ensure you have this provider
    ),
      Provider<NotificationRepository>(
      create: (_) => NotificationRepository(), // Ensure you have this provider
    ),
    Provider<PostRepository>(
      create: (context) => PostRepository(
        walletRepository: context.read<WalletRepository>(),
        profileBloc: context.read<ProfileBloc>(),
        notificationRepository: context.read<NotificationRepository>()
        ), 
    ),

    Provider<CartRepository>(
      create: (_) => CartRepository(), 
    ),
     BlocProvider(
          create: (context) => CartBloc(
            context.read<CartRepository>(),
            context.read<ProfileRepository>(),
            context.read<ProfileBloc>(),
            context.read<WalletRepository>(),
            ),
        ),
     Provider<ProductRepository>(
      create: (_) => ProductRepository(), 
    ),
    BlocProvider(
          create: (context) => ProductBloc(
            context.read<ProductRepository>(),
            ),
        ),
      Provider<StoryRepository>(
  create: (context) => StoryRepository(
    walletRepository: context.read<WalletRepository>(),           // Pass WalletRepository
    notificationRepository: context.read<NotificationRepository>(), // Pass NotificationRepository
    profileBloc: context.read<ProfileBloc>(),                     // Pass ProfileBloc
  ),
),
    BlocProvider(
          create: (context) => StoryBloc(
            storyRepository:context.read<StoryRepository>(), 
            ),
        ),
    BlocProvider(
          create: (context) => WalletBloc(
            context.read<WalletRepository>(),
            context.read<ProfileBloc>(),
            ),
        ),
    BlocProvider(
          create: (context) => NotificationBloc(
            context.read<NotificationRepository>(),
            ),
        ),
    BlocProvider(
      create: (context) => PostBloc(
        context.read<PostRepository>(),
        context.read<WalletRepository>(),
        
      ),
    ),

        

        /*Provider<PostRepository>(
          create: (_) => PostRepository(),
        ),
        BlocProvider(
          create: (context) => PostBloc(context.read<PostRepository>()),
        ), */
         
        
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: Splash_screen(),
      ),
    ),
  );
}

