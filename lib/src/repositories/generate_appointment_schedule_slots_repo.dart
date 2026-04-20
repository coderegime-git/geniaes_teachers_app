import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorhub_for_teachers/multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../controllers/generate_schedule_slots_controller.dart';
import '../routes.dart';
import '../widgets/custom_dialog.dart';

generateAppointmentScheduleSlotsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<GenerateScheduleSlotsController>()
        .updateGenerateScheduleSlotsLoader(false);
    log("Generate Appointment Schedule Slots Succesfully");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: LanguageConstant.success.tr,
          titleColor: AppColors.customDialogSuccessColor,
          descriptions:
              LanguageConstant.succesfullyGeneratedAppointmentScheduleSlots.tr,
          text: LanguageConstant.ok.tr,
          functionCall: () {
            Get.back();
            Get.back();
          },
          img: 'assets/icons/dialog_success.png',
        );
      },
    );

    // Get.offNamed(PageRoutes.teacherProfileScreen,
    //     parameters: {"fromAppointmentSchduleSlots": "Yes"});
    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    log("Failed to Generate Appointment Schedule Slots");
    Get.find<GenerateScheduleSlotsController>()
        .updateGenerateScheduleSlotsLoader(true);
  }
}

generateAppointmentScheduleSlotsForSingleDayRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<GenerateScheduleSlotsController>()
        .updateGenerateScheduleSlotsLoader(false);
    log("Generate Appointment Schedule Slots Succesfully");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: LanguageConstant.success.tr,
          titleColor: AppColors.customDialogSuccessColor,
          descriptions:
              LanguageConstant.succesfullyGeneratedAppointmentScheduleSlots.tr,
          text: LanguageConstant.ok.tr,
          functionCall: () {
            Get.back();
            Get.back();
          },
          img: 'assets/icons/dialog_success.png',
        );
      },
    );
    // Get.offNamed(PageRoutes.teacherProfileScreen,
    //     parameters: {"fromAppointmentSchduleSlots": "Yes"});
    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    log("Failed to Generate Appointment Schedule Slots");
    Get.find<GenerateScheduleSlotsController>()
        .updateGenerateScheduleSlotsLoader(true);
  }
}
