import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Auth implements AuthImplementation {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    print(getCurrentUser());
    return getCurrentUser();
  }

  Future<String> signUp(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    print(getCurrentUser());
    return getCurrentUser();
  }

  Future<String> getCurrentUser() async {
    return _firebaseAuth.currentUser.uid;
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }
}
