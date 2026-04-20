import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/teacher_appointment_history_controller.dart';
import '../controllers/general_controller.dart';
import '../models/teacher_appointment_history_model.dart';

getAllTeacherAppointmentHistoryRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (Get.find<TeacherAppointmentHistoryController>()
        .teacherAllAppointmentHistoryListForPagination
        .isNotEmpty) {
      Get.find<TeacherAppointmentHistoryController>()
          .teacherAllAppointmentHistoryListForPagination = [];
    }
    Get.find<TeacherAppointmentHistoryController>()
            .getTeacherAppointmentHistoryModel =
        GetTeacherAppointmentHistoryModel.fromJson(response);

    Get.find<TeacherAppointmentHistoryController>()
        .updateTeacherAppointmentHistoryLoader(true);
    log("${Get.find<TeacherAppointmentHistoryController>().getTeacherAppointmentHistoryModel.data!.data!.length.toString()} Total Teacher Appoinment History Length");
    log("${Get.find<TeacherAppointmentHistoryController>().getTeacherAppointmentHistoryModel.data!.data!.where((i) => i.appointmentStatusName == "Completed").toList().length.toString()} Total Completed Teacher Appoinment History Length");
    log("${Get.find<TeacherAppointmentHistoryController>().getTeacherAppointmentHistoryModel.data!.data!} Only Data Teacher Appoinment History");

    // Map<String, dynamic> createAppointmentPayload() {
    //   Map<String, dynamic> appointment = {
    //     "id": 38,
    //     "student_id": 4,
    //     "student_name": "Ahsan101 Mono",
    //     "student_image":
    //         "/files/profile_images/1693388416scaled_image_picker500202318720402858.jpg",
    //     "appointment_status_name": "Pending",
    //     "appointment_type_name": "Video Call",
    //     "is_schedule_required": 1,
    //     "teacher_id": 15,
    //     "teacher_name": "Isabella-fk Carrington",
    //     "teacher_image": "/images/teachers/64d0f6a82b9af.png",
    //     "academy_id": null,
    //     "academy_name": null,
    //     "academy_image": null,
    //     "date": "31/08/2023",
    //     "start_time": "21:20",
    //     "end_time": "21:20",
    //     "fee": 10,
    //     "is_paid": 1,
    //     "appointment_type_id": 1,
    //     "question": "tes",
    //     "attachment_url": null,
    //     "appointment_status_code": 1
    //   };

    //   Map<String, dynamic> payload = {
    //     "appointment": appointment,
    //     "channel_name": "channel ne",
    //     "token": "channel ne"
    //   };

    //   return payload;
    // }

    for (var element in Get.find<TeacherAppointmentHistoryController>()
        .getTeacherAppointmentHistoryModel
        .data!
        .data!) {
      Get.find<TeacherAppointmentHistoryController>()
          .updateTeacherListForPagination(element);
    }

    Get.find<GeneralController>().changeGetPaginationProgressCheck(false);

    // if (Get.find<AllTeachersCategoriesController>().getAllTeacherCategoriesDataModel.status == true) {
    // } else {}
  } else if (!responseCheck) {
    Get.find<TeacherAppointmentHistoryController>()
        .updateTeacherAppointmentHistoryLoader(true);
  }
}
