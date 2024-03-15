import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/auth/login_page.dart';
import 'package:habit_tracker/onboarding/onboardingScreen.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/local_storage_services.dart';

class AuthOnBoardingDecidingScreen extends StatelessWidget {
  const AuthOnBoardingDecidingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocalStorageServices().isAppLaunchedFirstTime(),
      builder: (context, snapshot) {
        log("Data: ${snapshot.data}");

        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // If app is launched first time, show onboarding page
          log("APP launched: ${snapshot.data}");
          if (snapshot.data!) {
            return const OnBoardingScreen();
          } else {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const HomePage();
                } else {
                  return const LoginScreen();
                }
              },
            );
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
