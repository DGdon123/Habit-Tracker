import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    setTimerForAutoRedirect();
  }

  void setTimerForAutoRedirect() async {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      var currentUser = FirebaseAuth.instance.currentUser;
      await currentUser!.reload();
      if (currentUser.emailVerified) {
        debugPrint("Email verified");
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Please verify your email'),

            // W
            TextButton(
              child: Text("Continue"),
              onPressed: () async {
                var currentUser = FirebaseAuth.instance.currentUser;
                debugPrint(
                    "Email verified: ${FirebaseAuth.instance.currentUser!.emailVerified}");
                await currentUser!.reload();
                if (currentUser.emailVerified) {
                  debugPrint("Email verified");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
