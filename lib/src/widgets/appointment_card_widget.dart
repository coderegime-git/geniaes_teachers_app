import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'button_widget.dart';

class AppointmentCardWidget extends StatelessWidget {
  final Widget studentImage, appointmentStatus;
  final String studentName, appointmentTypeName, dateAndTime;

  final VoidCallback onTap;
  const AppointmentCardWidget(
      {super.key,
      required this.studentImage,
      required this.studentName,
      required this.onTap,
      required this.appointmentStatus,
      required this.appointmentTypeName,
      required this.dateAndTime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 7,
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            studentImage,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          studentName,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyTextStyle11,
                        ),
                        appointmentStatus
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Appt: ",
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyTextStyle3,
                        ),
                        Text(
                          appointmentTypeName,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyTextStyle9,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 6.h, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dateAndTime,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.bodyTextStyle15,
                          ),
                          ButtonWidgetFour(
                            buttonText: "",
                            onTap: onTap,
                            innerBorderColor: AppColors.white,
                            icon: const Icon(
                              Icons.remove_red_eye_outlined,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppointmentCardWidgetTwo extends StatelessWidget {
  final Widget studentImage;
  final String studentName, appoinmentTypeName, dateAndTime;

  final VoidCallback onCardTap, onAcceptTap, onRejectTap;
  const AppointmentCardWidgetTwo(
      {super.key,
      required this.studentImage,
      required this.studentName,
      required this.onAcceptTap,
      required this.onRejectTap,
      required this.appoinmentTypeName,
      required this.dateAndTime,
      required this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 4.h),
        margin: EdgeInsets.fromLTRB(8.w, 18.h, 8.w, 18.h),
        decoration: BoxDecoration(
          gradient: AppColors.gradientSix,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 7,
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              // mainAxisSize: MainAxisSize.min,
              children: [
                studentImage,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          studentName,
                          textAlign: TextAlign.start,
                          style: AppTextStyles.bodyTextStyle11,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 3.h),
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(40)),
                          child: Text(dateAndTime,
                              style: AppTextStyles.bodyTextStyle5),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 6.h, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appoinmentTypeName,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.bodyTextStyle11,
                  ),
                  ButtonWidgetSix(
                      onTap: onRejectTap,
                      buttonText: LanguageConstant.reject.tr,
                      buttonTextStyle: AppTextStyles.bodyTextStyle16,
                      borderRadius: 40,
                      buttonColor: AppColors.red),
                  ButtonWidgetSix(
                      onTap: onAcceptTap,
                      buttonText: LanguageConstant.accept.tr,
                      buttonTextStyle: AppTextStyles.bodyTextStyle16,
                      borderRadius: 40,
                      buttonColor: AppColors.green),
                  ButtonWidgetFour(
                    buttonText: "",
                    onTap: onCardTap,
                    innerBorderColor: AppColors.tertiaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
