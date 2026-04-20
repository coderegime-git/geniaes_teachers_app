import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/appbar_widget.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorTwo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBarWidget(
          leadingIcon: 'assets/icons/Expand_left.png',
          leadingOnTap: () {
            Get.back();
          },
          titleText: LanguageConstant.aboutUs.tr,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.h, 0, 18.h, 18.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset("assets/images/aboutus-banner.png"),
              ),
              SizedBox(height: 18.h),
              Text(
                LanguageConstant.joinUsBeaLifeSaverForEachOthers.tr,
                style: AppTextStyles.headingTextStyle1,
              ),
              SizedBox(height: 18.h),
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae arcu ac elit dapibus pharetra. Aliquam magna elit, porttitor a elementum Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vitae arcu ac elit dapibus pharetra. Aliquam magna elit, porttitor a elementum",
                style: AppTextStyles.bodyTextStyle9,
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "1000+",
                            style: AppTextStyles.headingTextStyle6,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            LanguageConstant.tutors.tr,
                            style: AppTextStyles.subHeadingTextStyle4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "5000+",
                            style: AppTextStyles.headingTextStyle6,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            LanguageConstant.users.tr,
                            style: AppTextStyles.subHeadingTextStyle4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "500+",
                            style: AppTextStyles.headingTextStyle6,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            LanguageConstant.academies.tr,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.subHeadingTextStyle4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "150+",
                            style: AppTextStyles.headingTextStyle6,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            LanguageConstant.eventOrganiser.tr,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.subHeadingTextStyle4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
