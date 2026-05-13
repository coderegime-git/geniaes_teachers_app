import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';

import '../controllers/general_controller.dart';
import '../models/all_blog_posts_model.dart';

getTeacherBlogsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  log("getTeacherBlogsRepo called with responseCheck: $responseCheck");
  try {
    if (responseCheck) {
      log("Response data: $response");
      if (Get.find<EditProfileController>()
          .teacherProfileBlogForPagination
          .isNotEmpty) {
        Get.find<EditProfileController>().teacherProfileBlogForPagination = [];
      }
      
      Get.find<EditProfileController>().getTeacherProfileBlogModel =
          GetAllBlogPostsModel.fromJson(response);

      Get.find<EditProfileController>().updateTeacherBlogLoader(true);
      
      if (Get.find<EditProfileController>().getTeacherProfileBlogModel.data != null && 
          Get.find<EditProfileController>().getTeacherProfileBlogModel.data!.data != null) {
        log("${Get.find<EditProfileController>().getTeacherProfileBlogModel.data!.data!.length.toString()} Total Teacher Blog History Length");

        for (var element in Get.find<EditProfileController>()
            .getTeacherProfileBlogModel
            .data!
            .data!) {
          Get.find<EditProfileController>()
              .updateTeacherBlogForPagination(element);
        }
      } else {
        log("Blog data or data.data is null");
      }

      Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    } else {
      log("responseCheck is false");
      Get.find<EditProfileController>().updateTeacherBlogLoader(true);
    }
  } catch (e, stacktrace) {
    log("Error in getTeacherBlogsRepo: $e");
    log("Stacktrace: $stacktrace");
    Get.find<EditProfileController>().updateTeacherBlogLoader(true);
  }
}
