import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_tracker/auth/repositories/user_repository.dart';
import 'package:habit_tracker/auth/signup_page.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/styles.dart';
import 'package:habit_tracker/utils/textfields.dart';

import '../utils/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.loginBgColor,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
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
                              AppIcons.happy,
                              height: 28.h,
                              width: 28.w,
                              color: AppColors.black,
                            ),
                            // gap between icon and text
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Welcome \nBack!',
                              style: TextStyle(
                                fontFamily: 'SFProText',
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                        // right side character image
                        Image.asset(
                          AppImages.character1,
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
                          'Log In',
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
                        decoration: AppTextFieldStyles.standardInputDecoration(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          textStyle: TextStyle(
                              color: AppColors.hintColor,
                              fontFamily: 'SFProText',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TextFormField(
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
                            hintText: 'Enter your password',
                            labelText: 'Password',
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

                    // sized box below password

                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot Pasword?',
                            style: AppTextStyles.secondaryLogin,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 40.h,
                    ),
                    // continue button

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          Hero(
                            tag: "from-login",
                            child: GestureDetector(
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
                                      child: SignUp(),
                                    ),
                                  ),
                                );
                              },
                              child: CustomButton(
                                text: 'CONTINUE',
                                onPressed: () {
                                  // Add your button click logic here
                                  print('Button clicked!');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
// or sign in with ....
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Or Sign In With',
                            style: AppTextStyles.secondaryLogin,
                          ),
                        ],
                      ),
                    ),
                    //
                    SizedBox(
                      height: 30.h,
                    ),

                    // singnup with google facebook apple
                    signInWith(),
                    SizedBox(
                      height: 40.h,
                    ),

                    // new here create account
                    Hero(
                      tag: "from-login-text",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New Here? ',
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
                                    child: SignUp(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Create Account',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    fontFamily: 'SFProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 69, 24, 174),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
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
