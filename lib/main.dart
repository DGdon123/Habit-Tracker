import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart' as pre;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/auth/login_page.dart';
import 'package:habit_tracker/onboarding/onboardingScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/provider/avg_sleep_provider.dart';
import 'package:habit_tracker/provider/dob_provider.dart';

import 'package:habit_tracker/pages/auth_onboarding_deciding_screen.dart';
import 'package:habit_tracker/provider/start_end_date_provider.dart';

import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'auth/repositories/user_repository.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  await pre.Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserRepository.instance()),
      ChangeNotifierProvider(create: (_) => SelectedDateProvider()),
      ChangeNotifierProvider(create: (_) => StartEndDateProvider()),
      ChangeNotifierProvider(create: (_) => AvgSleepProvider()),
    ],
    child: EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('es', 'ES')
      ],
      path: 'assets/translations', // Path to your translation files
      fallbackLocale: const Locale('en', 'US'), // Default language
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            home: const HomePage1(),
          );
        });
  }
}

class HomePage1 extends StatelessWidget {
  const HomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(
      builder: (context, user, _) {
        switch (user.status) {
          case Status.Uninitialized:
            return const OnBoardingScreen();
          case Status.Unauthenticated:
            return const LoginScreen();
          case Status.Authenticating:
            return const LoginScreen();
          case Status.Authenticating1:
            return const LoginScreen();
          case Status.Authenticated:
            return HomePage();
        }
      },
    );
  }
}
