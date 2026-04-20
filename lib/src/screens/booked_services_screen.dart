import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:tutorhub_for_teachers/src/widgets/service_card_widget.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';

import '../controllers/teacher_booked_services_controller.dart';
import '../models/teacher_booked_services_model.dart';
import '../routes.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/custom_skeleton_loader.dart';

class BookedServicesScreen extends StatefulWidget {
  const BookedServicesScreen({super.key});

  @override
  State<BookedServicesScreen> createState() => _BookedServicesScreenState();
}

class _BookedServicesScreenState extends State<BookedServicesScreen> {
  final logic = Get.put(TeacherBookedServicesController());

  List<TeacherBookedServiceModel>? pendingList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherBookedServicesController>(
        builder: (teacherBookedServicesController) {
      return GetBuilder<GeneralController>(builder: (generalController) {
        return DefaultTabController(
          length: 4, // length of tabs
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                leadingIcon: "assets/icons/Expand_left.png",
                leadingOnTap: () {
                  // fromBookService == "Yes"
                  //     ? Get.toNamed(PageRoutes.homeScreen)
                  //     :
                  Get.back();
                },
                titleText: LanguageConstant.bookedServices.tr,
              ),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Theme(
                    data: ThemeData()
                        .copyWith(dividerColor: AppColors.primaryColor),
                    child: TabBar(
                      labelColor: AppColors.white,
                      unselectedLabelColor: AppColors.secondaryColor,
                      dividerColor: AppColors.transparent,
                      indicatorPadding: EdgeInsets.fromLTRB(0.w, 4.h, 0.w, 4.h),
                      padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 6.h),
                      labelPadding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: AppTextStyles.buttonTextStyle2,
                      unselectedLabelStyle: AppTextStyles.buttonTextStyle7,
                      indicator: BoxDecoration(
                          gradient: AppColors.gradientOne,
                          borderRadius: BorderRadius.circular(20)),
                      tabs: [
                        Tab(
                          text: LanguageConstant.all.tr,
                        ),
                        Tab(
                          text: LanguageConstant.pending.tr,
                        ),
                        Tab(
                          text: LanguageConstant.accepted.tr,
                        ),
                        Tab(
                          text: LanguageConstant.completed.tr,
                        ),
                      ],
                    ),
                  ),
                  !teacherBookedServicesController
                          .allTeacherBookedServicesLoader
                      ? Expanded(
                          child: CustomVerticalSkeletonLoader(
                            height: 200.h,
                            highlightColor: AppColors.grey,
                            seconds: 2,
                            totalCount: 5,
                            width: 140.w,
                          ),
                        )
                      : Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 1))),
                            child: TabBarView(children: <Widget>[
                              // All Appointment History
                              teacherBookedServicesController
                                      .teacherAllBookedServicesListForPagination
                                      .isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: teacherBookedServicesController
                                          .teacherAllBookedServicesListForPagination
                                          .length,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.only(top: 18),
                                      itemBuilder: (context, index) {
                                        return ServiceCardWidget(
                                            serviceImage:
                                                // teacherBookedServicesController
                                                //             .teacherAllBookedServicesListForPagination[
                                                //                 index]
                                                //             .serviceImage ==
                                                //         null
                                                //     ?
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                    child: Image.asset(
                                                      scale: 4.h,
                                                      'assets/images/teacher-image.png',
                                                      fit: BoxFit.cover,
                                                      height: 110.h,
                                                      width: 120.w,
                                                    )),
                                            // : ClipRRect(
                                            //     borderRadius:
                                            //         BorderRadius
                                            //             .circular(8.r),
                                            //     child: Image.network(
                                            //       scale: 4.h,
                                            //       '$mediaUrl${teacherBookedServicesController.teacherAllBookedServicesListForPagination[index].serviceImage!}',
                                            //       fit: BoxFit.cover,
                                            //       height: 110.h,
                                            //       width: 120.w,
                                            //     ),
                                            //   ),
                                            serviceName:
                                                teacherBookedServicesController
                                                        .teacherAllBookedServicesListForPagination[
                                                            index]
                                                        .serviceName ??
                                                    "",
                                            onTap: () {
                                              generalController
                                                  .updateChannelForCall(
                                                      generalController
                                                          .getRandomString(10));
                                              print(
                                                  "${generalController.channelForCall} CALLCHANNEL");
                                              setState(() {
                                                generalController
                                                        .appointmentObject =
                                                    teacherBookedServicesController
                                                        .teacherAllBookedServicesListForPagination[
                                                            index]
                                                        .toJson();
                                              });
                                              generalController
                                                  .updateSelectedBookedServicesForView(
                                                      teacherBookedServicesController
                                                              .teacherAllBookedServicesListForPagination[
                                                          index]);
                                              Get.toNamed(PageRoutes
                                                  .bookedServiceDetailScreen);
                                            },
                                            serviceStatus: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 2, 5, 2),
                                              decoration: BoxDecoration(
                                                  color: teacherBookedServicesController
                                                              .teacherAllBookedServicesListForPagination[
                                                                  index]
                                                              .serviceStatusName! ==
                                                          "Pending"
                                                      ? AppColors.primaryColor
                                                      : teacherBookedServicesController
                                                                  .teacherAllBookedServicesListForPagination[
                                                                      index]
                                                                  .serviceStatusName! ==
                                                              "Completed"
                                                          ? AppColors.green
                                                              .withOpacity(0.5)
                                                          : teacherBookedServicesController
                                                                      .teacherAllBookedServicesListForPagination[
                                                                          index]
                                                                      .serviceStatusName! ==
                                                                  "Accepted"
                                                              ? AppColors.orange
                                                                  .withOpacity(
                                                                      0.5)
                                                              : AppColors
                                                                  .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                // "Pending",
                                                teacherBookedServicesController
                                                    .teacherAllBookedServicesListForPagination[
                                                        index]
                                                    .serviceStatusName!,
                                                style: AppTextStyles
                                                    .bodyTextStyle4,
                                              ),
                                            ),
                                            serviceTypeName:
                                                LanguageConstant.service.tr,
                                            dateAndTime:
                                                teacherBookedServicesController
                                                    .teacherAllBookedServicesListForPagination[
                                                        index]
                                                    .date!);
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        LanguageConstant.noDataFound.tr,
                                        style: AppTextStyles.bodyTextStyle2,
                                      ),
                                    ),
                              // Pending Appointment History
                              bookedServicesWidget(
                                  1,
                                  teacherBookedServicesController,
                                  generalController),
                              // Accepted Appointment History
                              bookedServicesWidget(
                                  2,
                                  teacherBookedServicesController,
                                  generalController),
                              // Completed Appointment History
                              bookedServicesWidget(
                                  5,
                                  teacherBookedServicesController,
                                  generalController),
                            ]),
                          ),
                        )
                ]),
          ),
        );
      });
    });
  }

