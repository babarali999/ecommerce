import 'package:ecoomerce/controllers/user_controller.dart';
import 'package:ecoomerce/controllers/cart_controller.dart'; // Add this import
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
    print("=== _setInitialScreen called ===");
    print("User: ${user?.email}");

    // Reset loading state
    isLoading.value = false;

    if (user == null) {
      print("User is null, going to Login");
      // Clear user data and cart on logout
      if (Get.isRegistered<UserController>()) {
        final userController = Get.find<UserController>();
        userController.clearUserData();
      }
      if (Get.isRegistered<CartController>()) {
        final cartController = Get.find<CartController>();
        cartController.clearLocalCart();
      }
      Get.offAll(() => const LogInScreen());
    } else {
      try {
        print("User found, fetching user data...");
        final userController = Get.find<UserController>();
        await userController.fetchUserData();
        print("User data fetched successfully");

        // Sync cart after successful login (with timeout)
        if (Get.isRegistered<CartController>()) {
          print("Syncing cart...");
          final cartController = Get.find<CartController>();

          // Add timeout to prevent hanging
          await cartController.syncCartOnLogin().timeout(
            Duration(seconds: 10),
            onTimeout: () {
              print("Cart sync timeout, continuing anyway");
            },
          );
          print("Cart sync completed");
        }

        print("Navigating to HomeScreen");
        Get.offAll(() => HomeScreen());
      } catch (e) {
        print("Error in _setInitialScreen: $e");
        // Fallback to login on error
        Get.offAll(() => const LogInScreen());
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
        'createdAt': FieldValue.serverTimestamp(),
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
      if (googleUser == null) {
        isLoading.value = false; // Stop loading if user cancels
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);

      // Save data only for new users
      if (result.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
          'name': result.user!.displayName,
          'email': result.user!.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Navigate to home after login/signup
      Get.offAll(() => HomeScreen());

    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Google Sign-In Error",
        getFriendlyFirebaseErrorMessage(e.code),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error in signin with google: $e");
      Get.snackbar(
        "Error", e.toString(),
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
          'createdAt': FieldValue.serverTimestamp(),
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
    // Clear local cart before signing out
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      cartController.clearLocalCart();
    }

    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}