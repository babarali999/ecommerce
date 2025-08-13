import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  RxString userName = ''.obs;
  RxString userEmail = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Remove fetchUserData from onInit to avoid conflicts
    // Let AuthController handle the initial fetch
    print("UserController initialized");
  }

  Future<void> fetchUserData() async {
    try {
      print("=== UserController fetchUserData called ===");
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No current user found in UserController");
        clearUserData();
        return;
      }

      print("Fetching data for user: ${user.email}");

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          userName.value = data['name'] ?? '';
          userEmail.value = data['email'] ?? user.email ?? '';

          print("User data loaded: ${userName.value}, ${userEmail.value}");
        } else {
          print("User document exists but data is null");
          // Fallback to Firebase Auth data
          userName.value = user.displayName ?? '';
          userEmail.value = user.email ?? '';
        }
      } else {
        print("User document not found in Firestore");
        // Create user document if it doesn't exist
        await createUserDocument(user);
      }

      print("UserController fetchUserData completed successfully");
    } catch (e) {
      print("Error in UserController fetchUserData: $e");

      // Fallback to Firebase Auth data on error
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userName.value = user.displayName ?? '';
        userEmail.value = user.email ?? '';
      }

      // Don't throw error, just log it
      // throw e; // Remove this to prevent AuthController from getting stuck
    } finally {
      isLoading.value = false;
    }
  }

  // Create user document if it doesn't exist
  Future<void> createUserDocument(User user) async {
    try {
      print("Creating user document for: ${user.email}");

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      userName.value = user.displayName ?? '';
      userEmail.value = user.email ?? '';

      print("User document created successfully");
    } catch (e) {
      print("Error creating user document: $e");
      // Don't throw, just use Firebase Auth data
      userName.value = user.displayName ?? '';
      userEmail.value = user.email ?? '';
    }
  }

  // Clear user data on logout
  void clearUserData() {
    userName.value = '';
    userEmail.value = '';
    isLoading.value = false;
    print("User data cleared");
  }

  // Update user data
  Future<void> updateUserData({String? name, String? email}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      Map<String, dynamic> updateData = {};

      if (name != null) {
        updateData['name'] = name;
        userName.value = name;
      }

      if (email != null) {
        updateData['email'] = email;
        userEmail.value = email;
      }

      if (updateData.isNotEmpty) {
        updateData['updatedAt'] = FieldValue.serverTimestamp();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updateData);

        print("User data updated successfully");
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }
}