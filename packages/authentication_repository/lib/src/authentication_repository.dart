import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpFailure implements Exception {}

class RecentAuthenticationFailure implements Exception {}

class AddUserFailure implements Exception {}

class FetchUserFailure implements Exception {}

class LogInWithEmailAndPasswordFailure implements Exception {}

class LogInEmailVerificationFailure implements Exception {}

class LogInWithGoogleFailure implements Exception {}

class LogOutFailure implements Exception {}

class PasswordResetFailure implements Exception {}

class AuthenticationRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _fireStore;

  AuthenticationRepository({
    auth.FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
    FirebaseFirestore fireStore,
  })  : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _fireStore = fireStore ?? FirebaseFirestore.instance;

  Future<void> addUser(
    String email,
    String firstName,
    String lastName,
    String phoneNumber,
    String house,
  ) async {
    try {
      CollectionReference users = _fireStore.collection('users');

      await users.doc(email).set({
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'house_name': house,
        'total_chores': 0,
      });
    } on Exception {
      throw AddUserFailure();
    }
  }

  User getUser(user) {
    return User(
      id: user.uid,
      email: user.email,
      isVerified: user.emailVerified,
      name: user.displayName,
      photo: user.photoURL,
      houseName: "",
      phoneNumber: user.phoneNumber,
    );
  }

  Stream<User> get user {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return User.empty;
      } else {
        if (!firebaseUser.emailVerified) {
          return User.empty;
        } else {
          return getUser(firebaseUser);
        }
      }
    });
  }

  Future<void> register({
    @required String email,
    @required String password,
    String firstName,
    String lastName,
    String phoneNumber,
  }) async {
    assert(email != null && password != null);

    // Ensures that emails are lowercase when stored in our database.
    email = email.toLowerCase();

    try {
      final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      newUser.user.sendEmailVerification();

      await addUser(email, firstName, lastName, phoneNumber, "");
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> loginStandard({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);

    try {
      var tempUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!tempUser.user.emailVerified) {
        throw LogInEmailVerificationFailure();
      }
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  // Sends an email to reset password.
  Future<void> passwordReset({
    @required String email,
  }) async {
    assert(email != null);
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on Exception {
      throw PasswordResetFailure();
    }
  }

  Future<void> changeEmail(String email) async {
    var user = _firebaseAuth.currentUser;
    try {
      await user.updateEmail(email);
    } on Exception {
      throw RecentAuthenticationFailure();
    }
  }

  Future<void> changePassword(String newPassword) async {
    var user = _firebaseAuth.currentUser;
    try {
      await user.updatePassword(newPassword);
    } on Exception {
      throw RecentAuthenticationFailure();
    }
  }

  Future<void> deleteAccount(String home) async {
    var user = _firebaseAuth.currentUser;
    try {
      await user.delete();

      _fireStore.collection('users').doc(user.email).delete();

    await _fireStore
        .collection('location')
        .doc(home)
        .collection('locations')
        .doc(user.email)
        .delete();

    await _fireStore
        .collection('roomates')
        .doc(home)
        .collection('roomates')
        .doc(user.email)
        .delete();

    await _fireStore.collection('roomates').doc(home).collection('roomates').doc(user.email).collection('chores').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    } on Exception {
      throw RecentAuthenticationFailure();
    }
  }
}
