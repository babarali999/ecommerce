import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecommerce/auth_screens/sign_up_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controllers/auth_controller.dart';


class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}
class _LogInScreenState extends State<LogInScreen>{
  bool _isSecurePassword = true ;
  final TextEditingController _emailController = TextEditingController() ;
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController =Get.find<AuthController>();


  Widget togglePassword(){
    return IconButton(onPressed: (){
      setState(() {
        _isSecurePassword = !_isSecurePassword ;
      });
    },
        icon: _isSecurePassword ? Icon(Icons.visibility ) :Icon(Icons.visibility_off)
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E5),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ConstrainedBox(
                constraints:BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    SizedBox(height:30.h),
                    Center(
                      child: Text(
                          'Welcome Back',
                          style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                      color: Colors.black,
                      ),
                    ),
                    ),
                    SizedBox(height: 40.h),

                    Padding(
                      padding:  EdgeInsets.all(10.w),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: kTextFieldsInputDecoration.copyWith(
                          hintText: 'Email address',
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding:  EdgeInsets.all(10.w),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _isSecurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: kTextFieldsInputDecoration.copyWith(
                          hintText: 'Password',
                          suffixIcon: togglePassword(),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.h),

                    Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            backgroundColor: Color(0xFF5CA18C),
                            minimumSize: Size(150.w, 80.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r))
                        ),
                        onPressed: authController.isLoading.value ? null :() {
                          print('1111111111');
                          //    authController.isLoading.value = true ;
                          final authController = Get.find<AuthController>();
                          authController.signInWithEmailAndPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                        },
                        child: authController.isLoading.value
                            ? SpinKitChasingDots(color: Color(0xFFFFFFFF),size: 18.sp )
                            : Text(
                            'Login',
                            style:TextStyle(
                                color: Color(0xFFFFF9E5),
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp
                            ),
                        )
                    ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            'Don\'t have an account ',
                            style:TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                            ),
                          ),
                          TextButton(
                              onPressed:(){ Get.to(()=> SignUpScreen());},
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                    color: Colors.red
                                ),)
                          )
                        ]
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
  InputDecoration kTextFieldsInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(40.r),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.w,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(40.r),
      ),
      borderSide: BorderSide(
        color: Color(0xFF20B689),
        width: 2.w,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 20.sp,
    ),
  );
}