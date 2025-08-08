import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce/views/product_detail_screen.dart';
import 'package:ecommerce/controllers/product_controller.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  final ProductController productController = Get.find<ProductController>();

  CategoryProductsScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E5),
      appBar: AppBar(
        title: Text(categoryName),
        leading: BackButton(),
      ),
      body: Obx(() {
        final products = productController.filteredList;

        if (products.isEmpty) {
          return Center(child: Text("No products found in this category"));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: (){
                Get.to(()=> ProductDetailScreen(product: product));
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    placeholder: (context, url) =>
                        CircularProgressIndicator(strokeWidth: 2),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 50.w,
                    height: 50.h,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text("\$${product.price}"),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}