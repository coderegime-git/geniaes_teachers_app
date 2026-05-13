import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

import '../controllers/general_controller.dart';
import '../models/get_teacher_profile_podcast_model.dart';

getTeacherArchivesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  log("getTeacherArchivesRepo called with responseCheck: $responseCheck");
  try {
    if (responseCheck) {
      log("Response data: $response");
      if (Get.find<EditProfileController>()
          .teacherProfileArchiveForPagination
          .isNotEmpty) {
        Get.find<EditProfileController>().teacherProfileArchiveForPagination = [];
      }
      
      Get.find<EditProfileController>().getTeacherProfileArchiveModel =
          GetTeacherProfilePodcastModel.fromJson(response);

      Get.find<EditProfileController>().updateTeacherArchiveLoader(true);
      
      if (Get.find<EditProfileController>().getTeacherProfileArchiveModel.data != null && 
          Get.find<EditProfileController>().getTeacherProfileArchiveModel.data!.data != null) {
        log("${Get.find<EditProfileController>().getTeacherProfileArchiveModel.data!.data!.length.toString()} Total Teacher Archive History Length");

        for (var element in Get.find<EditProfileController>()
            .getTeacherProfileArchiveModel
            .data!
            .data!) {
          Get.find<EditProfileController>()
              .updateTeacherArchiveForPagination(element);
        }
      } else {
        log("Archive data or data.data is null");
      }

      Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    } else {
      log("responseCheck is false");
      Get.find<EditProfileController>().updateTeacherArchiveLoader(true);
    }
  } catch (e, stacktrace) {
    log("Error in getTeacherArchivesRepo: $e");
    log("Stacktrace: $stacktrace");
    Get.find<EditProfileController>().updateTeacherArchiveLoader(true);
  }
}
