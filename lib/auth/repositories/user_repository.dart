import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_tracker/auth/automatic_accountSetup.dart';
import 'package:habit_tracker/auth/automaticaccountSetup1.dart';
import 'package:habit_tracker/auth/repositories/gymtime_model.dart';
import 'package:habit_tracker/auth/signup_page.dart';
import 'package:habit_tracker/auth/workout_setup.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/screens/home.dart';
import 'package:habit_tracker/provider/goals_provider.dart';
import 'package:habit_tracker/services/user_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../provider/location_provider.dart';
import '../login_page.dart';
import 'new_gymtime_model.dart';

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
      _status = Status.Authenticating;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('device_token').toString();
      // Sign in with email and password
      final authResponse = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // If signInWithEmailAndPassword succeeds, update status and return true
      _status = Status.Authenticated;

      notifyListeners();

      final isOldUser = await UserFireStoreServices()
          .checkIfUserExists(authResponse.user!.email.toString());

      if (isOldUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }

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

  Future<bool> manualsignUp(
      BuildContext context,
      String username,
      String dob,
      String email,
      String password,
      int sleep,
      int screen,
      int focus,
      int workout) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      debugPrint("Authenticating user repo");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('device_token').toString();
      log(token);
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>  AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(
                color: AppColors.mainBlue,
              ),
              SizedBox(height: 16),
              Text('Please wait, your account is creating...'.tr()),
            ],
          ),
        ),
      );

      var currentUser = FirebaseAuth.instance.currentUser;

      // adding details to the firestore
      UserFireStoreServices()
          .manualaddUser(
        devicetoken: token,
        uid: currentUser!.uid,
        email: email,
        name: username,
        sleep: sleep,
        screen: screen,
        focus: focus,
        workout: workout,
        photoUrl: "",
      )
          .then((_) {
        // Get the current user
        User? user = _auth.currentUser;

        // Update user profile with username
        user?.updateDisplayName(username);

        // If createUserWithEmailAndPassword succeeds, update status and return true
        _status = Status.Authenticated;
        notifyListeners();

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      });

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

  Future<bool> signUp(
      BuildContext context,
      String username,
      String dob,
      String email,
      String password,
      double latitude,
      double longitude,
      int sleep,
      int screen,
      int focus,
      int workout,bool hello) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      debugPrint("Authenticating user repo");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('device_token').toString();

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>  AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(
                color: AppColors.mainBlue,
              ),
              SizedBox(height: 16),
              Text('Please wait, your account is creating...'.tr()),
            ],
          ),
        ),
      );

      var currentUser = FirebaseAuth.instance.currentUser;

      // adding details to the firestore
      UserFireStoreServices()
          .addUser(
        devicetoken: token,
        uid: currentUser!.uid,
        email: email,
        name: username,
        latitude: latitude,
        longitude: longitude,
        sleep: sleep,
        screen: screen,
        focus: focus,
        workout: workout,
        photoUrl: "",
        hello: hello
      )
          .then((_) {
        // Get the current user
        User? user = _auth.currentUser;

        // Update user profile with username
        user?.updateDisplayName(username);

        // If createUserWithEmailAndPassword succeeds, update status and return true
        _status = Status.Authenticated;
        notifyListeners();

        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      });

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
      _status = Status.Authenticated;
      notifyListeners();

      final isOldUser = await UserFireStoreServices()
          .checkIfUserExists(authResponse.user!.email.toString());

      log("Is old user: $isOldUser");
      if (isOldUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutSetUp(
              email: authResponse.user!.email.toString(),
              username: authResponse.user!.displayName.toString(),
              uid: authResponse.user!.uid.toString(),
              photoURL: authResponse.user!.photoURL.toString(),
            ),
          ),
        );
      }

      // adding details to the firestore

      return true;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  

Future<void> signInWithApple({required BuildContext context}) async {
try{

    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);
    // 2. check the result
    
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        _status = Status.Authenticated;
      notifyListeners();

      final isOldUser = await UserFireStoreServices()
          .checkIfUserExists(userCredential.user!.email.toString());

      log("Is old user: $isOldUser");
      if (isOldUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutSetUp(
              email: userCredential.user?.email ?? "",
              username: userCredential.user!.displayName.toString(),
              uid: userCredential.user!.uid.toString(),
              photoURL: userCredential.user?.photoURL ?? "",
            ),
          ),
        );
      }
    }catch(e){
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      
     
    }
            
  }


  Future<bool> signInWithFacebook(BuildContext context) async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ['email', 'public_profile']);

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      final authResponse = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      debugPrint("Authenticating Facebook user repo: $authResponse");
      _status = Status.Authenticated;
      notifyListeners();

      final isOldUser = await UserFireStoreServices()
          .checkIfUserExists(authResponse.user!.email.toString());

      log("Is old user: $isOldUser");
      if (isOldUser) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutSetUp(
              email: authResponse.user!.email.toString(),
              username: authResponse.user!.displayName.toString(),
              uid: authResponse.user!.uid.toString(),
              photoURL: authResponse.user!.photoURL.toString(),
            ),
          ),
        );
      }

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      var boxDataModel = await Hive.openBox<DataModel>('hive_box');
       await boxDataModel.clear();
      var boxDataModel1 = await Hive.openBox<DataModel1>('hive_box1');
       await boxDataModel1.clear();
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
