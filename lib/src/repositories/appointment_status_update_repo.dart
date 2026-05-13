import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../routes.dart';
import '../widgets/custom_dialog.dart';

appointmentStatusUpdateRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response["success"] == true) {
      Get.find<GeneralController>()
          .updateAppointmentStatusLoaderController(false);
      if (response["data"] != null &&
          response["data"]["appointment_status_code"] == 5) {
        Get.offNamed(PageRoutes.appointmentHistoryScreen,
            arguments: {'tabIndex': 4});
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
