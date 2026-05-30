import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_appointment_history_controller.dart';
import '../controllers/pusher_beams_controller.dart';
import '../controllers/sign_out_user_controller.dart';

import '../routes.dart';
import '../widgets/custom_dialog.dart';

signOutUserRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  
  Get.find<GeneralController>().storageBox.erase();

  Get.find<GeneralController>().storageBox.remove('userData');
  Get.find<GeneralController>().storageBox.remove('seen');
  Get.find<GeneralController>().storageBox.remove('userID');
  Get.find<GeneralController>().storageBox.remove('pusherID');
  if (Get.find<TeacherAppointmentHistoryController>()
      .teacherAllAppointmentHistoryListForPagination
      .isNotEmpty) {
    Get.find<TeacherAppointmentHistoryController>()
        .teacherAllAppointmentHistoryListForPagination = [];
  }
  
  Get.find<GeneralController>().currentTeacherModel = null;
  Get.offAndToNamed(PageRoutes.signinScreen);
  Get.find<SignOutUserController>().updateSignOutLoaderController(false);
  Get.find<PusherBeamsController>().clearAllStatePusherBeams();
}
