import 'package:ecoomerce/auth_wrapper.dart';
import 'package:ecoomerce/controllers/auth_controller.dart';
import 'package:ecoomerce/controllers/cart_controller.dart';
import 'package:ecoomerce/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecoomerce/controllers/product_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(ProductController());
  Get.put(CartController());
  runApp(
      DevicePreview(
      enabled :true,
      tools: [
        ...DevicePreview.defaultTools
      ],
      builder: (context) => MyApp())
  );
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
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: (context, widget){
          widget= DevicePreview.appBuilder(context, widget);
          return widget;
        },
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