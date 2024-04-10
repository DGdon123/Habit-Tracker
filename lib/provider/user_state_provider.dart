import 'package:flutter/material.dart';

enum UserState {
  firstTime,
  onBoardingFinished,
  loggedIn, // user is logged in after being verified and data is added
  loggedOut, // user is logged out
  emailVerifiedNeeded, // email and password added, need to verify email now
  userDataNeeded, // email verified, need to add data
}

class UserStateProvider with ChangeNotifier {
  UserState userState = UserState.firstTime;

  void updateState(UserState newState) {
    userState = newState;
    notifyListeners();
  }
}
