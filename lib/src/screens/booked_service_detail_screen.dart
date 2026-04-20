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
import '../repositories/booked_service_status_update_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import 'agora_call/repo.dart';

class BookedServiceDetailScreen extends StatefulWidget {
  const BookedServiceDetailScreen({super.key});

  @override
  State<BookedServiceDetailScreen> createState() =>
      BookedServiceDetailScreenState();
}

class BookedServiceDetailScreenState extends State<BookedServiceDetailScreen> {
  @override
  void initState() {
    Get.find<GeneralController>()
                .selectedBookedServiceForView
                .serviceStatusCode ==
            2
        ? getMethod(
            context,
            "$getAgoraTokenUrl?channel=${Get.find<GeneralController>().channelForCall}",
            null,
            true,
            getAgoraTokenRepo)
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return ModalProgressHUD(
        progressIndicator: const CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
        inAsyncCall: generalController.bookedServiceStatusLoaderController,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              leadingIcon: "assets/icons/Expand_left.png",
              leadingOnTap: () {
                Get.back();
              },
              titleText: LanguageConstant.bookedServiceDetail.tr,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: generalController.selectedBookedServiceForView
                                    .studentImage ==
                                null
                            ? Image(
                                image: NetworkImage(
                                    "$mediaUrl${generalController.selectedBookedServiceForView.studentImage!}"),
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
                            generalController
                                    .selectedBookedServiceForView.studentName ??
                                "",
                            textAlign: TextAlign.start,
                            style: AppTextStyles.bodyTextStyle14,
                          ),
                          SizedBox(height: 18.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LanguageConstant.type.tr,
                                textAlign: TextAlign.start,
                                style: AppTextStyles.bodyTextStyle13,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                LanguageConstant.service.tr,
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
                        color: generalController.selectedBookedServiceForView
                                    .serviceStatusCode! ==
                                1
                            ? AppColors.beigeColor
                            : generalController.selectedBookedServiceForView
                                        .serviceStatusCode! ==
                                    5
                                ? AppColors.green.withOpacity(0.5)
                                : generalController.selectedBookedServiceForView
                                            .serviceStatusCode! ==
                                        2
                                    ? AppColors.orange.withOpacity(0.7)
                                    : AppColors.carrotRed,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      // "Pending",
                      generalController
                          .selectedBookedServiceForView.serviceStatusName!,
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
                          Text(
                            Get.find<GetAllSettingsController>()
                                .getDefaultCurrencySymbol(),
                            style: AppTextStyles.headingTextStyle4,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            LanguageConstant.serviceFee.tr,
                            style: AppTextStyles.headingTextStyle3,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            // "Appointment Type",
                            "${Get.find<GetAllSettingsController>().getDisplayAmount(generalController.selectedBookedServiceForView.price!)}",
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
                            generalController
                                .selectedBookedServiceForView.date!,
                            style: AppTextStyles.bodyTextStyle11,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
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
                      generalController.selectedBookedServiceForView.question ??
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
                      generalController.selectedBookedServiceForView.isPaid == 1
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
                      //     .selectedBookedServiceForView.attachmentUrl!
                      //     .toString(),
                      style: AppTextStyles.bodyTextStyle7,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              generalController
                          .selectedBookedServiceForView.serviceStatusCode ==
                      2
                  ? ButtonWidgetOne(
                      onTap: () {
                        generalController
                            .updateTokenForCall(generalController.tokenForCall);
                        Get.toNamed(
                          PageRoutes.liveServiceChatScreen,
                          arguments: [
                            {
                              "service":
                                  generalController.selectedBookedServiceForView
                            },
                          ],
                        );
                      },
                      buttonText: LanguageConstant.chatNow.tr,
                      buttonTextStyle: AppTextStyles.buttonTextStyle1,
                      borderRadius: 40,
                      buttonColor: AppColors.gradientOne)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonWidgetOne(
                            onTap: () {
                              Get.find<GeneralController>()
                                  .updateBookedServiceStatusLoaderController(
                                      true);
                              postMethod(
                                  context,
                                  "$updateBookedServiceStatusCodeURL${generalController.selectedBookedServiceForView.id}",
                                  {"service_status_code": 2},
                                  true,
                                  bookedServiceStatusUpdateRepo);
                            },
                            buttonText: LanguageConstant.accept.tr,
                            buttonTextStyle: AppTextStyles.buttonTextStyle1,
                            borderRadius: 40,
                            buttonColor: AppColors.gradientOne),
                        SizedBox(width: 40.w),
                        ButtonWidgetOne(
                            onTap: () {
                              Get.find<GeneralController>()
                                  .updateBookedServiceStatusLoaderController(
                                      true);
                              postMethod(
                                  context,
                                  "$updateBookedServiceStatusCodeURL${generalController.selectedBookedServiceForView.id}",
                                  {"service_status_code": 3},
                                  true,
                                  bookedServiceStatusUpdateRepo);
                            },
                            buttonText: LanguageConstant.reject.tr,
                            buttonTextStyle: AppTextStyles.buttonTextStyle1,
                            borderRadius: 40,
                            buttonColor: AppColors.gradientOne),
                      ],
                    )
            ]),
          ),
        ),
      );
    });
  }
}
