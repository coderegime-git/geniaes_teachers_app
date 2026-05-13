import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/general_controller.dart';
import '../models/get_teacher_profile_event_model.dart';

getTeacherEventsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<EditProfileController>()
        .teacherProfileEventForPagination
        .isNotEmpty) {
      Get.find<EditProfileController>().teacherProfileEventForPagination = [];
    }
    Get.find<EditProfileController>().getTeacherProfileEventModel =
        GetTeacherProfileEventModel.fromJson(response);

    Get.find<EditProfileController>().updateTeacherEventLoader(true);
    log("${Get.find<EditProfileController>().getTeacherProfileEventModel.data!.data!.length.toString()} Total Teacher Events History Length");

    for (var element in Get.find<EditProfileController>()
        .getTeacherProfileEventModel
        .data!
        .data!) {
      Get.find<EditProfileController>()
          .updateTeacherEventForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);
  } else if (!responseCheck) {
    Get.find<EditProfileController>().updateTeacherEventLoader(true);
  }
}
