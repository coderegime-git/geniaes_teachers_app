import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

import '../controllers/general_controller.dart';
import '../models/get_teacher_profile_podcast_model.dart';

getTeacherBroadcastsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  log("getTeacherBroadcastsRepo called with responseCheck: $responseCheck");
  try {
    if (responseCheck) {
      log("Response data: $response");
      if (Get.find<EditProfileController>()
          .teacherProfileBroadcastForPagination
          .isNotEmpty) {
        Get.find<EditProfileController>().teacherProfileBroadcastForPagination = [];
      }
      
      Get.find<EditProfileController>().getTeacherProfileBroadcastModel =
          GetTeacherProfilePodcastModel.fromJson(response);

      Get.find<EditProfileController>().updateTeacherBroadcastLoader(true);
      
      if (Get.find<EditProfileController>().getTeacherProfileBroadcastModel.data != null && 
          Get.find<EditProfileController>().getTeacherProfileBroadcastModel.data!.data != null) {
        log("${Get.find<EditProfileController>().getTeacherProfileBroadcastModel.data!.data!.length.toString()} Total Teacher Broadcast History Length");

        for (var element in Get.find<EditProfileController>()
            .getTeacherProfileBroadcastModel
            .data!
            .data!) {
          Get.find<EditProfileController>()
              .updateTeacherBroadcastForPagination(element);
        }
      } else {
        log("Broadcast data or data.data is null");
      }

      Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    } else {
      log("responseCheck is false");
      Get.find<EditProfileController>().updateTeacherBroadcastLoader(true);
    }
  } catch (e, stacktrace) {
    log("Error in getTeacherBroadcastsRepo: $e");
    log("Stacktrace: $stacktrace");
    Get.find<EditProfileController>().updateTeacherBroadcastLoader(true);
  }
}
