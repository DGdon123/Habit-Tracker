import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';

class GoalCompletionScreen extends StatefulWidget {
  const GoalCompletionScreen({super.key});

  @override
  State<GoalCompletionScreen> createState() => _GoalCompletionScreenState();
}

class _GoalCompletionScreenState extends State<GoalCompletionScreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Goals Summary',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'SfProText',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorV,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0.5),
                        color: Colors.black.withOpacity(0.5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Sleep Goals',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600)),
                      Spacer(),
                      Text('April 25, 2024',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier,
                          progress: 75,
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor: AppColors.mainBlue,
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 10,
                          backgroundStrokeWidth: 10,
                          animation: true,
                          seekSize: 6,
                          seekColor: const Color(0xffeeeeee),
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '32/56 hrs',
                                          style: const TextStyle(
                                              fontFamily: "SfProText",
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          'Great!',
                                          style: const TextStyle(
                                              color: CupertinoColors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                      ],
                                    )),
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Sleep Goal for the Week: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '56 hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Sleep Hours Completed: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '32 hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Remaining Sleep Hours: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '24 hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'XP Collected: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '32',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorR,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0.5),
                        color: Colors.black.withOpacity(0.5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Screentime',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600)),
                      Spacer(),
                      Text('April 25, 2024',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier,
                          progress: 63,
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor: AppColors.mainBlue,
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 10,
                          backgroundStrokeWidth: 10,
                          animation: true,
                          seekSize: 6,
                          seekColor: const Color(0xffeeeeee),
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '12/18 hrs',
                                          style: const TextStyle(
                                              fontFamily: "SfProText",
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          'Great!',
                                          style: const TextStyle(
                                              color: CupertinoColors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                      ],
                                    )),
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Screentime for the Week: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '18 hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Screetime Completed: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '12 hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Remaining Screetime: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '6 hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorG,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0.5),
                        color: Colors.black.withOpacity(0.5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Focus time',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600)),
                      Spacer(),
                      Text('April 25, 2024',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier,
                          progress: 25,
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor: AppColors.mainBlue,
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 10,
                          backgroundStrokeWidth: 10,
                          animation: true,
                          seekSize: 6,
                          seekColor: const Color(0xffeeeeee),
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '8/24 hrs',
                                          style: const TextStyle(
                                              fontFamily: "SfProText",
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          'Great!',
                                          style: const TextStyle(
                                              color: CupertinoColors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                      ],
                                    )),
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Focus Goal for the Week: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '24 hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Focus Hours Completed: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '6 hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Remaining Focus Hours: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '16 hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'XP Collected: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '32',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorB,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0.5),
                        color: Colors.black.withOpacity(0.5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Workout Frequency',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600)),
                      Spacer(),
                      Text('April 25, 2024',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier,
                          progress: 66,
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor: AppColors.mainBlue,
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 10,
                          backgroundStrokeWidth: 10,
                          animation: true,
                          seekSize: 6,
                          seekColor: const Color(0xffeeeeee),
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '4/6 days',
                                          style: const TextStyle(
                                              fontFamily: "SfProText",
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          'Great!',
                                          style: const TextStyle(
                                              color: CupertinoColors.black,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                      ],
                                    )),
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Goal Workout Days: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '5 days/week',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Completed Workout Days: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '4 days',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Remaining Days: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '1',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'XP Collected: ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: '4',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
          ],
        ),
      )),
    );
  }
}
