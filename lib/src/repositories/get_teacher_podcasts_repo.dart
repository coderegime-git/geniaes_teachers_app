import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

import '../controllers/general_controller.dart';
import '../models/get_teacher_profile_podcast_model.dart';

getTeacherPodcastsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<EditProfileController>()
        .teacherProfilePodcastForPagination
        .isNotEmpty) {
      Get.find<EditProfileController>().teacherProfilePodcastForPagination = [];
    }
    Get.find<EditProfileController>().getTeacherProfilePodcastModel =
        GetTeacherProfilePodcastModel.fromJson(response);

    Get.find<EditProfileController>().updateTeacherPodcastLoader(true);
    log("${Get.find<EditProfileController>().getTeacherProfilePodcastModel.data!.data!.length.toString()} Total Teacher Podcast History Length");

    log("${Get.find<EditProfileController>().getTeacherProfilePodcastModel.data!.data!} Only Data Teacher Podcast History");

    for (var element in Get.find<EditProfileController>()
        .getTeacherProfilePodcastModel
        .data!
        .data!) {
      Get.find<EditProfileController>()
          .updateTeacherPodcastForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<EditProfileController>().updateTeacherPodcastLoader(true);
  }
}
