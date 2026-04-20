import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';

import '../widgets/button_widget.dart';
import '../widgets/custom_dialog.dart';
import 'get_wallet_balance_repo.dart';
import 'get_wallet_withdrawals_repo.dart';

withdrawAmountRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: LanguageConstant.thankYou.tr,
            titleColor: AppColors.customDialogSuccessColor,
            descriptions: "Your Withdraw Request has been Deposited",
            text: LanguageConstant.ok.tr,
            functionCall: () {
              Get.back();
              Get.back();
              // Get All Wallet Withdrawals
              getMethod(context, getWalletWithdrawalURL, null, true,
                  getWalletWithdrawalsRepo);
              // Get All Wallet Balance
              getMethod(context, getWalletBalanceURL, null, true,
                  getWalletBalanceRepo);
            },
            img: 'assets/icons/dialog_success.png',
          );
        });
    // showDialog(
    //   context: Get.context!,
    //   barrierDismissible: false,
    //   builder: (_) => AlertDialog(
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Container(
    //               margin: const EdgeInsets.fromLTRB(0, 36, 0, 24),
    //               padding: const EdgeInsets.all(10),
    //               decoration: const BoxDecoration(
    //                   shape: BoxShape.circle, color: AppColors.primaryColor),
    //               child: const Icon(
    //                 Icons.check,
    //                 size: 36,
    //                 color: AppColors.offWhite,
    //               ),
    //             ),
    //             const Text(
    //               "Thank You",
    //               style: AppTextStyles.headingTextStyle1,
    //             ),
    //             SizedBox(height: 8.h),
    //             const Center(
    //               child: Text(
    //                 "Your Withdraw Request has been Deposited",
    //                 textAlign: TextAlign.center,
    //                 style: AppTextStyles.bodyTextStyle2,
    //               ),
    //             ),
    //             SizedBox(height: 36.h),
    //           ],
    //         ),
    //         SizedBox(height: 36.h),
    //         ButtonWidgetOne(
    //             onTap: () {

    //             },
    //             buttonText: "Ok",
    //             buttonTextStyle: AppTextStyles.buttonTextStyle1,
    //             borderRadius: 40,
    //             buttonColor: AppColors.gradientOne),
    //       ],
    //     ),
    //   ),
    // );
  } else if (!responseCheck) {
    // Get.find<TeacherProfileController>().updateConsultantProfileLoader(false);
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}
