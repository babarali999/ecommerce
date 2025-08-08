import 'package:ecommerce/auth_wrapper.dart';
import 'package:ecommerce/controllers/auth_controller.dart';
import 'package:ecommerce/controllers/user_controller.dart';
import 'package:ecommerce/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecommerce/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(ProductController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return ScreenUtilInit(
          designSize: Size(412, 915),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
    return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Inboxed Ecommerce',
          theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AuthWrapper()
    );

 }
      );
}
}