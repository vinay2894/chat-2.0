import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  Auth._();

  static final Auth auth = Auth._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<User?> createNewUser(
      {required String email, required String password}) async {
    UserCredential? userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log("$e");
    }

    if (userCredential != null) {
      return userCredential.user;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential? userCredential;

    try {
      userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log("$e");
    }

    return userCredential!.user;
  }

  Future<User?> signInWithGoogle() async {
    GoogleSignInAccount? google = await googleSignIn.signIn();

    GoogleSignInAuthentication? googleSignInAuthentication =
        await google?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );
    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);

    return userCredential.user;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
