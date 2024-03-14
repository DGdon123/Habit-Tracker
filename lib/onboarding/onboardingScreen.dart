import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/auth/login_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  TextStyle titleStyle = TextStyle(
    fontFamily: 'SFProText',
    color: Colors.white,
    fontSize: ScreenUtil().setSp(40),
    fontWeight: FontWeight.bold,
    height: 0.h,
  );

  TextStyle subTitleStyle = TextStyle(
    fontFamily: 'SFProText',
    color: Color.fromARGB(255, 215, 217, 255),
    fontSize: ScreenUtil().setSp(14),
    fontWeight: FontWeight.w500,
    height: 0.h,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/onboarding background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        pageIndex = index;
                      });
                    },
                    itemCount: onboardings.length,
                    controller: _pageController,
                    itemBuilder: (context, index) => OnboardContent(
                      titleStyle: titleStyle,
                      subTitleStyle: subTitleStyle,
                      image: onboardings[index].image,
                      title: onboardings[index].title,
                      description: onboardings[index].description,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...List.generate(
                        onboardings.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: DotIndicator(isActive: index == pageIndex),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (pageIndex == onboardings.length - 1) {
                            // This is the last onboarding screen, navigate to the next screen
                            // You can replace this with your own logic for navigating to the next screen
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          } else {
                            // Move to the next onboarding screen
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }

                          // _pageController.nextPage(
                          //   duration: Duration(milliseconds: 300),
                          //   curve: Curves.ease,
                          // );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: SvgPicture.asset(
                              AppIcons.forward,
                              color: Color.fromARGB(255, 25, 0, 255),
                              fit: BoxFit.contain,
                              height: 30.h,
                              width: 30.h,
                            ),
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
            )),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isActive ? 15.h : 10.h,
      width: isActive ? 15.w : 10.w,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(100.r),
      ),
    );
  }
}

class Onboard {
  final String title, description, image;

  const Onboard({
    required this.title,
    required this.description,
    required this.image,
  });
}

final List<Onboard> onboardings = [
  const Onboard(
    title: "Track Your\nHabits, Achieve\nYour Goals",
    description:
        "Stay motivated and reach your full potential with our personalized habit tracking tools.",
    image: AppImages.characterFull,
  ),
  const Onboard(
    title: "Unlock Your\nPotential",
    description:
        "Start building positive habits that last with our easy-to-use habit tracker. Track your progress and achieve your goals!",
    image: AppImages.characterFull,
  ),
  const Onboard(
    title: "Make Every Day\nCount",
    description:
        "Small changes lead to big results. Form new habits and unlock a better you!",
    image: AppImages.characterFull,
  ),
];

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.titleStyle,
    required this.subTitleStyle,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  final TextStyle titleStyle;
  final TextStyle subTitleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Image.asset(
          image,
          height: 400.h,
        ),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.left,
                title,
                style: titleStyle,
              ),
              SizedBox(height: 10.h),
              Text(
                textAlign: TextAlign.left,
                description,
                style: subTitleStyle,
              ),
            ],
          ),
        ),
        SizedBox(height: 50.h),
      ],
    );
  }
}
