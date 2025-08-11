import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ecoomerce/auth_screens/login_screen.dart';
import 'package:get/get.dart';
import 'package:ecoomerce/controllers/user_controller.dart';
import 'package:ecoomerce/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});
  final UserController userController =Get.put(UserController());
  @override
  State<SignUpScreen> createState() => _SignupScreenState();

}

class _SignupScreenState extends State<SignUpScreen> {
  bool _isSecurePassword = true ;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    widget.userController.fetchUserData();
    return Scaffold(
      backgroundColor: Color(0xFFFFF9E5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                      onTap: (){ Get.back();},
                      child: Icon(Icons.arrow_back , size: 22 , color: Colors.black)),
                ),
                SizedBox(height: 20.h),

                Center(
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Welcome! please enter your details',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding:  EdgeInsets.all(20.r),
                  child: TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: kTextFieldsInputDecoration.copyWith(
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: kTextFieldsInputDecoration.copyWith(
                      hintText: 'Enter your email',
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isSecurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: kTextFieldsInputDecoration.copyWith(
                        hintText: 'Password',
                        suffixIcon: togglePassword()
                    ),

                  ),
                ),
                SizedBox(height: 50.h),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // minimumSize: Size(150.w, 50.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r)
                      ),
                      padding: EdgeInsets.all(20.r),
                      backgroundColor: Color(0xFF151515) ,
                    ),
                    onPressed: () {
                      final authController = Get.find<AuthController>();
                      authController.signUpWithEmailAndPassword(
                        _nameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Color(0xFFFFF9E5),
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Divider(thickness: 1,color: Colors.black,),
                    Text(
                      'Or sign up with',
                    ),
                    const Divider(thickness: 1,color: Colors.black,),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Button
                    GestureDetector(
                      onTap: () async {
                        try {
                          await authController.signInWithGoogle();
                          Get.snackbar("Success", "Signed in with Google");
                        } catch (e) {
                          Get.snackbar("Error", e.toString());
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png",
                          height: 50.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),

                    // Apple Button ( iOS only)
                    GestureDetector(
                      onTap: () async {
                        try {
                          await authController.signInWithApple();
                          Get.snackbar("Success", "Signed in with Apple");
                        } catch (e) {
                          Get.snackbar("Error", e.toString());
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Icon(Icons.apple, size: 50.sp),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Already have an account? ',
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 18.sp,
                        ),
                      ),
                      TextButton(
                          onPressed:(){ Get.to(()=> LogInScreen());},
                          child: Text(
                            'Log in',
                            style: TextStyle(
                                color: Colors.blue
                            ),)
                      )
                    ]
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
          //],
        ),
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
        color: Color(0xFF151515),
        width: 2.w,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 20.sp,
    ),
  );
}
