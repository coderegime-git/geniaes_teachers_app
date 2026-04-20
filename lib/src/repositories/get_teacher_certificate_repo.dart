import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

import '../controllers/general_controller.dart';
import '../models/get_teacher_profile_certificate_model.dart';

getTeacherCertificateRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<EditProfileController>()
        .teacherProfileCertificateForPagination
        .isNotEmpty) {
      Get.find<EditProfileController>().teacherProfileCertificateForPagination =
          [];
    }
    Get.find<EditProfileController>().getTeacherProfileCertificateModel =
        GetTeacherProfileCertificateModel.fromJson(response);

    Get.find<EditProfileController>().updateTeacherCertificateLoader(true);
    log("${Get.find<EditProfileController>().getTeacherProfileCertificateModel.data!.data!.length.toString()} Total Teacher Appoinment History Length");

    log("${Get.find<EditProfileController>().getTeacherProfileCertificateModel.data!.data!} Only Data Teacher Appoinment History");

    for (var element in Get.find<EditProfileController>()
        .getTeacherProfileCertificateModel
        .data!
        .data!) {
      Get.find<EditProfileController>()
          .updateTeacherCertificateForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<EditProfileController>().updateTeacherCertificateLoader(true);
  }
}
