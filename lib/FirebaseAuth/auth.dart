
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This function is for:
/// 1 - checking if the user is already signed into the app using Google Sign In
/// 2 - authenticating user using Google Sign In with Firebase Authentication API
/// 3 - retrives some general user related information from their Google account for ease of login process


// Create an instance of GoogleSignIn
final GoogleSignIn googleSignIn = GoogleSignIn();
String? userEmail;
String? imageUrl;

// Define a new function called signInWithGoogle, which we use to handle the Google Sign-In process:
Future<User?> signInWithGoogle() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  User? user;

  if (kIsWeb){
    // The GoogleAuthProvider can only be used while running on the web
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
        await _auth.signInWithPopup(authProvider);
      
      user = userCredential.user;
    } catch (e) {
      print(e);
    }
  } else {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

    if (googleSignInAccount != null){
      final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

      try {
        final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
        
        user = userCredential.user;
      } on FirebaseAuthException catch(e) {
        if(e.code == 'account-exists-with-different-credential'){
          print('The account already exists with a different credential.');
        } else if(e.code == 'invalid-credential'){
          print('Error occurred while accessing credentials. Try Again.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  if (user != null) {
    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
  }

  return user;
}

// In the above implementation, the signInWithGoogle method will only work on the web,
// since the GoogleAuthProvider class is only accessible while running on web
// In order to use Google authentication from your flutter web app, you will have to enable it in the Firebase Authentication settings [DONE]

// For signing out of their Google account
void signOutGoogle() async {
  await googleSignIn.signOut();
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  name = null;
  userEmail = null;
  imageUrl = null;

  print('Signed out of Google account');
}

// Create an instance of FirebaseAuth
final FirebaseAuth _auth = FirebaseAuth.instance;

String? uid;
String? name;

// Authenticating using email and password

/// We will define a new function called registerWithEmailPass thatnwill handle the whole process of registering a new user
/// This function will contain two parameters, an email and a password which will be used to authenticate the user

Future<User?> registerWithEmailPass(String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );

    user = userCredential.user;

    if(user != null) {
      uid = user.uid;
      userEmail = user.email;
    }
  } on FirebaseAuthException catch (e) {
    if(e.code == 'weak-password'){
      print('The password provided is too weak');
    } else if (e.code == 'email-already-in-use') {
      print('There is an existing account for this email');
    }
  } catch (e) {
    print(e);
  }

  return user;
}

Future<User?> signInWithEmailPass(String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;

      // Shared Preferences is used for caching the login status. This is helpful while we set up auto-login in our web app
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print("Wrong password provided.");
    }
  }

  return user;
}

Future<String> signOut() async {
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  userEmail = null;

  return 'User signed out';
}

/// In order to prevent the user from having to log in every time they come back to the web app or reload the page, 
/// we can cache their login status and auto-login when they come bacl

// new function to retrieve user's information if they've already logged in before
Future getUser() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool authSignedIn = prefs.getBool('auth') ?? false;

  final User? user = _auth.currentUser;

  if (authSignedIn == true) {
    if (user != null){
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;
    }
  } 
}