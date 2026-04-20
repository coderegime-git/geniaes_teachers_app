import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorhub_for_teachers/multi_language/language_constants.dart';

import '../config/app_colors.dart';
import '../controllers/delete_account_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/pusher_beams_controller.dart';
import '../routes.dart';
import '../widgets/custom_dialog.dart';

deleteAccountRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<GeneralController>().storageBox.erase();

    Get.find<GeneralController>().storageBox.remove('userData');
    Get.find<GeneralController>().storageBox.remove('seen');
    Get.find<GeneralController>().storageBox.remove('userID');
    // Get.find<GeneralController>().box.remove('localToken');
    Get.find<GeneralController>().currentTeacherModel = null;

    if (response["success"] == true) {
      Get.find<PusherBeamsController>().clearAllStatePusherBeams();
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: LanguageConstant.thankYou.tr,
            titleColor: AppColors.customDialogSuccessColor,
            descriptions: "${response["message"]}",
            text: LanguageConstant.ok.tr,
            functionCall: () {
              Get.offAndToNamed(PageRoutes.homeScreen);
            },
            img: 'assets/icons/dialog_success.png',
          );
        });
    Get.find<DeleteAccountController>().updateDeleteAccountLoader(true);
  } else if (!responseCheck) {
    Get.find<DeleteAccountController>().updateDeleteAccountLoader(false);
  }
}
