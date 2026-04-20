import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_booked_services_controller.dart';
import '../models/teacher_booked_services_model.dart';

getAllTeacherBookedServicesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<TeacherBookedServicesController>()
        .teacherAllBookedServicesListForPagination
        .isNotEmpty) {
      Get.find<TeacherBookedServicesController>()
          .teacherAllBookedServicesListForPagination = [];
    }
    Get.find<TeacherBookedServicesController>().getTeacherBookedServicesModel =
        GetTeacherBookedServicesModel.fromJson(response);

    Get.find<TeacherBookedServicesController>()
        .updateTeacherBookedServicesLoader(true);
    log("${Get.find<TeacherBookedServicesController>().getTeacherBookedServicesModel.data!.data!.length.toString()} Total TeacherBooked Services Length");
    log("${Get.find<TeacherBookedServicesController>().getTeacherBookedServicesModel.data!.data!.where((i) => i.serviceStatusName == "Completed").toList().length.toString()} Total Completed TeacherBooked Services Length");
    log("${Get.find<TeacherBookedServicesController>().getTeacherBookedServicesModel.data!.data!} Only Data TeacherBooked Services");

    for (var element in Get.find<TeacherBookedServicesController>()
        .getTeacherBookedServicesModel
        .data!
        .data!) {
      Get.find<TeacherBookedServicesController>()
          .updateTeacherListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);
  } else if (!responseCheck) {
    Get.find<TeacherBookedServicesController>()
        .updateTeacherBookedServicesLoader(true);
  }
}
