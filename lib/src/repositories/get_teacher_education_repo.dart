import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

import '../controllers/general_controller.dart';
import '../models/get_teacher_profile_education_model.dart';

getTeacherEducationRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<EditProfileController>()
        .teacherProfileEducationForPagination
        .isNotEmpty) {
      Get.find<EditProfileController>().teacherProfileEducationForPagination =
          [];
    }
    Get.find<EditProfileController>().getTeacherProfileEducationModel =
        GetTeacherProfileEducationModel.fromJson(response);

    Get.find<EditProfileController>().updateTeacherEducationLoader(true);
    log("${Get.find<EditProfileController>().getTeacherProfileEducationModel.data!.data!.length.toString()} Total Teacher Education History Length");

    log("${Get.find<EditProfileController>().getTeacherProfileEducationModel.data!.data!} Only Data Teacher Education History");

    for (var element in Get.find<EditProfileController>()
        .getTeacherProfileEducationModel
        .data!
        .data!) {
      Get.find<EditProfileController>()
          .updateTeacherEducationForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<EditProfileController>().updateTeacherEducationLoader(true);
  }
}
