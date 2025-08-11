import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecoomerce/models/product_model.dart';

class ProductController extends GetxController {
  var productList = <Product>[].obs;
  var filteredList = <Product>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final String response = await rootBundle.loadString('lib/data/dummy_products.json');
    final data = json.decode(response) as List;

    productList.value = data.map((e) => Product.fromJson(e)).toList();
    categories.value = productList.map((e) => e.category).toSet().toList();
    filteredList.assignAll(productList);
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    filteredList.value =
        productList.where((p) => p.category == category).toList();
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    filteredList.value = productList.where((p) {
      return p.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void clearFilters() {
    selectedCategory.value = '';
    searchQuery.value = '';
    filteredList.assignAll(productList);
  }
}
