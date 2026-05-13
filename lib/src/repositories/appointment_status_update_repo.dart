import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../models/teacher_appointment_history_model.dart';
import '../routes.dart';
import '../widgets/custom_dialog.dart';

appointmentStatusUpdateRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  GeneralController generalController = Get.find<GeneralController>();
  if (responseCheck) {
    if (response["success"] == true) {
      generalController.updateAppointmentStatusLoaderController(false);
      if (response["data"] != null &&
          response["data"]["appointment_status_code"] == 5) {
        getMethod(
            context,
            "$getFilterAppointmentLogDetailURL${response["data"]["id"]}",
            null,
            true, (context, check, res) {
          if (check && res["success"] == true) {
            Map<String, dynamic> oldData =
                generalController.selectedAppointmentHistoryForView.toJson();
            Map<String, dynamic> newData =
                Map<String, dynamic>.from(res["data"]);

            // Merge newData into oldData (preserving old values for null new ones)
            newData.forEach((key, value) {
              if (value != null) {
                oldData[key] = value;
              }
            });

            // Fallback for status name if still null
            if (oldData["appointment_status_name"] == null ||
                oldData["appointment_status_name"] == "") {
              if (oldData["appointment_status_code"] == 5) {
                oldData["appointment_status_name"] = "Completed";
              }
            }

            generalController.selectedAppointmentHistoryForView =
                TeacherAppointmentHistoryModel.fromJson(oldData);
            generalController.update();
          }
        });
      } else {
        Get.toNamed(PageRoutes.homeScreen);
      }
    }
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Please Try Again",
            titleColor: AppColors.customDialogErrorColor,
            descriptions: '${response["message"]}',
            text: "Ok",
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}
