import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static void createUser({String email, String password}) async {
    AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    print(user.email);
  }
}