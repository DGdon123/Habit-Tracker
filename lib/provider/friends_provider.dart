import 'dart:developer';

import 'package:flutter/material.dart';

class FriendsProvider extends ChangeNotifier {
  List<dynamic> allFriends = [];

  void addAllFriends(List<dynamic> friends) {
    allFriends = friends;

    log("Friends: $allFriends");
    notifyListeners();
  }
}
