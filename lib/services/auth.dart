import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User? get currentUser;
  Future<User?> signInAnonymously();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Stream<User?> authStateChanges();
}

class Auth extends AuthBase {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> signInAnonymously() async {
    try {
      UserCredential user = await _firebaseAuth.signInAnonymously();
      return user.user;
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user.user;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  User? get currentUser => _firebaseAuth.currentUser;
}
