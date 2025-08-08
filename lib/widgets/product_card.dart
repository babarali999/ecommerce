import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFFF9E5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 5.h),
          Padding(
              padding: EdgeInsets.only(left: 5.h),
              child: Text(product.name, style:  TextStyle(fontWeight: FontWeight.bold))),
          Padding(
              padding: EdgeInsets.only(left:5.h),
              child: Text("\$${product.price.toStringAsFixed(2)}")),
          Padding(
              padding: EdgeInsets.only(left: 5.h),
              child: Text(product.tagline, style:  TextStyle(fontSize: 12.sp))
          ),
          SizedBox(height: 5.h)
        ],
      ),
    );
  }
}
