import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  RxString userName = ''.obs;
  RxString userEmail =''.obs;

  @override
  void onInit(){
    super.onInit();
    fetchUserData();
  }
  Future<void> fetchUserData() async{
    final uid = FirebaseAuth.instance.currentUser?.uid ;
    if (uid !=null){
      DocumentSnapshot snapshot  = await FirebaseFirestore.instance.collection('users').doc(uid).get() ;
      if(snapshot.exists){

        userName.value =snapshot['name'] ;
        userEmail.value =snapshot['email'];

      } else{
        print("User doc not found");
      }
    }
  }
}