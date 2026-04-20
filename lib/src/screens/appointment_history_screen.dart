import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/teacher_appointment_history_controller.dart';
import '../controllers/general_controller.dart';
import '../models/teacher_appointment_history_model.dart';
import '../repositories/teacher_appointment_history_repo.dart';
import '../routes.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/appointment_card_widget.dart';
import '../widgets/custom_skeleton_loader.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  State<AppointmentHistoryScreen> createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  final logic = Get.put(TeacherAppointmentHistoryController());

  List<TeacherAppointmentHistoryModel>? pendingList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pullRefresh() async {
    getMethod(context, "$getTeacherAppointmentHistory?page=1", null, true,
        getAllTeacherAppointmentHistoryRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherAppointmentHistoryController>(
        builder: (teacherAppointmentHistoryController) {
      return GetBuilder<GeneralController>(builder: (generalController) {
        return DefaultTabController(
          length: 5, // length of tabs
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                leadingIcon: "assets/icons/Sort.png",
                leadingOnTap: () {
                  Scaffold.of(context).openDrawer();
                },
                titleText: LanguageConstant.appointmentHistory.tr,
              ),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TabBar(
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.black,
                    dividerColor: AppColors.transparent,
                    padding: const EdgeInsets.fromLTRB(3, 6, 3, 6),
                    indicatorPadding: const EdgeInsets.fromLTRB(-6, 4, -6, 4),
                    labelPadding: EdgeInsets.zero,
                    labelStyle: AppTextStyles.buttonTextStyle2,
                    unselectedLabelStyle: AppTextStyles.buttonTextStyle7,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        gradient: AppColors.gradientOne,
                        borderRadius: BorderRadius.circular(20)),
                    tabs: [
                      Tab(text: LanguageConstant.all.tr),
                      Tab(text: LanguageConstant.pending.tr),
                      Tab(text: LanguageConstant.accepted.tr),
                      Tab(text: LanguageConstant.rejected.tr),
                      Tab(text: LanguageConstant.completed.tr),
                    ],
                  ),
                  !teacherAppointmentHistoryController
                          .allTeacherAppointmentHistoryLoader
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
                              teacherAppointmentHistoryController
                                      .teacherAllAppointmentHistoryListForPagination
                                      .isNotEmpty
                                  ? RefreshIndicator(
                                      onRefresh: _pullRefresh,
                                      color: AppColors.primaryColor,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount:
                                            teacherAppointmentHistoryController
                                                .teacherAllAppointmentHistoryListForPagination
                                                .length,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(top: 18),
                                        itemBuilder: (context, index) {
                                          return AppointmentCardWidget(
                                            studentName:
                                                teacherAppointmentHistoryController
                                                        .teacherAllAppointmentHistoryListForPagination[
                                                            index]
                                                        .studentName ??
                                                    "",
                                            studentImage:
                                                teacherAppointmentHistoryController
                                                            .teacherAllAppointmentHistoryListForPagination[
                                                                index]
                                                            .studentImage ==
                                                        null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        child: Image.asset(
                                                          scale: 4.h,
                                                          'assets/images/teacher-image.png',
                                                          fit: BoxFit.cover,
                                                          height: 110.h,
                                                          width: 120.w,
                                                        ))
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        child: Image.network(
                                                          scale: 4.h,
                                                          '$mediaUrl${teacherAppointmentHistoryController.teacherAllAppointmentHistoryListForPagination[index].studentImage!}',
                                                          fit: BoxFit.cover,
                                                          height: 110.h,
                                                          width: 120.w,
                                                        ),
                                                      ),
                                            appointmentStatus: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 2, 5, 2),
                                              decoration: BoxDecoration(
                                                  color: teacherAppointmentHistoryController
                                                              .teacherAllAppointmentHistoryListForPagination[
                                                                  index]
                                                              .appointmentStatusCode! ==
                                                          1
                                                      ? AppColors.beigeColor
                                                      : teacherAppointmentHistoryController
                                                                  .teacherAllAppointmentHistoryListForPagination[
                                                                      index]
                                                                  .appointmentStatusCode! ==
                                                              5
                                                          ? AppColors.green
                                                              .withOpacity(0.5)
                                                          : teacherAppointmentHistoryController
                                                                      .teacherAllAppointmentHistoryListForPagination[
                                                                          index]
                                                                      .appointmentStatusCode! ==
                                                                  2
                                                              ? AppColors.orange
                                                                  .withOpacity(
                                                                      0.7)
                                                              : AppColors
                                                                  .carrotRed,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                // "Pending",
                                                teacherAppointmentHistoryController
                                                        .teacherAllAppointmentHistoryListForPagination[
                                                            index]
                                                        .appointmentStatusName ??
                                                    "",
                                                style: AppTextStyles
                                                    .bodyTextStyle4,
                                              ),
                                            ),
                                            appointmentTypeName:
                                                teacherAppointmentHistoryController
                                                    .teacherAllAppointmentHistoryListForPagination[
                                                        index]
                                                    .appointmentTypeName!,
                                            dateAndTime:
                                                '${teacherAppointmentHistoryController.teacherAllAppointmentHistoryListForPagination[index].date!} \n${teacherAppointmentHistoryController.teacherAllAppointmentHistoryListForPagination[index].startTime ?? ""} - ${teacherAppointmentHistoryController.teacherAllAppointmentHistoryListForPagination[index].endTime ?? ""}',
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
                                                    teacherAppointmentHistoryController
                                                        .teacherAllAppointmentHistoryListForPagination[
                                                            index]
                                                        .toJson();
                                              });
                                              generalController
                                                  .updateSelectedAppointmentHistoryForView(
                                                      teacherAppointmentHistoryController
                                                              .teacherAllAppointmentHistoryListForPagination[
                                                          index]);
                                              Get.toNamed(PageRoutes
                                                  .appointmentHistoryDetailScreen);
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        LanguageConstant.noDataFound.tr,
                                        style: AppTextStyles.bodyTextStyle13,
                                      ),
                                    ),
                              // Pending Appointment History
                              appointmentHistoryWidget(
                                  1,
                                  teacherAppointmentHistoryController,
                                  generalController),
                              // Accepted Appointment History
                              appointmentHistoryWidget(
                                  2,
                                  teacherAppointmentHistoryController,
                                  generalController),
                              // Rejected Appointment History
                              appointmentHistoryWidget(
                                  3,
                                  teacherAppointmentHistoryController,
                                  generalController),
                              // Completed Appointment History
                              appointmentHistoryWidget(
                                  5,
                                  teacherAppointmentHistoryController,
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

// Appointment History
  Widget appointmentHistoryWidget(
      int statusCode,
      TeacherAppointmentHistoryController teacherAppointmentHistoryController,
      GeneralController generalController) {
    return teacherAppointmentHistoryController
            .teacherAllAppointmentHistoryListForPagination
            .where((i) => i.appointmentStatusCode == statusCode)
            .toList()
            .isNotEmpty
        ? RefreshIndicator(
            onRefresh: _pullRefresh,
            color: AppColors.primaryColor,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              // ignore: iterable_contains_unrelated_type
              itemCount: teacherAppointmentHistoryController
                  .teacherAllAppointmentHistoryListForPagination
                  .where((i) => i.appointmentStatusCode == statusCode)
                  .toList()
                  .length,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 18.h),
              itemBuilder: (context, index) {
                return AppointmentCardWidget(
                  studentName: teacherAppointmentHistoryController
                          .teacherAllAppointmentHistoryListForPagination
                          .where((i) => i.appointmentStatusCode == statusCode)
                          .toList()[index]
                          .studentName ??
                      "",
                  studentImage: teacherAppointmentHistoryController
                              .teacherAllAppointmentHistoryListForPagination
                              .where(
                                  (i) => i.appointmentStatusCode == statusCode)
                              .toList()[index]
                              .studentImage ==
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
                            '$mediaUrl${teacherAppointmentHistoryController.teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusCode == statusCode).toList()[index].studentImage!}',
                            fit: BoxFit.cover,
                            height: 110.h,
                            width: 120.w,
                          ),
                        ),
                  appointmentStatus: Container(
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    decoration: BoxDecoration(
                        color: teacherAppointmentHistoryController
                                    .teacherAllAppointmentHistoryListForPagination
                                    .where((i) =>
                                        i.appointmentStatusCode == statusCode)
                                    .toList()[index]
                                    .appointmentStatusCode! ==
                                1
                            ? AppColors.beigeColor
                            : teacherAppointmentHistoryController
                                        .teacherAllAppointmentHistoryListForPagination
                                        .where((i) =>
                                            i.appointmentStatusCode ==
                                            statusCode)
                                        .toList()[index]
                                        .appointmentStatusCode! ==
                                    5
                                ? AppColors.green.withOpacity(0.5)
                                : teacherAppointmentHistoryController
                                            .teacherAllAppointmentHistoryListForPagination
                                            .where((i) =>
                                                i.appointmentStatusCode ==
                                                statusCode)
                                            .toList()[index]
                                            .appointmentStatusCode! ==
                                        2
                                    ? AppColors.orange.withOpacity(0.7)
                                    : AppColors.carrotRed,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      // statusName,
                      teacherAppointmentHistoryController
                          .teacherAllAppointmentHistoryListForPagination
                          .where((i) => i.appointmentStatusCode == statusCode)
                          .toList()[index]
                          .appointmentStatusName!,
                      style: AppTextStyles.bodyTextStyle4,
                    ),
                  ),
                  appointmentTypeName: teacherAppointmentHistoryController
                      .teacherAllAppointmentHistoryListForPagination
                      .where((i) => i.appointmentStatusCode == statusCode)
                      .toList()[index]
                      .appointmentTypeName!,
                  dateAndTime:
                      '${teacherAppointmentHistoryController.teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusCode == statusCode).toList()[index].date!} \n${teacherAppointmentHistoryController.teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusCode == statusCode).toList()[index].startTime ?? ""} - ${teacherAppointmentHistoryController.teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusCode == statusCode).toList()[index].endTime ?? ""}',
                  onTap: () {
                    generalController.updateSelectedAppointmentHistoryForView(
                        teacherAppointmentHistoryController
                            .teacherAllAppointmentHistoryListForPagination
                            .where((i) => i.appointmentStatusCode == statusCode)
                            .toList()[index]);
                    Get.toNamed(PageRoutes.appointmentHistoryDetailScreen);
                  },
                );
              },
            ),
          )
        : Center(
            child: Text(
              LanguageConstant.noDataFound.tr,
              style: AppTextStyles.bodyTextStyle13,
            ),
          );
  }
}
