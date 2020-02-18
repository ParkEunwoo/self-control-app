import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:self_control/firebase/store.dart';

class Auth {
  static void createUser(
      {@required String email, @required String password, @required String name}) async {
    AuthResult result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    Store.createUser(uid: user.uid, name: name);
  }

  static void signIn(
      {@required String email, @required String password}) async {
    AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
  }

  static void signOut() {
    FirebaseAuth.instance.signOut();
  }

  static void resetPassword(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
