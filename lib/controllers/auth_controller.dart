import 'package:ecommerce/controllers/user_controller.dart';
import 'package:ecommerce/auth_screens/login_screen.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/views/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart' ;
import 'package:ecommerce/auth_screens/login_screen.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  late Rx<User?> firebaseUser ;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading= false.obs ;

  @override
  void onReady(){
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser) ;
    firebaseUser.bindStream(_auth.authStateChanges());

    ever(firebaseUser,_setInitialScreen);
  }

  String getFriendlyFirebaseErrorMessage(errorCode){
    //print('Normalized error code for comparison:"$errorCode" ');
    switch (errorCode){
      case'email-already-in-use' :
        return 'Please use an other email ';
      case'invalid-email':
        return 'please enter correct email' ;
      case'invalid-credentials' :
        return 'please enter correct email or password' ;
      case 'user-disabled':
        return 'This account has been disabled, Please contact support for help';
      case'user-not-found':
        return 'We could not find an account with this email, Please SignUp!' ;
      case 'wrong-password':
        return 'Enter a valid password' ;
      case 'weak-password':
        return ' Your password is too weak , please use Strong password';
      case 'network-request-failed':
        return'Network error. Check your internet connection or try again later';
      case 'too-many-requests':
        return 'too many unsuccessful login attempts, try again later or reset your password';
      default:
        return 'An error occured, please try again later!' ;
    }
  }


  Future<void> _setInitialScreen(User? user) async {
    if(user == null){
      Get.offAll(() => const LogInScreen());
    }
    else {
      try {
        final userController = Get.find<UserController>();

        await userController.fetchUserData();

        Get.offAll(() => HomeScreen());
      }catch(e){
        print("Error in _setInitialScreen: $e" ) ;
      } }
  }

  Future<void> signUpWithEmailAndPassword(String name, String email, String password) async {
    try {
      print(email);
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,);

      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,

      });

    } on FirebaseAuthException catch (e) {
      print(e);
      String friendlyError = getFriendlyFirebaseErrorMessage(e.code);
      //print(friendlyError);
      Get.snackbar("Signup error", friendlyError,
          backgroundColor: Color(0xFFFF0000), colorText: Color(0xFFFFFFFF));
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    isLoading.value = true ;
    try{
      print('2222222222');

      final userCredentials= await _auth.signInWithEmailAndPassword(email: email, password: password);
      print(userCredentials);
      Get.to (() =>HomeScreen()) ;
    }
    on FirebaseAuthException catch (e){
      Get.snackbar("Login error", getFriendlyFirebaseErrorMessage(e.code),
          backgroundColor: Color(0xFFFF0000),colorText: Color(0xFFFFFFFF));
    } finally{
      isLoading.value = false ;
    }
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }

}