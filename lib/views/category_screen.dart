import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce/controllers/product_controller.dart';
import 'category_product_screen.dart';

class CategoriesScreen extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E5),
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Color(0xFFFFF9E5),
        elevation: 0,
        title: Text("Categories", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        final categories = productController.categories;

        if (categories.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categoryName = categories[index];
              return Card(
                color: Color(0xFFDCD0A8),
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12.w),
                  title: Text(
                    categoryName,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  //  trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    productController.filterByCategory(categoryName);
                    Get.to(() => CategoryProductsScreen(
                      categoryName: categoryName,
                    ));
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
