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

  // Helper: status badge color
  Color _statusColor(int? code) {
    if (code == 1) return AppColors.beigeColor;
    if (code == 5) return AppColors.green.withOpacity(0.5);
    if (code == 2) return AppColors.orange.withOpacity(0.7);
    return AppColors.carrotRed;
  }

  // Helper: student image widget
  Widget _studentImage(String? imageUrl) {
    if (imageUrl == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.asset(
          'assets/images/teacher-image.png',
          scale: 4.h,
          fit: BoxFit.cover,
          height: 110.h,
          width: 120.w,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        '$mediaUrl$imageUrl',
        scale: 4.h,
        fit: BoxFit.cover,
        height: 110.h,
        width: 120.w,
      ),
    );
  }

  // Empty state — scrollable so pull-to-refresh works
  Widget _emptyState() {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      color: AppColors.primaryColor,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 300.h),
          Center(
            child: Text(
              LanguageConstant.noDataFound.tr,
              style: AppTextStyles.bodyTextStyle13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TeacherAppointmentHistoryController>(
        builder: (teacherAppointmentHistoryController) {
          return GetBuilder<GeneralController>(builder: (generalController) {
            int initialTab = Get.arguments != null ? Get.arguments['tabIndex'] ?? 0 : 0;
            return DefaultTabController(
              length: 5,
              initialIndex: initialTab,
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
                            // All Tab
                            _allAppointmentsWidget(
                                teacherAppointmentHistoryController,
                                generalController),
                            // Pending Tab
                            appointmentHistoryWidget(
                                1,
                                teacherAppointmentHistoryController,
                                generalController),
                            // Accepted Tab
                            appointmentHistoryWidget(
                                2,
                                teacherAppointmentHistoryController,
                                generalController),
                            // Rejected Tab
                            appointmentHistoryWidget(
                                3,
                                teacherAppointmentHistoryController,
                                generalController),
                            // Completed Tab
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

  // All Appointments Tab
  Widget _allAppointmentsWidget(
      TeacherAppointmentHistoryController ctrl,
      GeneralController generalController) {
    final list = ctrl.teacherAllAppointmentHistoryListForPagination;

    if (list.isEmpty) return _emptyState();

    return RefreshIndicator(
      onRefresh: _pullRefresh,
      color: AppColors.primaryColor,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list.length,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 18),
        itemBuilder: (context, index) {
          final item = list[index];
          return AppointmentCardWidget(
            studentName: item.studentName ?? "",
            studentImage: _studentImage(item.studentImage),
            appointmentStatus: Container(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                  color: _statusColor(item.appointmentStatusCode as int?),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                item.appointmentStatusName ?? "",
                style: AppTextStyles.bodyTextStyle4,
              ),
            ),
            appointmentTypeName: item.appointmentTypeName!,
            dateAndTime:
            '${item.date!} \n${item.startTime ?? ""} - ${item.endTime ?? ""}',
            onTap: () {
              generalController.updateChannelForCall(
                  generalController.getRandomString(10));
              setState(() {
                generalController.appointmentObject = item.toJson();
              });
              generalController.updateSelectedAppointmentHistoryForView(item);
              Get.toNamed(PageRoutes.appointmentHistoryDetailScreen);
            },
          );
        },
      ),
    );
  }

  // Filtered Tabs: Pending / Accepted / Rejected / Completed
  Widget appointmentHistoryWidget(
      int statusCode,
      TeacherAppointmentHistoryController ctrl,
      GeneralController generalController) {
    final filteredList = ctrl.teacherAllAppointmentHistoryListForPagination
        .where((i) => i.appointmentStatusCode == statusCode)
        .toList();

    if (filteredList.isEmpty) return _emptyState();

    return RefreshIndicator(
      onRefresh: _pullRefresh,
      color: AppColors.primaryColor,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: filteredList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 18.h),
        itemBuilder: (context, index) {
          final item = filteredList[index];
          return AppointmentCardWidget(
            studentName: item.studentName ?? "",
            studentImage: _studentImage(item.studentImage),
            appointmentStatus: Container(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                  color: _statusColor(item.appointmentStatusCode as int?),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                item.appointmentStatusName!,
                style: AppTextStyles.bodyTextStyle4,
              ),
            ),
            appointmentTypeName: item.appointmentTypeName!,
            dateAndTime:
            '${item.date!} \n${item.startTime ?? ""} - ${item.endTime ?? ""}',
            onTap: () {
              generalController.updateSelectedAppointmentHistoryForView(item);
              Get.toNamed(PageRoutes.appointmentHistoryDetailScreen);
            },
          );
        },
      ),
    );
  }
}