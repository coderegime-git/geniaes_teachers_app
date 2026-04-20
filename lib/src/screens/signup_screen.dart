import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_configs.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/signin_controller.dart';
import '../controllers/signup_controller.dart';
import '../repositories/signup_repo.dart';
import '../routes.dart';
import '../widgets/auth_text_form_field_widget.dart';
import '../widgets/button_widget.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final logic = Get.put(SignUpController());

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final GlobalKey<FormState> _signUpFromKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<SignUpController>(builder: (signUpController) {
        return GestureDetector(
            onTap: () {
              generalController.focusOut(context);
            },
            child: ModalProgressHUD(
                progressIndicator: const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
                inAsyncCall: generalController.formLoaderController,
                child: Scaffold(
                  backgroundColor: AppColors.bgColor,
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 58, 18, 0),
                      child: Form(
                        key: _signUpFromKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                  ),
                            SizedBox(height: 28.h),
                            Text(
                              LanguageConstant.createYourAccount.tr,
                              style: AppTextStyles.bodyTextStyle1,
                            ),
                            SizedBox(height: 28.h),
                            AuthTextFormFieldWidget(
                              hintText: LanguageConstant.firstName.tr,
                              controller:
                                  signUpController.signUpFirstNameController,
                              validator: (value) {
                                if ((value ?? "").isEmpty) {
                                  return LanguageConstant
                                      .firstNameFieldRequired.tr;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            AuthTextFormFieldWidget(
                              hintText: LanguageConstant.lastName.tr,
                              controller:
                                  signUpController.signUpLastNameController,
                              validator: (value) {
                                if ((value ?? "").isEmpty) {
                                  return LanguageConstant
                                      .lastNameFieldRequired.tr;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            AuthTextFormFieldWidget(
                              hintText: LanguageConstant.email.tr,
                              controller:
                                  signUpController.signUpEmailController,
                              errorText: signUpController.emailValidator,
                              onChanged: (value) {
                                signUpController.emailValidator = null;
                                signUpController.update();
                              },
                              validator: (value) {
                                if ((value ?? "").isEmpty) {
                                  return LanguageConstant.emailFieldRequired.tr;
                                }
                                if (!GetUtils.isEmail(value!)) {
                                  return LanguageConstant
                                      .pleaseMakeSureYourEmailAddressIsValid.tr;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            AuthPasswordFormFieldWidget(
                              hintText: LanguageConstant.password.tr,
                              errorText: signUpController.passwordValidator,
                              controller:
                                  signUpController.signUpPasswordController,
                              onChanged: (value) {
                                signUpController.passwordValidator = null;
                                signUpController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant.passwordIsRequired.tr;
                                } else if (value.length < 8) {
                                  return 'Password must contains 8 digit';
                                }
                                return null;
                              },
                              suffixIcon: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                                color: AppColors.lightGrey,
                              ),
                              suffixIconOnTap: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                              obsecureText: obscurePassword,
                            ),
                            const SizedBox(height: 16),
                            AuthPasswordFormFieldWidget(
                              hintText: LanguageConstant.confirmPassword.tr,
                              errorText: signUpController.passwordValidator,
                              controller: signUpController
                                  .signUpConfirmPasswordController,
                              onChanged: (value) {
                                signUpController.passwordValidator = null;
                                signUpController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant.passwordIsRequired.tr;
                                } else if (signUpController
                                        .signUpPasswordController.text !=
                                    signUpController
                                        .signUpConfirmPasswordController.text) {
                                  return 'Password does\'nt match';
                                }
                                return null;
                              },
                              suffixIcon: Icon(
                                obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                                color: AppColors.lightGrey,
                              ),
                              suffixIconOnTap: () {
                                setState(() {
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword;
                                });
                              },
                              obsecureText: obscureConfirmPassword,
                            ),
                            SizedBox(height: 22.h),
                            ButtonWidgetOne(
                              borderRadius: 40,
                              buttonColor: AppColors.gradientOne,
                              buttonText: LanguageConstant.signUp.tr,
                              buttonTextStyle: AppTextStyles.buttonTextStyle1,
                              onTap: () {
                                ///---keyboard-close
                                // FocusScopeNode currentFocus =
                                //     FocusScope.of(context);
                                // if (!currentFocus.hasPrimaryFocus) {
                                //   currentFocus.unfocus();
                                // }

                                ///
                                if (_signUpFromKey.currentState!.validate()) {
                                  ///loader
                                  // generalController.changeLoaderCheck(true);
                                  generalController
                                      .updateFormLoaderController(true);
                                  signUpController.emailValidator = null;
                                  signUpController.passwordValidator = null;
                                  signUpController.update();
                                  generalController.focusOut(context);

                                  ///post-method
                                  postMethod(
                                      context,
                                      signUpWithEmailURL,
                                      {
                                        'email': signUpController
                                            .signUpEmailController.text,
                                        'first_name': signUpController
                                            .signUpFirstNameController.text,
                                        'last_name': signUpController
                                            .signUpLastNameController.text,
                                        'password': signUpController
                                            .signUpPasswordController.text,
                                        'password_confirmation':
                                            signUpController
                                                .signUpConfirmPasswordController
                                                .text,
                                        'login_as': "teacher",
                                      },
                                      true,
                                      signUpWithEmailRepo);
                                }
                              },
                            ),
                            SizedBox(height: 28.h),
                            Text(
                              LanguageConstant.orSignUpWith.tr,
                              style: AppTextStyles.bodyTextStyle2,
                            ),
                            SizedBox(height: 22.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetThree(
                                  buttonIcon: "assets/icons/Google.png",
                                  buttonText:
                                      LanguageConstant.signInViaGoogle.tr,
                                  iconHeight: 25.h,
                                  onTap: () {
                                    Get.find<SigninController>()
                                        .signInWithGoogle();
                                  },
                                ),
                                SizedBox(width: 14.w),
                                ButtonWidgetThree(
                                  buttonIcon: "assets/icons/Facebook.png",
                                  buttonText:
                                      LanguageConstant.signInViaFacebook.tr,
                                  iconHeight: 25.h,
                                  onTap: () {
                                    Get.find<SigninController>()
                                        .signinWithFacebook();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 22.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LanguageConstant.alreadyHaveAnAccount.tr,
                                  style: AppTextStyles.bodyTextStyle2,
                                ),
                                SizedBox(width: 6.h),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(PageRoutes.signinScreen);
                                  },
                                  child: Text(LanguageConstant.signIn.tr,
                                      style: AppTextStyles.underlineTextStyle1),
                                ),
                              ],
                            ),
                            SizedBox(height: 22.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                )));
      });
    });
  }
}
