import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  var cartItems = <Product>[].obs;
  var isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Load cart when controller initializes
    loadCartFromFirestore();
  }
  // Add item to cart and save to Firestore
  Future<void> addToCart(Product product) async {
    try {
      cartItems.add(product);
      await _saveCartToFirestore();

      Get.snackbar(
        "Added to Cart",
        "${product.name} added to your cart",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print("Error adding to cart: $e");
      // Remove from local list if Firestore save failed
      cartItems.remove(product);
      Get.snackbar(
        "Error",
        "Failed to add item to cart",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Remove item from cart and update Firestore
  Future<void> removeFromCart(Product product) async {
    try {
      cartItems.removeWhere((item) => item.id == product.id);
      await _saveCartToFirestore();

      Get.snackbar(
        "Removed from Cart",
        "${product.name} removed from your cart",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print("Error removing from cart: $e");
      // Re-add to local list if Firestore update failed
      cartItems.add(product);
      Get.snackbar(
        "Error",
        "Failed to remove item from cart",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    try {
      cartItems.clear();
      await _saveCartToFirestore();
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  // Update item quantity
  // Future<void> updateQuantity(Product product, int quantity) async {
  //   try {
  //     int index = cartItems.indexWhere((item) => item.id == product.id);
  //     if (index != -1) {
  //       // Assuming you have quantity field in Product model
  //        //cartItems[index].quantity = quantity;
  //       cartItems.refresh(); // Refresh the observable list
  //       await _saveCartToFirestore();
  //     }
  //   } catch (e) {
  //     print("Error updating quantity: $e");
  //   }
  // }

  // Check if product is in cart
  bool isInCart(Product product) {
    return cartItems.any((item) => item.id == product.id);
  }
  // Get cart item count
  int get cartItemCount => cartItems.length;
  // Calculate total price
  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.price);
  // Save cart to Firestore
  Future<void> _saveCartToFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Convert cart items to Map for Firestore
      List<Map<String, dynamic>> cartData = cartItems.map((product) {
        return {
          'id': product.id,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'category': product.category,
          'tagline': product.tagline,

        };
      }).toList();

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc('items')
          .set({
        'cartItems': cartData,
        'updatedAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print("Error saving cart to Firestore: $e");
      throw e;
    }
  }

  // Load cart from Firestore
  Future<void> loadCartFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) {
      cartItems.clear();
      return;
    }

    try {
      isLoading.value = true;

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc('items')
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> cartData = data['cartItems'] ?? [];

        cartItems.clear();
        for (var item in cartData) {
          cartItems.add(Product.fromMap(item));
        }
      } else {
        cartItems.clear();
      }

    } catch (e) {
      print("Error loading cart from Firestore: $e");
      cartItems.clear();
    } finally {
      isLoading.value = false;
    }
  }
  // Sync cart on user login
  Future<void> syncCartOnLogin() async {
    await loadCartFromFirestore();
  }
  // Clear cart on logout
  void clearLocalCart() {
    cartItems.clear();
  }
}
