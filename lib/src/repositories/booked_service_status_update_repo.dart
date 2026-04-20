import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../routes.dart';
import '../widgets/custom_dialog.dart';

bookedServiceStatusUpdateRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response["success"] == true) {
      Get.find<GeneralController>()
          .updateBookedServiceStatusLoaderController(false);
      Get.toNamed(PageRoutes.homeScreen);
    }
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: LanguageConstant.pleaseTryAgain.tr,
            titleColor: AppColors.customDialogErrorColor,
            descriptions: '${response["message"]}',
            text: LanguageConstant.ok.tr,
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}
