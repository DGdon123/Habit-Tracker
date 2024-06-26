import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_tracker/auth/forgot_password.dart';
import 'package:habit_tracker/auth/repositories/user_repository.dart';
import 'package:habit_tracker/auth/signup_page.dart';
import 'package:habit_tracker/services/notification_services.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/styles.dart';
import 'package:habit_tracker/utils/textfields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  NotificationServices notificationServices = NotificationServices();
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // notificationServices.setupInteractMeassage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('device_token', value!);
      log('device_token');
      log(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    debugPrint("AUth details: ${FirebaseAuth.instance.currentUser}");
    return Scaffold(
      backgroundColor: AppColors.loginBgColor,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
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
                            'Log In'.tr(),
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
                            hintText: 'Enter your email'.tr(),
                            labelText: 'Email'.tr(),
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
                          controller: passwordController,
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
                          validator: (value) => (value!.isEmpty)
                              ? "Please Enter Password".tr()
                              : null,
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
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen()));
                              },
                              child: Text(
                                'Forgot Pasword?'.tr(),
                                style: AppTextStyles.secondaryLogin,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 40.h,
                      ),
                      // continue button

                      user.status == Status.Authenticating
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: CustomButton(
                                text: 'CONTINUE'.tr(),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (!await user.signIn(
                                        context,
                                        usernameController.text,
                                        passwordController.text)) {}
                                  }
                                  // Add your button click logic here
                                  print('Button clicked!');
                                },
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
                              'Or Sign In With'.tr(),
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
                              'New Here?'.tr(),
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
                                      child: const SignUp(),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Create Account'.tr(),
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
            context.read<UserRepository>().signInWithGoogle(context);
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
        GestureDetector(
          onTap: () async {
            await context.read<UserRepository>().signInWithFacebook(context);
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
                AppIcons.facebook,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 35.w,
        ),
        // button login with apple
        GestureDetector(
          onTap: () async{
            await context.read<UserRepository>().signInWithApple(context: context);
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
                AppIcons.apple,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
