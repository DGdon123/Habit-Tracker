import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:provider/provider.dart';

import 'repositories/user_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: .2,
        shadowColor: AppColors.blue,
        title: Text(
          'Reset Password'.tr(),
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "SfProText"),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                height: 180.h,
                child: Image.asset(AppIcons.forgot),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Text(
                    "Enter the email associated with your account and \nwe'll send an email with instructions to reset your \npassword."
                        .tr(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      letterSpacing: 0.2,
                      fontFamily: "SfProText",
                      fontWeight: FontWeight.normal,
                      color: CupertinoColors.darkBackgroundGray,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: CustomAppForm(
                    isPrefixIconrequired: true,
                    readOnly: false,
                    keyboardType: TextInputType.emailAddress,
                    textEditingController: emailController,
                    prefixIcon: CupertinoIcons.envelope,
                    lable: "Email".tr(),
                    validator: (value) =>
                        (value!.isEmpty) ? "Please Enter Email".tr() : null,
                  ),
                ),
              ),
              user.status == Status.Authenticating
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: CustomButton(
                          text: 'Send'.tr(),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (!await user.resetPassword(
                                context,
                                emailController.text,
                              )) {}
                            }
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppForm extends StatefulWidget {
  const CustomAppForm({
    super.key,
    required this.textEditingController,
    this.textInputAction = TextInputAction.next,
    required this.lable,
    this.validator,
    this.onTap,
    this.maxLines = 1,
    this.isPrefixIconrequired = false,
    this.istextCapitilization = false,
    this.inputMaxLenght = 10,
    this.obscureText = false,
    this.suffixIcon,
    required this.readOnly,
    this.ismaxLength = false,
    this.keyboardType = TextInputType.emailAddress,
    this.sufixWidget,
    this.prefixIcon,
    this.onChanged,
    this.isSuffixIconrequired = false,
  });

  final String lable;
  final bool isPrefixIconrequired;
  final bool isSuffixIconrequired;
  final Widget? sufixWidget;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController textEditingController;
  final bool obscureText;
  final bool istextCapitilization;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool ismaxLength;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final int inputMaxLenght;
  final bool readOnly;
  final int maxLines;
  final void Function(String)? onChanged;
  @override
  _CustomAppFormState createState() => _CustomAppFormState();
}

class _CustomAppFormState extends State<CustomAppForm> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(),
            child: TextFormField(
              onChanged: widget.onChanged,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              cursorColor: CupertinoColors.systemGrey,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              maxLength: widget.ismaxLength ? widget.inputMaxLenght : null,
              obscureText: widget.obscureText,
              controller: widget.textEditingController,
              textCapitalization: widget.istextCapitilization
                  ? TextCapitalization.words
                  : TextCapitalization.none,
              validator: widget.validator,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w100,
                fontFamily: "SfProText",
              ),
              textInputAction: widget.textInputAction,
              decoration: InputDecoration(
                  counterText: "",
                  suffixIcon: widget.isSuffixIconrequired
                      ? Icon(widget.suffixIcon)
                      : null,
                  prefixIcon: widget.isPrefixIconrequired
                      ? Icon(widget.prefixIcon)
                      : null,
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 0.5,
                      color: AppColors.black,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: AppColors.mainBlue,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 0.5,
                      color: AppColors.mainColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  hintText: widget.lable,
                  hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w100,
                      fontFamily: "SfProText")),
            ),
          ),
        ],
      ),
    );
  }
}
