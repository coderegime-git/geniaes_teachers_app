import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/general_controller.dart';
import '../models/teacher_appointment_history_model.dart';
import '../routes.dart';

addAppointmentRatingRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  GeneralController generalController = Get.find<GeneralController>();
  generalController.updateAppointmentStatusLoaderController(false);
  if (responseCheck) {
    if (response["success"] == true) {
      // Update local state with the new rating/comment if the server returns them
      // Assuming response['data'] contains the updated appointment info
      // Or we can manually update if we had access to the sent data,
      // but here we trust the response or just mark it as rated.
      if (response["data"] != null) {
        generalController.selectedAppointmentHistoryForView =
            TeacherAppointmentHistoryModel.fromJson(response["data"]);
      } else {
        // Fallback: just mark it as rated so the button disappears
        // In a real scenario, you might want to fetch the updated data or pass it here.
        generalController.selectedAppointmentHistoryForView =
            generalController.selectedAppointmentHistoryForView.copyWith(
          isRating: 1,
        );
      }
      generalController.update();
      Get.offNamed(PageRoutes.appointmentHistoryScreen,
          arguments: {'tabIndex': 4});
      Get.snackbar(
          "Success", response["message"] ?? "Rating submitted successfully",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Error", response["message"] ?? "Failed to submit rating",
          snackPosition: SnackPosition.BOTTOM);
    }
  } else {
    Get.snackbar("Error", "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM);
  }
}
