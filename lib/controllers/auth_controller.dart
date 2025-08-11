import 'package:ecoomerce/controllers/user_controller.dart';
import 'package:ecoomerce/auth_screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecoomerce/views/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  late Rx<User?> firebaseUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  //  Friendly Firebase Error Messages
  String getFriendlyFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Please use another email.';
      case 'invalid-email':
        return 'Please enter a valid email.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up!';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'weak-password':
        return 'Your password is too weak. Use a stronger one.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'too-many-requests':
        return 'Too many login attempts. Try again later.';
      default:
        return 'An error occurred. Please try again later.';
    }
  }

  //  Handle initial navigation based on auth state
  Future<void> _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const LogInScreen());
    } else {
      try {
        final userController = Get.find<UserController>();
        await userController.fetchUserData();
        Get.offAll(() => HomeScreen());
      } catch (e) {
        print("Error in _setInitialScreen: $e");
      }
    }
  }

  //  Email Sign-Up
  Future<void> signUpWithEmailAndPassword(String name, String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
      });

    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Signup Error",
        getFriendlyFirebaseErrorMessage(e.code),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //  Email Sign-In
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Error",
        getFriendlyFirebaseErrorMessage(e.code),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //  Google Sign-In
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      // if new user saved new user data
      if (result.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
          'name': result.user!.displayName,
          'email': result.user!.email,
        });
      }

    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Google Sign-In Error",
        getFriendlyFirebaseErrorMessage(e.code),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //  Apple Sign-In
  Future<void> signInWithApple() async {
    isLoading.value = true;
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final result = await _auth.signInWithCredential(oauthCredential);

      if (result.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
          'name': result.user!.displayName,
          'email': result.user!.email,
        });
      }

    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Apple Sign-In Error",
        getFriendlyFirebaseErrorMessage(e.code),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //  Sign-Out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
