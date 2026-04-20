import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/appoinment_commission_controller.dart';
import '../controllers/appoinment_schedules_controller.dart';

import '../controllers/generate_schedule_slots_controller.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/audio_call_appointment_slots_widget.dart';

import '../widgets/chat_appointment_slots_widget.dart';
import '../widgets/video_call_appointment_slots_widget.dart';

class ScheduleAppSlotsScreen extends StatefulWidget {
  const ScheduleAppSlotsScreen({super.key});

  @override
  State<ScheduleAppSlotsScreen> createState() => _ScheduleAppSlotsScreenState();
}

class _ScheduleAppSlotsScreenState extends State<ScheduleAppSlotsScreen> {
  final logic = Get.put(GenerateScheduleSlotsController());
  final appointmentSchedulelogic = Get.put(GetAppoinmentSchedulesController());
  final appointmentCommissionlogic =
      Get.put(GetAppoinmentCommissionController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GenerateScheduleSlotsController>(
        builder: (generateScheduleSlotsController) {
      return GetBuilder<GetAppoinmentSchedulesController>(
          builder: (getAppoinmentSchedulesController) {
        return DefaultTabController(
          length: 3, // length of tabs
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: AppColors.bgColorTwo,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                titleText: 'Appointment Slots',
                leadingIcon: "assets/icons/Expand_left.png",
                leadingOnTap: () {
                  Get.back();
                },
              ),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TabBar(
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.secondaryColor,
                    // dividerColor: AppColors.primaryColor,
                    padding: const EdgeInsets.fromLTRB(3, 6, 3, 6),
                    indicatorPadding: const EdgeInsets.fromLTRB(3, 4, 3, 4),
                    labelPadding: EdgeInsets.zero,
                    labelStyle: AppTextStyles.buttonTextStyle2,
                    unselectedLabelStyle: AppTextStyles.buttonTextStyle7,
                    indicator: BoxDecoration(
                        gradient: AppColors.gradientOne,
                        borderRadius: BorderRadius.circular(10)),
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ImageIcon(
                              AssetImage("assets/icons/icon_Video_.png"),
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(width: 3.w),
                            const Text("Video Call"),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ImageIcon(
                              AssetImage(
                                  "assets/icons/icon_Volume_Up_.png"),
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(width: 3.w),
                            const Text("Audio Call"),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const ImageIcon(
                              AssetImage("assets/icons/icon_comments_.png"),
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(width: 3.w),
                            const Text("Online Chat"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: AppColors.primaryColor, width: 1))),
                      // ignore: prefer_const_constructors
                      child: TabBarView(children: const <Widget>[
                        // Video Call Appointment Slots
                        VideoCallAppointmentSlotsWidget(),
                        // Audio Call Appointment Slots
                        AudioCallAppointmentSlotsWidget(),
                        // Online Chat
                        ChatAppointmentSlotsWidget(),
                      ]),
                    ),
                  )
                ]),
          ),
        );
      });
    });
  }
}
