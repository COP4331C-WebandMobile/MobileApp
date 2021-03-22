import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpFailure implements Exception {}

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
  }) : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
       _fireStore = fireStore ?? FirebaseFirestore.instance;

    //waits till not NULL

/*Future<String> checkHome(String email) async {
  
  String home; 
  
  try{
    _fireStore..collection('users')
    .doc(email)
    .get()
    .then((DocumentSnapshot documentSnapshot) => {
        home = documentSnapshot.data()["home"]
        });
  }
  on Exception{
    FetchUserFailure();
  }

  return home;
} */


  Future <void> addUser(
    String email,
    String firstName,
    String lastName,
    String phoneNumber, 
    String house,
    ) async{
    try {
    CollectionReference users = _fireStore.collection('users');
    users.doc(email).set({
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'house_name': house,
      });
    }
    on Exception{
      AddUserFailure();
    }
  }

  // Stream of User which will emit the current user whenever authentication state changes.
  // If user isn't authenticated then the empty user is returned.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
    });
  }

  Stream<User> get userChanges {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      
      if(firebaseUser == null)
        return User.empty;
      else
      {
        if(!firebaseUser.emailVerified)
          return User.empty;
        else
          return firebaseUser.toUser;
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
      assert (email != null && password != null);
      try {
          final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
    
        newUser.user.sendEmailVerification();

        addUser(
          email,
          firstName = "testing",
          lastName ="test",
          phoneNumber ="testing",
          "",
          );
  
      }
      on Exception catch(e){
        print(e);
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
      
      if(!tempUser.user.emailVerified)
      {
        throw LogInEmailVerificationFailure();
      }

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

  // Sends an email to reset password.
  Future<void> passwordReset({
    @required String email,
  })
  async {
    assert(email != null);

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }
    on Exception {
      throw PasswordResetFailure();
    }

  }

}

extension on auth.User {
  User get toUser {
    return User(
      id: uid,
      email: email,
      isVerified: emailVerified,
      name: displayName,
      photo: photoURL,
      houseName:"",
    );
  }

}