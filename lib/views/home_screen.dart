import 'package:ecoomerce/auth_screens/login_screen.dart';
import 'package:ecoomerce/views/cart_screen.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ecoomerce/controllers/product_controller.dart';
import 'package:ecoomerce/views/product_detail_screen.dart';
import 'package:ecoomerce/widgets/product_card.dart';
import 'package:ecoomerce/views/category_screen.dart';

class HomeScreen extends StatelessWidget {
  final ProductController controller = Get.find();

   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E5),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 15.h),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: (){
                          Get.to(()=> CategoriesScreen());
                        },
                        child: Icon(Icons.menu,color: Colors.black,)
                    ) ,
                    GestureDetector(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Color(0xFFFFF9E5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                content: TextButton(
                                  child: Text(
                                  'View your Cart', style: TextStyle(fontSize: 14.sp, color: Colors.black),),
                                  onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen())),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Log Out', style: TextStyle(color: Colors.red)),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)=> LogInScreen())
                                    ),
                                  )
                                ],
                              );
                            }
                        );
                      },
                      child: Icon(Icons.settings , size: 30.sp,color:Color(0xFF151515)),
                    ),
                  ]
              ),
              SizedBox(height: 20.h),
              TextField(
               decoration:  kTextFieldsInputDecoration.copyWith(
                 prefixIcon: Icon(Icons.search),
                 hintText: 'Search',
                 filled: true,
                 fillColor: Colors.white,
               ),
                onChanged: controller.searchProducts,
              ),
              SizedBox(height: 15.h),
              // Category Filter
              Obx(() {
                return SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final cat = controller.categories[index];
                      final isSelected = cat == controller.selectedCategory.value;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: Color(0xFF151515),
                          backgroundColor: Color(0xFF151515),
                          labelStyle: TextStyle(
                            color: isSelected ? Color(0xFFFFF9E5): Color(0XFFFFF9E5),
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: isSelected ? Colors.black : Colors.grey.shade300,
                            ),
                          ),
                          onSelected: (_) => controller.filterByCategory(cat),
                        ),
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: 10.h),
              // Product Grid
              Expanded(
                child: Obx(() {
                  return GridView.builder(
                    itemCount: controller.filteredList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final product = controller.filteredList[index];
                      return GestureDetector(
                        onTap: () {
                          print('Check Detailed product!!');
                          Get.to(() => ProductDetailScreen(product: product));
                        },
                        child: ProductCard(product: product),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
    currentIndex: 2,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Color(0xFF0F5132),
    unselectedItemColor: Colors.black54,
    items: [
    BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
    BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chats'),
    BottomNavigationBarItem(
    icon: CircleAvatar(backgroundColor: Color(0xFF151515), child: Icon(Icons.home, color: Colors.white),),
    label: '',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
    ),
    );
  }
  InputDecoration kTextFieldsInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.r),
      borderSide: BorderSide(

        color: Color(0xFF151515),
        width: 2.w,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(40.r),
      ),
      borderSide: BorderSide(
        color: Color(0xFF151515),
        width: 2.w,
      ),
    ),
    hintStyle: TextStyle(
      color: Color(0xFF151515),
      fontSize: 20.sp,
    ),
  );
}
