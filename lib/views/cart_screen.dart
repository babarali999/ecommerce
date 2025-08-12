import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E5),
      appBar: AppBar(title: Text('My Cart'),centerTitle: true,backgroundColor: Color(0xFFFFF9E5),),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(child: Text('No items in cart'));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final product = cartController.cartItems[index];
            return Card(
              color: Color(0xFFDCD0A8),
              margin: EdgeInsets.symmetric(vertical: 10.h),
              child: ListTile(
                leading: CachedNetworkImage(imageUrl:  product.imageUrl, width: 50.w, height: 50.h,
                errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => cartController.removeFromCart(product),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() => Container(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(
          'Total: \$${cartController.totalPrice}',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
          ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF151515)),
              child: Text('Pay to proceed',style: TextStyle(color: Color(0xFFFFF9E5)),)
          )
       ],
      )
      ), 
    ),
    );
  }
}
