import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;
  var filteredList = <Product>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      print("=== Loading products from JSON ===");
      isLoading.value = true;

      // Load JSON file
      final String response = await rootBundle.loadString('lib/data/dummy_products.json');
      print("JSON loaded successfully");

      // Parse JSON
      final data = json.decode(response) as List;
      print("JSON parsed. Items count: ${data.length}");

      // Convert to Product objects with error handling
      List<Product> loadedProducts = [];

      for (int i = 0; i < data.length; i++) {
        try {
          final productData = data[i];
          print("Processing item $i: ${productData['name'] ?? 'Unknown'}");

          final product = Product.fromJson(productData);
          loadedProducts.add(product);

        } catch (e) {
          print("Error parsing product at index $i: $e");
          print("Product data: ${data[i]}");
          // Continue with next product instead of stopping
        }
      }

      productList.value = loadedProducts;
      categories.value = productList.map((e) => e.category).toSet().toList();
      filteredList.assignAll(productList);

      print("Products loaded successfully. Count: ${productList.length}");
      print("Categories: ${categories.value}");

    } catch (e) {
      print("Error loading products: $e");
      productList.value = []; // Set empty list on error
      categories.value = [];
      filteredList.value = [];

      Get.snackbar(
        "Error",
        "Failed to load products: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String category) {
    try {
      selectedCategory.value = category;

      if (category.isEmpty || category == 'All') {
        filteredList.assignAll(productList);
      } else {
        filteredList.value = productList
            .where((p) => p.category.toLowerCase() == category.toLowerCase())
            .toList();
      }

      print("Filtered by category '$category': ${filteredList.length} products");
    } catch (e) {
      print("Error filtering by category: $e");
    }
  }

  void searchProducts(String query) {
    try {
      searchQuery.value = query;

      if (query.isEmpty) {
        filteredList.assignAll(productList);
      } else {
        filteredList.value = productList.where((p) {
          return p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.description.toLowerCase().contains(query.toLowerCase()) ||
              p.tagline.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }

      print("Searched for '$query': ${filteredList.length} products found");
    } catch (e) {
      print("Error searching products: $e");
    }
  }

  void clearFilters() {
    try {
      selectedCategory.value = '';
      searchQuery.value = '';
      filteredList.assignAll(productList);
      print("Filters cleared. Showing ${filteredList.length} products");
    } catch (e) {
      print("Error clearing filters: $e");
    }
  }

  // Additional helper methods
  // List<Product> getProductsByCategory(String category) {
  //   return productList
  //       .where((product) =>
  //   product.category.toLowerCase() == category.toLowerCase())
  //       .toList();
  // }

  Product? getProductById(String id) {
    try {
      return productList.firstWhere((product) => product.id == id);
    } catch (e) {
      print("Product with ID '$id' not found");
      return null;
    }
  }

  // Get featured products
  // List<Product> getFeaturedProducts({int limit = 10}) {
  //   return productList.take(limit).toList();
  // }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts();
  }
}