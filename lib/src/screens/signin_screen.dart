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
import '../repositories/signin_repo.dart';
import '../routes.dart';
import '../widgets/auth_text_form_field_widget.dart';
import '../widgets/button_widget.dart';

class SigninScreen extends StatefulWidget {
  SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final logic = Get.put(SigninController());

  bool boolValue = false;
  bool obscurePassword = true;

  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GestureDetector(onTap: () {
        generalController.focusOut(context);
      }, child: GetBuilder<SigninController>(builder: (signInController) {
        return ModalProgressHUD(
            progressIndicator: const CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
            inAsyncCall: generalController.formLoaderController,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                backgroundColor: AppColors.bgColor,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 75, 18.w, 0),
                    child: Form(
                      key: _loginFormKey,
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
                          SizedBox(height: 32.h),
                          Text(
                            LanguageConstant.loginToYourAccount.tr,
                            style: AppTextStyles.bodyTextStyle1,
                          ),
                          SizedBox(height: 24.h),
                          AuthTextFormFieldWidget(
                            hintText: LanguageConstant.userNameEmail.tr,
                            controller: signInController.emailController,
                            onChanged: (value) {
                              signInController.emailValidator = null;
                              signInController.update();
                            },
                            validator: (value) {
                              if ((value ?? "").isEmpty) {
                                return LanguageConstant
                                    .userNameFieldRequired.tr;
                              }
                              if (!GetUtils.isEmail(value!)) {
                                return LanguageConstant
                                    .pleaseMakeSureYourEmailAddressIsValid.tr;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          AuthPasswordFormFieldWidget(
                            hintText: LanguageConstant.password.tr,
                            controller: signInController.passwordController,
                            onChanged: (value) {
                              signInController.passwordValidator = null;
                              signInController.update();
                            },
                            validator: (value) {
                              if ((value ?? "").isEmpty) {
                                return LanguageConstant.passwordIsRequired.tr;
                              }
                              return null;
                            },
                            suffixIconOnTap: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            suffixIcon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20.h,
                              color: AppColors.lightGrey,
                            ),
                            obsecureText: obscurePassword,
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Row(
                              //   children: [
                              //     Checkbox(
                              //       value: boolValue,
                              //       tristate: false,
                              //       activeColor: AppColors.primaryColo
                              //       visualDensity: const VisualDensity(
                              //           horizontal: -2, vertical: 2),
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(5)),
                              //       side: const BorderSide(
                              //           color: AppColors.primaryColor),
                              //       onChanged: (bool? boolValue) {
                              //         // setState(() {
                              //         //   this.boolValue = boolValue!;
                              //         // });
                              //       },
                              //     ),
                              //     const Text(
                              //       "Remember",
                              //       style: AppTextStyles.bodyTextStyle11,
                              //     )
                              //   ],
                              // ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(PageRoutes.forgotPasswordScreen);
                                },
                                child: Text(
                                  LanguageConstant.forgotPassword.tr,
                                  style: AppTextStyles.buttonTextStyle3,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 16.h),
                          ButtonWidgetOne(
                            borderRadius: 40,
                            buttonColor: AppColors.gradientOne,
                            buttonText: LanguageConstant.signIn.tr,
                            buttonTextStyle: AppTextStyles.buttonTextStyle1,
                            onTap: () {
                              if (_loginFormKey.currentState!.validate()) {
                                generalController.focusOut(context);
                                generalController
                                    .updateFormLoaderController(true);
                                postMethod(
                                    context,
                                    signInWithEmailURL,
                                    {
                                      'email':
                                          signInController.emailController.text,
                                      'password': signInController
                                          .passwordController.text,
                                      'login_as': "teacher"
                                    },
                                    true,
                                    signInWithEmailRepo);
                              }
                            },
                          ),
                          SizedBox(height: 28.h),
                          Text(
                            LanguageConstant.orSignInWith.tr,
                            style: AppTextStyles.bodyTextStyle2,
                          ),
                          SizedBox(height: 22.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonWidgetThree(
                                buttonIcon: "assets/icons/Google.png",
                                buttonText: "Login Via Google",
                                iconHeight: 25.h,
                                onTap: () {
                                  signInController.signInWithGoogle();
                                },
                              ),
                              SizedBox(width: 14.w),
                              ButtonWidgetThree(
                                buttonIcon: "assets/icons/Facebook.png",
                                buttonText: "Login Via Facebook",
                                iconHeight: 25.h,
                                onTap: () {
                                  signInController.signinWithFacebook();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LanguageConstant.dontHaveAnAccount.tr,
                                style: AppTextStyles.bodyTextStyle2,
                              ),
                              SizedBox(width: 6.h),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(PageRoutes.signupScreen);
                                },
                                child: Text(LanguageConstant.signUp.tr,
                                    style: AppTextStyles.underlineTextStyle1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
      }));
    });
  }
}