// Booked Services
  Widget bookedServicesWidget(
      int statusCode,
      TeacherBookedServicesController teacherBookedServicesController,
      GeneralController generalController) {
    return teacherBookedServicesController
            .teacherAllBookedServicesListForPagination
            .where((i) => i.serviceStatusCode == statusCode)
            .toList()
            .isNotEmpty
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // ignore: iterable_contains_unrelated_type
            itemCount: teacherBookedServicesController
                .teacherAllBookedServicesListForPagination
                .where((i) => i.serviceStatusCode == statusCode)
                .toList()
                .length,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 18),
            itemBuilder: (context, index) {
              return ServiceCardWidget(
                  serviceImage: teacherBookedServicesController
                              .teacherAllBookedServicesListForPagination[index]
                              .serviceImage ==
                          null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.asset(
                            scale: 4.h,
                            'assets/images/teacher-image.png',
                            fit: BoxFit.cover,
                            height: 110.h,
                            width: 120.w,
                          ))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            scale: 4.h,
                            '$mediaUrl${teacherBookedServicesController.teacherAllBookedServicesListForPagination[index].serviceImage!}',
                            fit: BoxFit.cover,
                            height: 110.h,
                            width: 120.w,
                          ),
                        ),
                  serviceName: teacherBookedServicesController
                          .teacherAllBookedServicesListForPagination
                          .where((i) => i.serviceStatusCode == statusCode)
                          .toList()[index]
                          .serviceName ??
                      "",
                  onTap: () {
                    generalController.updateSelectedBookedServicesForView(
                        teacherBookedServicesController
                            .teacherAllBookedServicesListForPagination
                            .where((i) => i.serviceStatusCode == statusCode)
                            .toList()[index]);
                    Get.toNamed(PageRoutes.bookedServiceDetailScreen);
                  },
                  serviceStatus: Container(
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    decoration: BoxDecoration(
                        color: teacherBookedServicesController
                                    .teacherAllBookedServicesListForPagination
                                    .where((i) =>
                                        i.serviceStatusCode == statusCode)
                                    .toList()[index]
                                    .serviceStatusCode! ==
                                1
                            ? AppColors.primaryColor
                            : teacherBookedServicesController
                                        .teacherAllBookedServicesListForPagination
                                        .where((i) =>
                                            i.serviceStatusCode == statusCode)
                                        .toList()[index]
                                        .serviceStatusCode! ==
                                    5
                                ? AppColors.green.withOpacity(0.5)
                                : teacherBookedServicesController
                                            .teacherAllBookedServicesListForPagination
                                            .where((i) =>
                                                i.serviceStatusCode ==
                                                statusCode)
                                            .toList()[index]
                                            .serviceStatusCode! ==
                                        2
                                    ? AppColors.orange.withOpacity(0.5)
                                    : AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      // statusCode,
                      teacherBookedServicesController
                          .teacherAllBookedServicesListForPagination
                          .where((i) => i.serviceStatusCode == statusCode)
                          .toList()[index]
                          .serviceStatusName!,
                      style: AppTextStyles.bodyTextStyle4,
                    ),
                  ),
                  serviceTypeName: LanguageConstant.service.tr,
                  dateAndTime: teacherBookedServicesController
                      .teacherAllBookedServicesListForPagination
                      .where((i) => i.serviceStatusCode == statusCode)
                      .toList()[index]
                      .date!);
            },
          )
        : Center(
            child: Text(
              LanguageConstant.noDataFound.tr,
              style: AppTextStyles.bodyTextStyle2,
            ),
          );
  }
}
