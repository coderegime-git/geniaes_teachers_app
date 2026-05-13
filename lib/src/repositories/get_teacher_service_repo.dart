import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/general_controller.dart';
import '../models/get_teacher_profile_service_model.dart';

getTeacherServiceRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<EditProfileController>()
        .teacherProfileServiceForPagination
        .isNotEmpty) {
      Get.find<EditProfileController>().teacherProfileServiceForPagination = [];
    }
    Get.find<EditProfileController>().getTeacherProfileServiceModel =
        GetTeacherProfileServiceModel.fromJson(response);

    Get.find<EditProfileController>().updateTeacherServiceLoader(true);
    log("${Get.find<EditProfileController>().getTeacherProfileServiceModel.data!.data!.length.toString()} Total Teacher Service History Length");

    for (var element in Get.find<EditProfileController>()
        .getTeacherProfileServiceModel
        .data!
        .data!) {
      Get.find<EditProfileController>()
          .updateTeacherServiceForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);
  } else if (!responseCheck) {
    Get.find<EditProfileController>().updateTeacherServiceLoader(true);
  }
}
