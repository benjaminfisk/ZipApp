import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:zipapp/models/current_user_model.dart';

class CurrentUserService {
  static final CurrentUserService _instance = CurrentUserService._internal();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String userID = '';
  late Stream<CurrentUser> currentUserStream;
  late StreamSubscription userSub;
  late CurrentUser currentUser;

  factory CurrentUserService() {
    return _instance;
  }

  CurrentUserService._internal() {
    if (kDebugMode) {
      print("CurrentUserService Created with user: $userID");
    }
  }

  void setupService(String id) {
    if (userID != id) {
      userSub.cancel();
      userID = id;
      currentUserStream = _db
          .collection("CurrentRides")
          .doc(userID)
          .snapshots()
          .map((DocumentSnapshot snapshot) {
        return CurrentUser.fromDocument(snapshot);
      });
      userSub = currentUserStream.listen((user) {
        currentUser = currentUser;
      });
      if (kDebugMode) {
        print("CurrentUserService setup with user: $userID");
      }
    }
  }

  Stream<CurrentUser> getUserStream() {
    return _db
        .collection("CurrentRides")
        .doc(userID)
        .snapshots()
        .map((DocumentSnapshot snapshot) {
      return CurrentUser.fromDocument(snapshot);
    });
  }
}
