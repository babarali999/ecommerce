import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentScreen extends StatelessWidget {
  final double totalprice ;
  const PaymentScreen({super.key, required this.totalprice});

  void _showOrderCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:  Text("Order Completed 🎉"),
        content:  Text("Thanks! Your order of RS.${totalprice.toStringAsFixed(2)} has been placed successfully."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Get.back(); // Go back to previous screen
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showOnlinePaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              "Select Payment Method",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 16.h),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text("JazzCash"),
              onTap: () {
                Navigator.pop(ctx);
                // Implement later JazzCash Payment Logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text("Easypaisa"),
              onTap: () {
                Navigator.pop(ctx);
                // Implement later Easypaisa Payment Logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text("Pay via Debit Card"),
              onTap: () {
                Navigator.pop(ctx);
                // Implement later Debit Card Payment Logic
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E5),
      appBar: AppBar(title: Text("Select Payment Method"), backgroundColor: Color(0xFFFFF9E5), centerTitle: true,
        foregroundColor: Color(0xFF151515),
      ),
      body: Padding(
        padding:  EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 50.h ),
            Text('Total Amount: Rs.${totalprice.toStringAsFixed(2)}',
              style:  TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),),
            SizedBox(height: 30.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF151515),
                foregroundColor: Color(0xFFFFF9E5),
                minimumSize:  Size(double.infinity, 50.h),
              ),
              onPressed: () => _showOrderCompletedDialog(context),
              child:  Text("Cash on Delivery",
                  style: TextStyle(
                      fontSize: 16.sp
                  )),
            ),
             SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF151515),
                foregroundColor: Color(0xFFFFF9E5),
                minimumSize:  Size(double.infinity, 50.h),
              ),
              onPressed: () => _showOnlinePaymentOptions(context),
              child: Text(
                "Pay Online",
                style: TextStyle(
                  fontSize: 16.sp
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
