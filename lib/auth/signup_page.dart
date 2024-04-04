import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/auth/accountSetup.dart';
import 'package:habit_tracker/auth/login_page.dart';
import 'package:habit_tracker/auth/repositories/user_repository.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:habit_tracker/utils/styles.dart';
import 'package:habit_tracker/utils/textfields.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  final String? email;
  final String? password;
  const SignUp({super.key, this.email, this.password});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  bool _obscureText1 = true;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Handle email controller
    if (widget.email == null || widget.email!.isEmpty) {
      emailController.text = "";
    } else {
      emailController.text = widget.email.toString();
    }

    // Handle password controller
    if (widget.password == null || widget.password!.isEmpty) {
      passwordController.text = "";
    } else {
      passwordController.text = widget.password.toString();
    }

    // Handle confirm password controller
    if (widget.password == null || widget.password!.isEmpty) {
      confirmpasswordController.text = "";
    } else {
      confirmpasswordController.text = widget.password.toString();
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBgColor,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Stack(
              children: [
                Positioned(
                  top: 50.h,
                  left: -45,
                  child: Container(
                    height: 180.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(100.r)),
                  ),
                ),
                Positioned(
                  top: 60.h,
                  right: -45,
                  child: Container(
                    height: 180.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(100.r)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // left side emoji and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 80.h,
                          ),
                          SvgPicture.asset(
                            AppIcons.rocket,
                            height: 32.h,
                            width: 32.w,
                            color: AppColors.black,
                          ),
                          // gap between icon and text
                          SizedBox(
                            height: 0.h,
                          ),
                          Text(
                            "Let's Get \nStarted!",
                            style: TextStyle(
                              fontFamily: 'SFProText',
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      // right side character image
                      Image.asset(
                        AppImages.characterSignup,
                        height: 250.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Login form text
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign Up'.tr(),
                            style: AppTextStyles.loginSignupText,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: TextFormField(
                          controller: usernameController,
                          validator: (value) => (value!.isEmpty)
                              ? "Please Enter UserName".tr()
                              : null,
                          decoration:
                              AppTextFieldStyles.standardInputDecoration(
                            hintText: 'Enter your name'.tr(),
                            labelText: 'Name'.tr(),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) => (value!.isEmpty)
                              ? "Please Enter Email".tr()
                              : null,
                          decoration:
                              AppTextFieldStyles.standardInputDecoration(
                            hintText: 'Enter your email'.tr(),
                            labelText: 'Email'.tr(),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) => (value!.isEmpty)
                              ? "Please Enter Password".tr()
                              : null,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.seperatorColor,
                                  width: 2.w, // Change the width as needed
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.seperatorColor,
                                  width: 2.w, // Change the width as needed
                                ),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors
                                        .seperatorColor), // Adjust the color as needed
                              ),
                              hintText: 'Enter your password'.tr(),
                              labelText: 'Password'.tr(),
                              labelStyle: TextStyle(
                                  color: AppColors.black,
                                  fontFamily: 'SFProText',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                              hintStyle: TextStyle(
                                  color: AppColors.hintColor,
                                  fontFamily: 'SFProText',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.seperatorColor,
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      _obscureText = !_obscureText;
                                    },
                                  );
                                },
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                      // confirm password
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: TextFormField(
                          controller: confirmpasswordController,
                          validator: (value) => (value!.isEmpty)
                              ? "Please Enter Password".tr()
                              : null,
                          obscureText: _obscureText1,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.seperatorColor,
                                  width: 2.w, // Change the width as needed
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.seperatorColor,
                                  width: 2.w, // Change the width as needed
                                ),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors
                                        .seperatorColor), // Adjust the color as needed
                              ),
                              hintText: 'Re-Enter your password'.tr(),
                              labelText: 'Confirm Password'.tr(),
                              labelStyle: TextStyle(
                                  color: AppColors.black,
                                  fontFamily: 'SFProText',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                              hintStyle: TextStyle(
                                  color: AppColors.hintColor,
                                  fontFamily: 'SFProText',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.seperatorColor,
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      _obscureText1 = !_obscureText1;
                                    },
                                  );
                                },
                              )),
                        ),
                      ),

                      // sized box below password
                      SizedBox(
                        height: 20.h,
                      ),
                      // continue button
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            if (passwordController.text !=
                                confirmpasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(
                                  content: Text("Passwords do not match".tr()),
                                ),
                              );
                            } else {
                              // Navigate only if validation passes and passwords match
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountSetup(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    username: usernameController.text,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: CustomButton(
                            text: 'CONTINUE'.tr(),
                            onPressed: () {},
                          ),
                        ),
                      ),

                      // or sign in with ....
                      //                         SizedBox(
                      //                           height: 30.h,
                      //                         ),
                      //                         Padding(
                      //                           padding: EdgeInsets.symmetric(horizontal: 20.w),
                      //                           child: Row(
                      //                             mainAxisAlignment: MainAxisAlignment.center,
                      //                             children: [
                      //                               Text(
                      //                                 'Or Sign Up With',
                      //                                 style: AppTextStyles.secondaryLogin,
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                         //
                      SizedBox(
                        height: 30.h,
                      ),
                      //
                      //                         // singnup with google facebook apple
                      //                         signInWith(),
                      //                         SizedBox(
                      //                           height: 40.h,
                      //                         ),

                      // new here create account
                      Hero(
                        tag: "from-login-text",
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Have an account?'.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    fontFamily: 'SFProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.black,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 500),
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        FadeTransition(
                                      opacity: animation,
                                      child: const LoginScreen(),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Log In'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontFamily: 'SFProText',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color.fromARGB(
                                          255, 69, 24, 174),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row signInWith() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // button login with google
        GestureDetector(
          onTap: () {
            UserRepository.instance().signInWithGoogle(context);
          },
          child: Container(
            width: 65.w,
            height: 65.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                width: 1.w,
                color: AppColors.seperatorColor,
              ),
            ),
            child: SizedBox(
              height: 26.h,
              width: 26.w,
              child: SvgPicture.asset(
                AppIcons.google,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 35.w,
        ),
        // button login with facebook
        Container(
          width: 65.w,
          height: 65.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              width: 1.w,
              color: AppColors.seperatorColor,
            ),
          ),
          child: SizedBox(
            height: 26.h,
            width: 26.w,
            child: SvgPicture.asset(
              AppIcons.facebook,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          width: 35.w,
        ),
        // button login with apple
        Container(
          width: 65.w,
          height: 65.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              width: 1.w,
              color: AppColors.seperatorColor,
            ),
          ),
          child: SizedBox(
            height: 26.h,
            width: 26.w,
            child: SvgPicture.asset(
              AppIcons.apple,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
