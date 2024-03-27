import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_tracker/auth/signup_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/screens/home.dart';
import 'package:habit_tracker/services/user_firesotre_services.dart';
import 'package:provider/provider.dart';

import '../login_page.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Authenticating1,
  Unauthenticated
}

class UserRepository with ChangeNotifier {
  final FirebaseAuth _auth;
  User? _user;
  final GoogleSignIn _googleSignIn;
  Status _status = Status.Uninitialized;

  UserRepository.instance()
      : _auth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      // Change to nullable User
      _onAuthStateChanged(firebaseUser!); // Call the method with nullable User
    });
  }

  Status get status => _status;
  User? get user => _user;

  Future<bool> signIn(
      BuildContext context, String email, String password) async {
    try {
      debugPrint("Hello worl");
      _status = Status.Authenticating;
      notifyListeners();

      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // If signInWithEmailAndPassword succeeds, update status and return true
      _status = Status.Authenticated;
      notifyListeners();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      return true;
    } catch (e) {
      // If signInWithEmailAndPassword fails, update status based on specific error types
      if (e is FirebaseAuthException) {
        // Handle FirebaseAuthException
        if (e.code == 'invalid-credential') {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  FadeTransition(
                opacity: animation,
                child: SignUp(
                  email: email,
                  password: password,
                ),
              ),
            ),
          );

          log(e.message.toString());
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              reverseTransitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  FadeTransition(
                opacity: animation,
                child: SignUp(
                  email: email,
                  password: password,
                ),
              ),
            ),
          );
          // Handle other FirebaseAuthException errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.code.toString()),
            ),
          );
          log(e.message.toString());
        }
      } else {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                FadeTransition(
              opacity: animation,
              child: SignUp(
                email: email,
                password: password,
              ),
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }

      // Update status and return false
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(
    BuildContext context,
    String username,
    String dob,
    String email,
    String password,
  ) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      debugPrint("Authenticating user repo");

      // Create user with email and password
      final authResponse = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint("Authenticating user repo: ${authResponse}");

      // adding details to the firestore
      UserFireStoreServices().addUser(
          uid: authResponse.user!.uid,
          email: email,
          name: username,
          photoUrl: "");

      // Get the current user
      User? user = _auth.currentUser;

      // Update user profile with username
      await user?.updateDisplayName(username);
      await user?.updatePhotoURL(dob);
      // If createUserWithEmailAndPassword succeeds, update status and return true
      _status = Status.Authenticated;
      notifyListeners();

      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      return true;
    } catch (e) {
      // Handle errors
      if (e is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
        log(e.message.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
        log(e.toString());
      }

      // Update status and return false
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'Password reset link sent successfully. Please check your email.'
                    .tr()),
            titleTextStyle:
                const TextStyle(fontSize: 17, color: Color(0xff222222)),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  // Perform sign out action
                },
                child: Text('OK'.tr()),
              ),
            ],
          );
        },
      );
      return true;
    } catch (e) {
      // Handle specific error types
      if (e is FirebaseAuthException) {
        // Handle FirebaseAuthException
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
        log(e.message.toString());
      } else {
        // Handle other types of errors (if any)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }

      // Update status and return false
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      _status = Status.Authenticating1;
      notifyListeners();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResponse = await _auth.signInWithCredential(credential);

      // adding details to the firestore
      UserFireStoreServices().addUser(
          uid: authResponse.user!.uid,
          email: authResponse.user!.email.toString(),
          name: authResponse.user!.displayName.toString(),
          photoUrl: authResponse.user!.photoURL.toString());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _status = Status.Unauthenticated;
      _user = null; // Clear the user after sign-out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      notifyListeners();
    } catch (e) {
      print("Error signing out: $e");
      // Handle any errors that occur during sign-out
    }
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser != null) {
      _user = firebaseUser;
      _status = Status.Authenticated;
    } else {
      _user = null;
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }
}
