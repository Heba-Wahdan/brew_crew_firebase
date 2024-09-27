// ignore_for_file: avoid_print

import 'package:brew_crew/model/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //here all authentication services

  //create user object based on FirebaseUser according to my custom Users class
  Users? _userFromFirebaseUser(User? user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // Stream to listen to changes in the authentication state.  A stream is like a continuous flow of data that emits new values whenever the authentication state changes.
  Stream<Users?> get user {
    return _auth
        .authStateChanges()
        .map(_userFromFirebaseUser); //it will the pass the user to function
  }

  // 1-sign in Anonymously
  Future signInAnon() async {
    try {
      final result = await _auth.signInAnonymously();
      final user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //2-log in with email & password
  Future logIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //3-register with email & password
  Future register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = result.user;

      // Add error handling for Firestore operation
      await DatabaseService(uid: user!.uid)
          .updateUserData("0", "user name", 100)
          .catchError((error) {
        print("Failed to write to Firestore: $error");
      });

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //4-sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
