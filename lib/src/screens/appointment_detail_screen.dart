import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';
import '../repositories/appointment_status_update_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import 'agora_call/repo.dart';

import '../widgets/rating_dialog.dart';
import '../repositories/add_appointment_rating_repo.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key});

  @override
  State<AppointmentDetailScreen> createState() =>
      AppointmentDetailScreenState();
}


class AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  void initState() {
    super.initState();

    final gc   = Get.find<GeneralController>();
    final appt = gc.selectedAppointmentHistoryForView;

    // ── 1. Build a deterministic channel name from appointment ID.
    //        Formula: "appt_{id}" — must match student app exactly.
    final channel = "appt_${appt.id}";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gc.updateChannelForCall(channel);
    });

    // gc.updateChannelForCall(channel);

    // ── 2. Store appointment object so makeAgoraCallRepo can send the
    //        FCM notification payload to the student with the right data.
    gc.appointmentObject = {
      "id"                    : appt.id,
      "student_id"            : appt.studentId,
      "appointment_type_name" : appt.appointmentTypeName ?? "",
      "appointment_type_id"   : appt.appointmentTypeId,
      "teacher_name"          : gc.currentTeacherModel?.loginInfo?.firstName ?? "Teacher",
      "teacher_image"         : gc.currentTeacherModel?.loginInfo?.image ?? "",
    };

    // ── 3. Fetch Agora token only when appointment is accepted (status 2).
    if (appt.appointmentStatusCode == 2) {
      getMethod(
        context,
        "$getAgoraTokenUrl?channel=$channel",
        null,
        true,
        getAgoraTokenRepo,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
        inAsyncCall: generalController.appointmentStatusLoaderController,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              titleText: LanguageConstant.appointmentDetail.tr,
              leadingIcon: "assets/icons/Expand_left.png",
              leadingOnTap: () {
                Get.back();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
              child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: generalController
                                    .selectedAppointmentHistoryForView
                                    .studentImage !=
                                null
                            ? Image(
                                image: NetworkImage(
                                    "$mediaUrl${generalController.selectedAppointmentHistoryForView.studentImage!}"),
                                height: 110.h,
                              )
                            : Image(
                                image: const AssetImage(
                                    'assets/images/teacher-image.png'),
                                height: 110.h,
                              ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // "Jhon Doe",
                            generalController.selectedAppointmentHistoryForView
                                    .studentName ??
                                "",
                            textAlign: TextAlign.start,
                            style: AppTextStyles.bodyTextStyle14,
                          ),
                          SizedBox(height: 18.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LanguageConstant.appointmentType.tr,
                                textAlign: TextAlign.start,
                                style: AppTextStyles.bodyTextStyle13,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                generalController
                                    .selectedAppointmentHistoryForView
                                    .appointmentTypeName!,
                                textAlign: TextAlign.start,
                                style: AppTextStyles.bodyTextStyle9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 50.h),
                    decoration: BoxDecoration(
                        color: generalController
                                    .selectedAppointmentHistoryForView
                                    .appointmentStatusCode! ==
                                1
                            ? AppColors.beigeColor
                            : generalController
                                        .selectedAppointmentHistoryForView
                                        .appointmentStatusCode! ==
                                    5
                                ? AppColors.green.withOpacity(0.5)
                                : generalController
                                            .selectedAppointmentHistoryForView
                                            .appointmentStatusCode! ==
                                        2
                                    ? AppColors.orange.withOpacity(0.7)
                                    : AppColors.carrotRed,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      // "Pending",
                      generalController.selectedAppointmentHistoryForView
                          .appointmentStatusName!,
                      style: AppTextStyles.bodyTextStyle4,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 4,
                            blurRadius: 15,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 30.h,
                            color: AppColors.textColorOne,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            LanguageConstant.date.tr,
                            style: AppTextStyles.headingTextStyle3,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            // "Appointment Type",
                            "${generalController.selectedAppointmentHistoryForView.date!}",
                            style: AppTextStyles.bodyTextStyle11,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 4,
                            blurRadius: 15,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 30.h,
                            color: AppColors.textColorOne,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            LanguageConstant.callTime.tr,
                            style: AppTextStyles.headingTextStyle3,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            // "Appointment Type",
                            "${generalController.selectedAppointmentHistoryForView.startTime ?? ""} - ${generalController.selectedAppointmentHistoryForView.endTime ?? ""}",
                            style: AppTextStyles.bodyTextStyle11,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 4,
                            blurRadius: 15,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            Get.find<GetAllSettingsController>()
                                .getDefaultCurrencySymbol(),
                            style: AppTextStyles.headingTextStyle4,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            LanguageConstant.callPrice.tr,
                            style: AppTextStyles.headingTextStyle3,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            // "Appointment Type",
                            Get.find<GetAllSettingsController>()
                                .getDisplayAmount(double.tryParse(generalController
                                        .selectedAppointmentHistoryForView.fee
                                        .toString()) ??
                                    0),
                            style: AppTextStyles.bodyTextStyle11,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            spreadRadius: 4,
                            blurRadius: 15,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 30.h,
                            color: AppColors.textColorOne,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            LanguageConstant.callDuration.tr,
                            style: AppTextStyles.headingTextStyle3,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            // "Appointment Type",
                            "${generalController.selectedAppointmentHistoryForView.startTime ?? ""} - ${generalController.selectedAppointmentHistoryForView.endTime ?? ""}",
                            style: AppTextStyles.bodyTextStyle11,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(14.w, 17.h, 14.w, 17.h),
                margin: EdgeInsets.only(bottom: 18.h, top: 18.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 4,
                      blurRadius: 15,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LanguageConstant.questions.tr,
                      style: AppTextStyles.headingTextStyle5,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      generalController
                              .selectedAppointmentHistoryForView.question ??
                          "",
                      style: AppTextStyles.bodyTextStyle7,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      LanguageConstant.paymentStatus.tr,
                      style: AppTextStyles.headingTextStyle5,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      generalController
                                  .selectedAppointmentHistoryForView.isPaid ==
                              1
                          ? LanguageConstant.paid.tr
                          : LanguageConstant.notPaid.tr,
                      style: AppTextStyles.bodyTextStyle7,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      LanguageConstant.attachments.tr,
                      style: AppTextStyles.headingTextStyle5,
                    ),
                    SizedBox(height: 6.h),
                    const Text(
                      "",
                      // generalController
                      //     .selectedAppointmentHistoryForView.attachmentUrl!
                      //     .toString(),
                      style: AppTextStyles.bodyTextStyle7,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              generalController.selectedAppointmentHistoryForView
                          .appointmentStatusCode ==
                      2
                  ? Column(
                      children: [
                        generalController.selectedAppointmentHistoryForView
                                    .appointmentTypeId ==
                                1
                            ? ButtonWidgetOne(
                                onTap: () {
                                  generalController.updateTokenForCall(
                                      generalController.tokenForCall);
                                  Get.toNamed(PageRoutes.videoCallScreen,
                                      arguments: [
                                        {
                                          "appointment": generalController
                                              .selectedAppointmentHistoryForView
                                        },
                                      ]);
                                },
                                buttonText: generalController
                                    .selectedAppointmentHistoryForView
                                    .appointmentTypeName!,
                                buttonTextStyle: AppTextStyles.buttonTextStyle1,
                                borderRadius: 40,
                                buttonColor: AppColors.gradientOne)
                            : generalController.selectedAppointmentHistoryForView
                                        .appointmentTypeId ==
                                    2
                                ? ButtonWidgetOne(
                                    onTap: () {
                                      generalController.updateTokenForCall(
                                          generalController.tokenForCall);
                                      Get.toNamed(PageRoutes.audioCallScreen,
                                          arguments: [
                                            {
                                              "appointment": generalController
                                                  .selectedAppointmentHistoryForView
                                            },
                                          ]);
                                    },
                                    buttonText: generalController
                                        .selectedAppointmentHistoryForView
                                        .appointmentTypeName!,
                                    buttonTextStyle: AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne)
                                : generalController
                                            .selectedAppointmentHistoryForView
                                            .appointmentTypeId ==
                                        3
                                    ? ButtonWidgetOne(
                                        onTap: () {
                                          generalController.updateTokenForCall(
                                              generalController.tokenForCall);
                                          Get.toNamed(PageRoutes.liveChatScreen,
                                              arguments: [
                                                {
                                                  "appointment": generalController
                                                      .selectedAppointmentHistoryForView
                                                },
                                              ]);
                                        },
                                        buttonText: generalController
                                            .selectedAppointmentHistoryForView
                                            .appointmentTypeName!,
                                        buttonTextStyle:
                                            AppTextStyles.buttonTextStyle1,
                                        borderRadius: 40,
                                        buttonColor: AppColors.gradientOne)
                                    : Container(),
                        SizedBox(height: 18.h),
                        ButtonWidgetOne(
                            onTap: () {
                              generalController
                                  .updateAppointmentStatusLoaderController(
                                      true);
                              postMethod(
                                  context,
                                  "$updateAppointmentStatusCodeURL${generalController.selectedAppointmentHistoryForView.id}",
                                  {"appointment_status_code": 5},
                                  true,
                                  appointmentStatusUpdateRepo);
                            },
                            buttonText: LanguageConstant.completed.tr,
                            buttonTextStyle: AppTextStyles.buttonTextStyle1,
                            borderRadius: 40,
                            buttonColor: AppColors.gradientOne),
                        SizedBox(height: 20.h),
                      ],
                    )
                  : generalController.selectedAppointmentHistoryForView
                              .appointmentStatusCode ==
                          1
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonWidgetOne(
                                onTap: () {
                                  Get.find<GeneralController>()
                                      .updateAppointmentStatusLoaderController(
                                          true);
                                  postMethod(
                                      context,
                                      "$updateAppointmentStatusCodeURL${generalController.selectedAppointmentHistoryForView.id}",
                                      {"appointment_status_code": 2},
                                      true,
                                      appointmentStatusUpdateRepo);
                                },
                                buttonText: LanguageConstant.accept.tr,
                                buttonTextStyle: AppTextStyles.buttonTextStyle1,
                                borderRadius: 40,
                                buttonColor: AppColors.gradientOne),
                            SizedBox(width: 40.w),
                            ButtonWidgetOne(
                                onTap: () {
                                  Get.find<GeneralController>()
                                      .updateAppointmentStatusLoaderController(
                                          true);
                                  postMethod(
                                      context,
                                      "$updateAppointmentStatusCodeURL${generalController.selectedAppointmentHistoryForView.id}",
                                      {"appointment_status_code": 3},
                                      true,
                                      appointmentStatusUpdateRepo);
                                },
                                buttonText: LanguageConstant.reject.tr,
                                buttonTextStyle: AppTextStyles.buttonTextStyle1,
                                borderRadius: 40,
                                buttonColor: AppColors.gradientOne),
                          ],
                        )
                      : generalController.selectedAppointmentHistoryForView
                                  .appointmentStatusCode ==
                              5
                          ? Column(
                              children: [
                                if (generalController
                                        .selectedAppointmentHistoryForView
                                        .isRating !=
                                    1)
                                  ButtonWidgetOne(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => RatingDialog(
                                                  onSubmit: (rating, comment) {
                                                    log("Rating: $rating, Comment: $comment");
                                                    Get.find<GeneralController>()
                                                        .updateAppointmentStatusLoaderController(
                                                            true);
                                                    postMethod(
                                                        context,
                                                        addAppointmentRatingURL,
                                                        {
                                                          "booked_appointment_id":
                                                              generalController
                                                                  .selectedAppointmentHistoryForView
                                                                  .id,
                                                          "comment": comment,
                                                          "rating": rating
                                                        },
                                                        true,
                                                        addAppointmentRatingRepo);
                                                  },
                                                ));
                                      },
                                      buttonText: LanguageConstant.rateUs.tr,
                                      buttonTextStyle:
                                          AppTextStyles.buttonTextStyle1,
                                      borderRadius: 40,
                                      buttonColor: AppColors.gradientOne),
                                if (generalController
                                            .selectedAppointmentHistoryForView
                                            .rating !=
                                        null ||
                                    (generalController
                                                .selectedAppointmentHistoryForView
                                                .comment !=
                                            null &&
                                        generalController
                                            .selectedAppointmentHistoryForView
                                            .comment!
                                            .isNotEmpty))
                                  Container(
                                    width: double.infinity,
                                    // margin: EdgeInsets.only(top: 5.h),
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: AppColors.grey.withOpacity(0.2)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LanguageConstant.yourFeedback.tr,
                                          style: AppTextStyles.bodyTextStyle14,
                                        ),
                                        SizedBox(height: 12.h),
                                        Row(
                                          children: [
                                            Text(
                                              "${LanguageConstant.rating.tr}: ",
                                              style: AppTextStyles.bodyTextStyle10,
                                            ),
                                            Row(
                                              children: List.generate(5, (index) {
                                                return Icon(
                                                  index <
                                                          generalController
                                                              .selectedAppointmentHistoryForView
                                                              .rating!
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 18.h,
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                        if (generalController
                                                .selectedAppointmentHistoryForView
                                                .comment !=
                                            null &&
                                            generalController
                                                .selectedAppointmentHistoryForView
                                                .comment!
                                                .isNotEmpty)
                                          Padding(
                                            padding: EdgeInsets.only(top: 8.h),
                                            child: Text(
                                              "${LanguageConstant.comment.tr}: ${generalController.selectedAppointmentHistoryForView.comment!}",
                                              style:
                                                  AppTextStyles.bodyTextStyle10,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 20.h),
                              ],
                            )
                          : const SizedBox()
            ]),
          ),
        ),
        ),
      );
    });
  }
}
