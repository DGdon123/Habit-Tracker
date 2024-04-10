import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/auth/accountSetup.dart';

class VerificationPage extends StatefulWidget {
  final String password;
  final String userName;
  const VerificationPage(
      {super.key, required this.password, required this.userName});

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
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => AccountSetup(
                      email: currentUser.email,
                      password: widget.password,
                      username: widget.userName,
                    )),
            (route) => false);
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
            Text('Waiting for your email to be verified...'),
          ],
        ),
      ),
    );
  }
}
