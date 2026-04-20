import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../controllers/contact_us_controller.dart';
import '../widgets/custom_dialog.dart';

contactUsRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<ContactUsController>().updateContactUsLoader(true);
    if (response['success'].toString() == 'true') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: LanguageConstant.success.tr,
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: response['message'].toString(),
              text: LanguageConstant.ok.tr,
              functionCall: () {
                Navigator.pop(context);
                Get.back();
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
    }
  } else if (!responseCheck) {
    Get.find<ContactUsController>().updateContactUsLoader(false);
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
