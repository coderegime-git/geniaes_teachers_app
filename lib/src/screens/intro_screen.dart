import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import 'package:tutorhub_for_teachers/multi_language/language_constants.dart';

import '../config/app_colors.dart';
import '../config/app_configs.dart';
import '../config/app_text_styles.dart';

import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';
import '../routes.dart';
import '../widgets/button_widget.dart';
import '../widgets/intro_indicator_slider_widget.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorTwo,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.gradientOne,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 240.h, 0, 0),
            decoration: const BoxDecoration(
              color: AppColors.silverColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(110),
                topLeft: Radius.circular(110),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 280.h, 0, 0),
            decoration: const BoxDecoration(
              color: AppColors.bgColorTwo,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(120),
                topLeft: Radius.circular(120),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Get.find<GetAllSettingsController>()
                            .getAllSettingsModel
                            .data!
                            .logo!
                            .isEmpty
                        ? Image.asset(
                            "assets/icons/logo-text.png",
                            width: 230.w,
                          )
                        : Image.network(
                            "${AppConfigs.mediaUrl}${Get.find<GetAllSettingsController>().getAllSettingsModel.data!.logo}",
                            width: 230.w,
                            color: AppColors.white,
                          ),
                  ],
                ),
                AspectRatio(
                  aspectRatio: 0.68,
                  child: IndicatorSliderWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 22, 70, 22),
                  child: ButtonWidgetOne(
                    buttonText: LanguageConstant.next.tr,
                    onTap: () {
                      if (Get.find<GeneralController>()
                              .storageBox
                              .read('authToken') !=
                          null) {
                        Get.toNamed(PageRoutes.homeScreen);
                      } else {
                        Get.toNamed(PageRoutes.signinScreen);
                      }
                    },
                    buttonTextStyle: AppTextStyles.buttonTextStyle1,
                    borderRadius: 40,
                    buttonColor: AppColors.gradientOne,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
