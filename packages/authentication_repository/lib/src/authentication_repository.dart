import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'models/models.dart';

class SignUpFailure implements Exception {}

class LogInWithEmailAndPasswordFailure implements Exception {}

class LogInWithGoogleFailure implements Exception {}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthenticationRepository({
    auth.FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.standard();
  

  // Stream of User which will emit the current user whenever authentication state changes.
  // If user isn't authenticated then the empty user is returned.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;

    });
  }

  Future<void> register({
    @required String email, 
    @required String password
    }) async {
      assert (email != null && password != null);

      try {
        await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      on Exception {
        throw SignUpFailure();
      }
    }

    Future<void> loginStandard({
      @required String email,
      @required String password,
    }) async {
      assert(email != null && password != null);

      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      on Exception {
        throw LogInWithEmailAndPasswordFailure();
      }

    }

    Future<void> logOut() async {
      try {
        await Future.wait([
          _firebaseAuth.signOut(),
          _googleSignIn.signOut(),
        ]);
      }
      on Exception {
        throw LogOutFailure();
      }
    }
}

extension on auth.User {
  User get toUser {
    return User(
      id: uid,
      email: email,
      name: displayName,
      photo: photoURL
    );
  }
}