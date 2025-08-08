import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  Future<void> orderViaWhatsapp(BuildContext context) async {
    // Save order to Firestore
    await FirebaseFirestore.instance.collection('orders').add({
      'productId': product.id,
      'productName': product.name,
      'price': product.price,
      'timestamp': Timestamp.now(),
    });
    // Launch WhatsApp
    final String phoneNumber = "923254081099";
    final String message =
        "Hi, I want to order:\n\n${product.name}\n${product.imageUrl} , Please share details";

    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open WhatsApp")),
      );
      return;
    }
    //  Confirmation msg
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order placed! Redirecting to WhatsApp...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E5),
      appBar: AppBar(leading: BackButton()),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(product.imageUrl, fit: BoxFit.cover),
              ),
              SizedBox(height: 16.h),
              Text(product.name,
                  style:  TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)
              ),
              Text('\$${product.price}',
                  style:  TextStyle(fontSize: 18.sp)
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 5.h),
              Text(product.description),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => orderViaWhatsapp(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5CA18C) ,
                  ),
                  child:  Text(
                    'Order via WhatsApp',
                    style: TextStyle(
                        color: Color(0xFFFFF9E5)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}

