import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

import '../controllers/general_controller.dart';
import '../models/get_teacher_profile_experience_model.dart';

getTeacherExperienceRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<EditProfileController>()
        .teacherProfileExperienceForPagination
        .isNotEmpty) {
      Get.find<EditProfileController>().teacherProfileExperienceForPagination =
          [];
    }
    Get.find<EditProfileController>().getTeacherProfileExperienceModel =
        GetTeacherProfileExperienceModel.fromJson(response);

    Get.find<EditProfileController>().updateTeacherExperienceLoader(true);
    log("${Get.find<EditProfileController>().getTeacherProfileExperienceModel.data!.data!.length.toString()} Total Teacher Experience History Length");

    log("${Get.find<EditProfileController>().getTeacherProfileExperienceModel.data!.data!} Only Data Teacher Experience History");

    for (var element in Get.find<EditProfileController>()
        .getTeacherProfileExperienceModel
        .data!
        .data!) {
      Get.find<EditProfileController>()
          .updateTeacherExperienceForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<EditProfileController>().updateTeacherExperienceLoader(true);
  }
}
