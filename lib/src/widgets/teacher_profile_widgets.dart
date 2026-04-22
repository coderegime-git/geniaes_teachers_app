import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:resize/resize.dart';
import 'package:tutorhub_for_teachers/multi_language/language_constants.dart';

import '../api_services/delete_service.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/general_controller.dart';
import '../repositories/edit_user_profile_repo.dart';
import '../repositories/get_teacher_certificate_repo.dart';
import '../repositories/get_teacher_education_repo.dart';
import '../repositories/get_teacher_experience_repo.dart';
import '../repositories/get_teacher_podcasts_repo.dart';
import '../models/categories_tags_model.dart';
import 'appbar_widget.dart';
import 'button_widget.dart';
import 'custom_dialog.dart';
import 'text_form_field_widget.dart';

class TeacherBasicInformationWidget extends StatefulWidget {
  const TeacherBasicInformationWidget({super.key});

  @override
  State<TeacherBasicInformationWidget> createState() =>
      _TeacherBasicInformationWidgetState();
}

class _TeacherBasicInformationWidgetState
    extends State<TeacherBasicInformationWidget> {
  final generalLogic = Get.put(GeneralController());
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: AppBarWidget(
                  leadingIcon: 'assets/icons/Expand_left.png',
                  leadingIconColor: AppColors.white,
                  leadingOnTap: () {
                    Get.back();
                  },
                  titleText: LanguageConstant.basicInformation.tr,
                  appBarTextStyle: AppTextStyles.appbarTextStyle2,
                  appBarColor: AppColors.primaryColor,
                ),
              ),
              body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                    child: Form(
                      key: _userProfileUpdateFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.firstName.tr}',
                            controller:
                            editProfileController.userProfileFirstNameController,
                            onChanged: (String? value) {
                              editProfileController
                                  .userProfileFirstNameController.text ==
                                  value;
                              editProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant.firstNameFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.lastName.tr}',
                            controller:
                            editProfileController.userProfileLastNameController,
                            onChanged: (String? value) {
                              editProfileController
                                  .userProfileLastNameController.text ==
                                  value;
                              editProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant.lastNameFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.username.tr}',
                            controller:
                            editProfileController.userProfileUserNameController,
                            onChanged: (String? value) {
                              editProfileController
                                  .userProfileUserNameController.text ==
                                  value;
                              editProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant.userNameFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.description.tr}',
                            controller:
                            editProfileController.userProfileDescriptionController,
                            onChanged: (String? value) {
                              editProfileController
                                  .userProfileDescriptionController.text ==
                                  value;
                              editProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant.descriptionFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.addressLine1.tr}',
                            controller:
                            editProfileController.userProfileAddressLine1Controller,
                            onChanged: (String? value) {
                              editProfileController
                                  .userProfileAddressLine1Controller.text ==
                                  value;
                              editProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant.addressLine1FieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.addressLine2.tr}',
                            controller:
                            editProfileController.userProfileAddressLine2Controller,
                            onChanged: (String? value) {
                              editProfileController
                                  .userProfileAddressLine2Controller.text ==
                                  value;
                              editProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant.addressLine2FieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormFieldWidget(
                            hintText: '* ${LanguageConstant.zipCode.tr}',
                            controller:
                            editProfileController.userProfileZipCodeController,
                            onChanged: (String? value) {
                              editProfileController.userProfileZipCodeController.text ==
                                  value;
                              editProfileController.update();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return LanguageConstant.zipCodeFieldRequired.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 24.h),
                          ButtonWidgetOne(
                              onTap: () async {
                                FocusScopeNode currentFocus = FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                if (_userProfileUpdateFormKey.currentState!
                                    .validate()) {
                                  if (editProfileController.profileImage != null) {
                                    log("${editProfileController.profileImage!.path} Inside If");
                                    Get.find<GeneralController>()
                                        .updateFormLoaderController(true);
                                    editUserProfileImageRepo(
                                      editProfileController
                                          .userProfileFirstNameController.text,
                                      editProfileController
                                          .userProfileLastNameController.text,
                                      editProfileController
                                          .userProfileUserNameController.text,
                                      editProfileController
                                          .userProfileDescriptionController.text,
                                      editProfileController
                                          .userProfileAddressLine1Controller.text,
                                      editProfileController
                                          .userProfileAddressLine2Controller.text,
                                      editProfileController
                                          .userProfileZipCodeController.text,
                                      [1],
                                      [1],
                                      [1],
                                      editProfileController.profileImage,
                                      editProfileController.profileImage,
                                    );
                                  } else if (generalLogic
                                      .currentTeacherModel!.loginInfo!.image !=
                                      null &&
                                      editProfileController.profileImage == null) {
                                    Get.find<GeneralController>()
                                        .updateFormLoaderController(true);
                                    postMethod(
                                        context,
                                        editUserProfileURL,
                                        {
                                          "logged_in_as": "teacher",
                                          "first_name": editProfileController
                                              .userProfileFirstNameController.text,
                                          "last_name": editProfileController
                                              .userProfileLastNameController.text,
                                          "user_name": editProfileController
                                              .userProfileUserNameController.text,
                                          "description": editProfileController
                                              .userProfileDescriptionController.text,
                                          "address_line_1": editProfileController
                                              .userProfileAddressLine1Controller.text,
                                          "address_line_2": editProfileController
                                              .userProfileAddressLine2Controller.text,
                                          "city_id": 1,
                                          "country_id": 1,
                                          "state_id": 1,
                                          "zip_code": editProfileController
                                              .userProfileZipCodeController.text,
                                          "teacher_categories": [1],
                                          "languages": [1],
                                          "tags": [1],
                                        },
                                        true,
                                        editUserProfileDataRepo);
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                            title: LanguageConstant.sorry.tr,
                                            titleColor:
                                            AppColors.customDialogErrorColor,
                                            descriptions: 'Inside Screen Popup',
                                            text: LanguageConstant.ok.tr,
                                            functionCall: () {
                                              Navigator.pop(context);
                                            },
                                            img: 'assets/icons/dialog_error.png',
                                          );
                                        });
                                  }
                                }
                              },
                              buttonText: LanguageConstant.saveProfile.tr,
                              buttonTextStyle: AppTextStyles.buttonTextStyle9,
                              borderRadius: 40,
                              buttonColor: AppColors.gradientOne),
                        ],
                      ),
                    ),
                  )),
            );
          });
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EDUCATION
// ─────────────────────────────────────────────────────────────────────────────

class TeacherEducationWidget extends StatefulWidget {
  TeacherEducationWidget({super.key});

  @override
  State<TeacherEducationWidget> createState() => _TeacherEducationWidgetState();
}

class _TeacherEducationWidgetState extends State<TeacherEducationWidget> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();
  bool isVisibleEducationForm = false;
  File? file;

  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => file = File(result.files.single.path!));
    }
  }

  @override
  void initState() {
    super.initState();
    getMethod(context, getUserProfileEducationsURL, null, true,
        getTeacherEducationRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
            return Scaffold(
              backgroundColor: AppColors.bgColorTwo,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: AppBarWidget(
                  leadingIcon: 'assets/icons/Expand_left.png',
                  leadingOnTap: () {
                    Get.back();
                  },
                  titleText: LanguageConstant.education.tr,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Form(
                    key: _userProfileUpdateFormKey,
                    child: Column(
                      children: [
                        isVisibleEducationForm == false
                            ? Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.addNewTeacherEducation.tr,
                                style: AppTextStyles.headingTextStyle1,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: ButtonWidgetOne(
                                    onTap: () {
                                      setState(() {
                                        isVisibleEducationForm = true;
                                        if (editProfileController
                                            .educationInstituteNameController
                                            .text
                                            .isNotEmpty) {
                                          editProfileController
                                              .educationInstituteNameController
                                              .clear();
                                          editProfileController
                                              .educationDescriptionController
                                              .clear();
                                          editProfileController
                                              .educationStartDateController
                                              .clear();
                                          editProfileController
                                              .educationEndDateController
                                              .clear();
                                          editProfileController
                                              .educationDegreeController
                                              .clear();
                                          editProfileController
                                              .educationSubjectController
                                              .clear();
                                        }
                                      });
                                    },
                                    buttonText: LanguageConstant.add.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle9,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                              ),
                            ],
                          ),
                        )
                            : const SizedBox(),
                        isVisibleEducationForm == true
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldWidget(
                              hintText: LanguageConstant.instituteName.tr,
                              controller: editProfileController
                                  .educationInstituteNameController,
                              onChanged: (String? value) {
                                editProfileController
                                    .educationInstituteNameController
                                    .text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant
                                      .instituteNameFieldRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            Material(
                              elevation: 6.0,
                              borderRadius: BorderRadius.circular(30),
                              shadowColor: Colors.grey.withOpacity(0.4),
                              child: TextField(
                                style: AppTextStyles.hintTextStyle1,
                                maxLines: 4,
                                controller: editProfileController
                                    .educationDescriptionController,
                                onChanged: (String? value) {
                                  editProfileController
                                      .educationDescriptionController
                                      .text ==
                                      value;
                                  editProfileController.update();
                                },
                                decoration: InputDecoration(
                                  hintText: LanguageConstant.description.tr,
                                  hintStyle: AppTextStyles.hintTextStyle1,
                                  labelStyle: AppTextStyles.hintTextStyle1,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20, 12, 20, 12),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.degree.tr,
                                  controller: editProfileController
                                      .educationDegreeController,
                                  onChanged: (String? value) {
                                    editProfileController
                                        .educationDegreeController.text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .degreeFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.subject.tr,
                                  controller: editProfileController
                                      .educationSubjectController,
                                  onChanged: (String? value) {
                                    editProfileController
                                        .educationSubjectController
                                        .text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .subjectFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ]),
                            SizedBox(height: 20.h),
                            Row(children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.startDate.tr,
                                  controller: editProfileController
                                      .educationStartDateController,
                                  onChanged: (String? value) {
                                    editProfileController
                                        .educationStartDateController
                                        .text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .startDateFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.endDate.tr,
                                  controller: editProfileController
                                      .educationEndDateController,
                                  onChanged: (String? value) {
                                    editProfileController
                                        .educationEndDateController
                                        .text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .endDateFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ]),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 24.h, 0, 12.h),
                              margin: EdgeInsets.fromLTRB(0, 20.h, 0, 24.h),
                              decoration: BoxDecoration(
                                color:
                                AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageConstant.uploadYourDocument.tr,
                                    style: AppTextStyles.bodyTextStyle2,
                                  ),
                                  SizedBox(width: 10.w),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        80.w, 16.h, 80.w, 12.h),
                                    child: ButtonWidgetOne(
                                        onTap: () {
                                          filePick();
                                        },
                                        buttonText:
                                        LanguageConstant.chooseFile.tr,
                                        buttonTextStyle:
                                        AppTextStyles.buttonTextStyle9,
                                        borderRadius: 40,
                                        buttonColor: AppColors.gradientOne),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                              decoration: BoxDecoration(
                                color:
                                AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        24.h, 0, 24.h, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/File_dock.png",
                                              height: 24.h,
                                            ),
                                            SizedBox(width: 10.w),
                                            file == null
                                                ? Text(
                                              LanguageConstant
                                                  .educationFileNameHere
                                                  .tr,
                                              style: AppTextStyles
                                                  .hintTextStyle1,
                                            )
                                                : Text(
                                              file!.path
                                                  .toString()
                                                  .split("/")
                                                  .last
                                                  .toString(),
                                              style: AppTextStyles
                                                  .hintTextStyle1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10.w),
                                        file == null
                                            ? const SizedBox()
                                            : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              file = null;
                                            });
                                          },
                                          child: Image.asset(
                                            "assets/icons/Subtract.png",
                                            color:
                                            AppColors.primaryColor,
                                            height: 20.h,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetOne(
                                    onTap: () {
                                      setState(() {
                                        isVisibleEducationForm = false;
                                      });
                                    },
                                    buttonText: LanguageConstant.back.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                                SizedBox(width: 10.w),
                                ButtonWidgetOne(
                                    onTap: () async {
                                      FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      if (_userProfileUpdateFormKey
                                          .currentState!
                                          .validate()) {
                                        addUserProfileEducationDataRepo(
                                            editProfileController
                                                .educationInstituteNameController
                                                .text,
                                            editProfileController
                                                .educationDescriptionController
                                                .text,
                                            editProfileController
                                                .educationStartDateController
                                                .text,
                                            editProfileController
                                                .educationEndDateController
                                                .text,
                                            editProfileController
                                                .educationDegreeController
                                                .text,
                                            editProfileController
                                                .educationSubjectController
                                                .text,
                                            file!,
                                            1);
                                      } else {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return CustomDialogBox(
                                                title:
                                                LanguageConstant.sorry.tr,
                                                titleColor: AppColors
                                                    .customDialogErrorColor,
                                                descriptions:
                                                'Inside Screen Popup',
                                                text: 'Ok',
                                                functionCall: () {
                                                  Navigator.pop(context);
                                                },
                                                img:
                                                'assets/icons/dialog_error.png',
                                              );
                                            });
                                      }
                                    },
                                    buttonText: LanguageConstant.submit.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                              ],
                            ),
                          ],
                        )
                            : editProfileController
                            .teacherProfileEducationForPagination.isNotEmpty
                            ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: editProfileController
                              .teacherProfileEducationForPagination
                              .length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 14.h),
                              padding: EdgeInsets.fromLTRB(
                                  12.w, 8.h, 12.w, 8.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      editProfileController
                                          .teacherProfileEducationForPagination[
                                      index]
                                          .institute!,
                                      style:
                                      AppTextStyles.bodyTextStyle20),
                                  Row(
                                    children: [
                                      ButtonWidgetSeven(
                                        onTap: () {},
                                        buttonIconColor:
                                        AppColors.primaryColor,
                                        buttonIcon: Icons.download,
                                        iconSize: 22.h,
                                      ),
                                      SizedBox(width: 22.w),
                                      ButtonWidgetSeven(
                                        buttonIcon: Icons.edit,
                                        buttonIconColor:
                                        AppColors.primaryColor,
                                        iconSize: 22.h,
                                        onTap: () {
                                          setState(() {
                                            isVisibleEducationForm = true;
                                            editProfileController
                                                .educationInstituteNameController
                                                .text =
                                            editProfileController
                                                .teacherProfileEducationForPagination[
                                            index]
                                                .institute!;
                                            editProfileController
                                                .educationDescriptionController
                                                .text =
                                            editProfileController
                                                .teacherProfileEducationForPagination[
                                            index]
                                                .description!;
                                            editProfileController
                                                .educationStartDateController
                                                .text =
                                            editProfileController
                                                .teacherProfileEducationForPagination[
                                            index]
                                                .from!;
                                            editProfileController
                                                .educationEndDateController
                                                .text =
                                            editProfileController
                                                .teacherProfileEducationForPagination[
                                            index]
                                                .to!;
                                            editProfileController
                                                .educationDegreeController
                                                .text =
                                            editProfileController
                                                .teacherProfileEducationForPagination[
                                            index]
                                                .degree!;
                                            editProfileController
                                                .educationSubjectController
                                                .text =
                                            editProfileController
                                                .teacherProfileEducationForPagination[
                                            index]
                                                .subject!;
                                          });
                                        },
                                      ),
                                      SizedBox(width: 22.w),
                                      ButtonWidgetSeven(
                                        buttonIcon: Icons.delete,
                                        buttonIconColor:
                                        AppColors.carrotRed,
                                        iconSize: 22.h,
                                        onTap: () {
                                          deleteMethod(
                                              context,
                                              "$addEditUserProfileEducationURL/${editProfileController.teacherProfileEducationForPagination[index].id!}",
                                              null,
                                              true,
                                              deleteUserProfileEducationDataRepo);
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            : Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80.h),
                            child: Text(
                              LanguageConstant.noDataFound.tr,
                              style: AppTextStyles.bodyTextStyle2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CERTIFICATE
// ─────────────────────────────────────────────────────────────────────────────

class TeacherCertificateWidget extends StatefulWidget {
  TeacherCertificateWidget({super.key});

  @override
  State<TeacherCertificateWidget> createState() =>
      _TeacherCertificateWidgetState();
}

class _TeacherCertificateWidgetState extends State<TeacherCertificateWidget> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();
  bool isVisibleEducationForm = false;
  File? file;

  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => file = File(result.files.single.path!));
    }
  }

  @override
  void initState() {
    super.initState();
    getMethod(context, getUserProfileCertificateURL, null, true,
        getTeacherCertificateRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: AppBarWidget(
                  leadingIcon: 'assets/icons/Expand_left.png',
                  leadingOnTap: () {
                    Get.back();
                  },
                  titleText: LanguageConstant.certification.tr,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Form(
                    key: _userProfileUpdateFormKey,
                    child: Column(
                      children: [
                        isVisibleEducationForm == false
                            ? Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.addNewTeacherCertificate.tr,
                                style: AppTextStyles.headingTextStyle1,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: ButtonWidgetOne(
                                    onTap: () {
                                      setState(() {
                                        isVisibleEducationForm = true;
                                        if (editProfileController
                                            .certificateNameController
                                            .text
                                            .isNotEmpty) {
                                          editProfileController
                                              .certificateNameController
                                              .clear();
                                          editProfileController
                                              .certificateDescriptionController
                                              .clear();
                                        }
                                      });
                                    },
                                    buttonText: LanguageConstant.add.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle9,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                              ),
                            ],
                          ),
                        )
                            : const SizedBox(),
                        isVisibleEducationForm == true
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldWidget(
                              hintText: LanguageConstant.certificateName.tr,
                              controller: editProfileController
                                  .certificateNameController,
                              onChanged: (String? value) {
                                editProfileController
                                    .certificateNameController.text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant
                                      .certificateNameFieldRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            Material(
                              elevation: 6.0,
                              borderRadius: BorderRadius.circular(30),
                              shadowColor: Colors.grey.withOpacity(0.4),
                              child: TextField(
                                style: AppTextStyles.hintTextStyle1,
                                maxLines: 4,
                                controller: editProfileController
                                    .certificateDescriptionController,
                                onChanged: (String? value) {
                                  editProfileController
                                      .certificateDescriptionController
                                      .text ==
                                      value;
                                  editProfileController.update();
                                },
                                decoration: InputDecoration(
                                  hintText: LanguageConstant.description.tr,
                                  hintStyle: AppTextStyles.hintTextStyle1,
                                  labelStyle: AppTextStyles.hintTextStyle1,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20, 12, 20, 12),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 24.h, 0, 12.h),
                              margin: EdgeInsets.fromLTRB(0, 20.h, 0, 24.h),
                              decoration: BoxDecoration(
                                color:
                                AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageConstant.uploadYourDocument.tr,
                                    style: AppTextStyles.bodyTextStyle2,
                                  ),
                                  SizedBox(width: 10.w),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        80.w, 16.h, 80.w, 12.h),
                                    child: ButtonWidgetOne(
                                        onTap: () {
                                          filePick();
                                        },
                                        buttonText:
                                        LanguageConstant.chooseFile.tr,
                                        buttonTextStyle:
                                        AppTextStyles.buttonTextStyle9,
                                        borderRadius: 40,
                                        buttonColor: AppColors.gradientOne),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                              decoration: BoxDecoration(
                                color:
                                AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 0, 24, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/File_dock.png",
                                              height: 24.h,
                                            ),
                                            SizedBox(width: 10.w),
                                            file == null
                                                ? Text(
                                              LanguageConstant
                                                  .certificateFileNameHere
                                                  .tr,
                                              style: AppTextStyles
                                                  .hintTextStyle1,
                                            )
                                                : Text(
                                              file!.path
                                                  .toString()
                                                  .split("/")
                                                  .last
                                                  .toString(),
                                              style: AppTextStyles
                                                  .hintTextStyle1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10.w),
                                        file == null
                                            ? const SizedBox()
                                            : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              file = null;
                                            });
                                          },
                                          child: Image.asset(
                                            "assets/icons/Subtract.png",
                                            color:
                                            AppColors.primaryColor,
                                            height: 20.h,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetOne(
                                    onTap: () {
                                      setState(() {
                                        isVisibleEducationForm = false;
                                      });
                                    },
                                    buttonText: LanguageConstant.back.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                                SizedBox(width: 10.w),
                                ButtonWidgetOne(
                                    onTap: () async {
                                      FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      if (_userProfileUpdateFormKey
                                          .currentState!
                                          .validate()) {
                                        addUserProfileCertificateDataRepo(
                                            editProfileController
                                                .certificateNameController
                                                .text,
                                            editProfileController
                                                .certificateDescriptionController
                                                .text,
                                            file,
                                            1);
                                      } else {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return CustomDialogBox(
                                                title:
                                                LanguageConstant.sorry.tr,
                                                titleColor: AppColors
                                                    .customDialogErrorColor,
                                                descriptions:
                                                'Inside Screen Popup',
                                                text: LanguageConstant.ok.tr,
                                                functionCall: () {
                                                  Navigator.pop(context);
                                                },
                                                img:
                                                'assets/icons/dialog_error.png',
                                              );
                                            });
                                      }
                                    },
                                    buttonText: LanguageConstant.submit.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                              ],
                            ),
                          ],
                        )
                            : editProfileController
                            .teacherProfileCertificateForPagination
                            .isNotEmpty
                            ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: editProfileController
                              .teacherProfileCertificateForPagination
                              .length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 14.h),
                              padding: EdgeInsets.fromLTRB(
                                  12.w, 8.h, 12.w, 8.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColors.primaryColor
                                      .withOpacity(0.15)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      editProfileController
                                          .teacherProfileCertificateForPagination[
                                      index]
                                          .name!,
                                      style:
                                      AppTextStyles.bodyTextStyle20),
                                  Row(
                                    children: [
                                      ButtonWidgetSeven(
                                        onTap: () {},
                                        buttonIconColor:
                                        AppColors.primaryColor,
                                        buttonIcon: Icons.download,
                                        iconSize: 22.h,
                                      ),
                                      SizedBox(width: 22.w),
                                      ButtonWidgetSeven(
                                          onTap: () {
                                            setState(() {
                                              isVisibleEducationForm =
                                              true;
                                              editProfileController
                                                  .certificateNameController
                                                  .text =
                                              editProfileController
                                                  .teacherProfileCertificateForPagination[
                                              index]
                                                  .name!;
                                              editProfileController
                                                  .certificateDescriptionController
                                                  .text =
                                              editProfileController
                                                  .teacherProfileCertificateForPagination[
                                              index]
                                                  .description!;
                                            });
                                          },
                                          buttonIconColor:
                                          AppColors.primaryColor,
                                          buttonIcon: Icons.edit,
                                          iconSize: 22.h),
                                      SizedBox(width: 22.w),
                                      ButtonWidgetSeven(
                                          onTap: () {
                                            deleteMethod(
                                                context,
                                                "$addEditUserProfileCertificateURL/${editProfileController.teacherProfileCertificateForPagination[index].id!}",
                                                null,
                                                true,
                                                deleteUserProfileCertificateDataRepo);
                                          },
                                          buttonIconColor:
                                          AppColors.carrotRed,
                                          buttonIcon: Icons.delete,
                                          iconSize: 22.h)
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            : Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80.h),
                            child: Text(
                              LanguageConstant.noDataFound.tr,
                              style: AppTextStyles.bodyTextStyle2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EXPERIENCE
// ─────────────────────────────────────────────────────────────────────────────

class TeacherExperienceWidget extends StatefulWidget {
  TeacherExperienceWidget({super.key});

  @override
  State<TeacherExperienceWidget> createState() =>
      _TeacherExperienceWidgetState();
}

class _TeacherExperienceWidgetState extends State<TeacherExperienceWidget> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();
  bool isVisibleEducationForm = false;
  File? file;

  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => file = File(result.files.single.path!));
    }
  }

  @override
  void initState() {
    super.initState();
    getMethod(context, getUserProfileExperiencesURL, null, true,
        getTeacherExperienceRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: AppBarWidget(
                  leadingIcon: 'assets/icons/Expand_left.png',
                  leadingIconColor: AppColors.white,
                  leadingOnTap: () {
                    Get.back();
                  },
                  titleText: LanguageConstant.experience.tr,
                  appBarTextStyle: AppTextStyles.appbarTextStyle2,
                  appBarColor: AppColors.primaryColor,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Form(
                    key: _userProfileUpdateFormKey,
                    child: Column(
                      children: [
                        isVisibleEducationForm == false
                            ? Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.addNewTeacherExperience.tr,
                                style: AppTextStyles.headingTextStyle1,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: ButtonWidgetOne(
                                    onTap: () {
                                      setState(() {
                                        isVisibleEducationForm = true;
                                        if (editProfileController
                                            .experienceCompanyNameController
                                            .text
                                            .isNotEmpty) {
                                          editProfileController
                                              .experienceCompanyNameController
                                              .clear();
                                          editProfileController
                                              .experienceDescriptionController
                                              .clear();
                                        }
                                      });
                                    },
                                    buttonText: LanguageConstant.add.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle9,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                              ),
                            ],
                          ),
                        )
                            : const SizedBox(),
                        isVisibleEducationForm == true
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldWidget(
                              hintText: LanguageConstant.companyName.tr,
                              controller: editProfileController
                                  .experienceCompanyNameController,
                              onChanged: (String? value) {
                                editProfileController
                                    .experienceCompanyNameController
                                    .text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant
                                      .companyNameFieldRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            Material(
                              elevation: 6.0,
                              borderRadius: BorderRadius.circular(30),
                              shadowColor: Colors.grey.withOpacity(0.4),
                              child: TextField(
                                style: AppTextStyles.hintTextStyle1,
                                maxLines: 4,
                                controller: editProfileController
                                    .experienceDescriptionController,
                                onChanged: (String? value) {
                                  editProfileController
                                      .experienceDescriptionController
                                      .text ==
                                      value;
                                  editProfileController.update();
                                },
                                decoration: InputDecoration(
                                  hintText: LanguageConstant.description.tr,
                                  hintStyle: AppTextStyles.hintTextStyle1,
                                  labelStyle: AppTextStyles.hintTextStyle1,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20, 12, 20, 12),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(children: [
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.startDate.tr,
                                  controller: editProfileController
                                      .experienceStartDateController,
                                  onChanged: (String? value) {
                                    editProfileController
                                        .experienceStartDateController
                                        .text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .startDateFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextFormFieldWidget(
                                  hintText: LanguageConstant.endDate.tr,
                                  controller: editProfileController
                                      .experienceEndDateController,
                                  onChanged: (String? value) {
                                    editProfileController
                                        .experienceEndDateController
                                        .text ==
                                        value;
                                    editProfileController.update();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LanguageConstant
                                          .endDateFieldRequired.tr;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ]),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 24.h, 0, 12.h),
                              margin: EdgeInsets.fromLTRB(0, 20.h, 0, 24.h),
                              decoration: BoxDecoration(
                                color:
                                AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageConstant.uploadYourDocument.tr,
                                    style: AppTextStyles.bodyTextStyle2,
                                  ),
                                  SizedBox(width: 10.w),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        80.w, 16.h, 80.w, 12.h),
                                    child: ButtonWidgetOne(
                                        onTap: () {
                                          filePick();
                                        },
                                        buttonText:
                                        LanguageConstant.chooseFile.tr,
                                        buttonTextStyle:
                                        AppTextStyles.buttonTextStyle9,
                                        borderRadius: 40,
                                        buttonColor: AppColors.gradientOne),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                              decoration: BoxDecoration(
                                color:
                                AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        24.w, 0, 24.w, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/File_dock.png",
                                              height: 24.h,
                                            ),
                                            SizedBox(width: 10.w),
                                            file == null
                                                ? Text(
                                              LanguageConstant
                                                  .experienceFileNameHere
                                                  .tr,
                                              style: AppTextStyles
                                                  .hintTextStyle1,
                                            )
                                                : Text(
                                              file!.path
                                                  .toString()
                                                  .split("/")
                                                  .last
                                                  .toString(),
                                              style: AppTextStyles
                                                  .hintTextStyle1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10.w),
                                        file == null
                                            ? const SizedBox()
                                            : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              file = null;
                                            });
                                          },
                                          child: Image.asset(
                                            "assets/icons/Subtract.png",
                                            color:
                                            AppColors.primaryColor,
                                            height: 20.h,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetOne(
                                    onTap: () {
                                      setState(() {
                                        isVisibleEducationForm = false;
                                      });
                                    },
                                    buttonText: LanguageConstant.back.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                                SizedBox(width: 10.w),
                                ButtonWidgetOne(
                                    onTap: () async {
                                      FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      if (_userProfileUpdateFormKey
                                          .currentState!
                                          .validate()) {
                                        addUserProfileExperienceDataRepo(
                                            editProfileController
                                                .experienceCompanyNameController
                                                .text,
                                            editProfileController
                                                .experienceDescriptionController
                                                .text,
                                            editProfileController
                                                .experienceStartDateController
                                                .text,
                                            editProfileController
                                                .experienceEndDateController
                                                .text,
                                            file,
                                            1);
                                      } else {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return CustomDialogBox(
                                                title:
                                                LanguageConstant.sorry.tr,
                                                titleColor: AppColors
                                                    .customDialogErrorColor,
                                                descriptions:
                                                'Inside Screen Popup',
                                                text: LanguageConstant.ok.tr,
                                                functionCall: () {
                                                  Navigator.pop(context);
                                                },
                                                img:
                                                'assets/icons/dialog_error.png',
                                              );
                                            });
                                      }
                                    },
                                    buttonText: LanguageConstant.submit.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                              ],
                            ),
                          ],
                        )
                            : editProfileController
                            .teacherProfileExperienceForPagination
                            .isNotEmpty
                            ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: editProfileController
                              .teacherProfileExperienceForPagination
                              .length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 14.h),
                              padding: EdgeInsets.fromLTRB(
                                  12.w, 8.h, 12.w, 8.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColors.primaryColor
                                      .withOpacity(0.15)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      editProfileController
                                          .teacherProfileExperienceForPagination[
                                      index]
                                          .company!,
                                      style:
                                      AppTextStyles.bodyTextStyle20),
                                  Row(
                                    children: [
                                      ButtonWidgetSeven(
                                        onTap: () {},
                                        buttonIconColor:
                                        AppColors.primaryColor,
                                        buttonIcon: Icons.download,
                                        iconSize: 22.h,
                                      ),
                                      SizedBox(width: 22.w),
                                      ButtonWidgetSeven(
                                          onTap: () {
                                            setState(() {
                                              isVisibleEducationForm =
                                              true;
                                              editProfileController
                                                  .experienceCompanyNameController
                                                  .text =
                                              editProfileController
                                                  .teacherProfileExperienceForPagination[
                                              index]
                                                  .company!;
                                              editProfileController
                                                  .experienceDescriptionController
                                                  .text =
                                              editProfileController
                                                  .teacherProfileExperienceForPagination[
                                              index]
                                                  .description!;
                                              editProfileController
                                                  .experienceStartDateController
                                                  .text =
                                              editProfileController
                                                  .teacherProfileExperienceForPagination[
                                              index]
                                                  .from!;
                                              editProfileController
                                                  .experienceEndDateController
                                                  .text =
                                              editProfileController
                                                  .teacherProfileExperienceForPagination[
                                              index]
                                                  .to!;
                                            });
                                          },
                                          buttonIconColor:
                                          AppColors.primaryColor,
                                          buttonIcon: Icons.edit,
                                          iconSize: 22.h),
                                      SizedBox(width: 22.w),
                                      ButtonWidgetSeven(
                                          onTap: () {
                                            deleteMethod(
                                                context,
                                                "$addEditUserProfileExperienceURL/${editProfileController.teacherProfileExperienceForPagination[index].id!}",
                                                null,
                                                true,
                                                deleteUserProfileExperienceDataRepo);
                                          },
                                          buttonIconColor:
                                          AppColors.carrotRed,
                                          buttonIcon: Icons.delete,
                                          iconSize: 22.h)
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            : Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80.h),
                            child: Text(
                              LanguageConstant.noDataFound.tr,
                              style: AppTextStyles.bodyTextStyle2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PODCASTS / MEDIA
// ─────────────────────────────────────────────────────────────────────────────

class TeacherPodcastsWidget extends StatefulWidget {
  TeacherPodcastsWidget({super.key});

  @override
  State<TeacherPodcastsWidget> createState() => _TeacherPodcastsWidgetState();
}

class _TeacherPodcastsWidgetState extends State<TeacherPodcastsWidget> {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();
  bool isVisiblePodcastForm = false;
  File? file;
  File? audioFile;
  File? videoFile;
  dynamic selectedFileType;
  dynamic selectedLinkType;

  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => file = File(result.files.single.path!));
    }
  }

  audioFilePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => audioFile = File(result.files.single.path!));
    }
  }

  videoFilePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => videoFile = File(result.files.single.path!));
    }
  }

  @override
  void initState() {
    super.initState();
    getMethod(
        context, getUserProfilePodcastsURL, null, true, getTeacherPodcastsRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: AppBarWidget(
                  leadingIcon: 'assets/icons/Expand_left.png',
                  leadingOnTap: () {
                    Get.back();
                  },
                  titleText: "Media".tr,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Form(
                    key: _userProfileUpdateFormKey,
                    child: Column(
                      children: [
                        isVisiblePodcastForm == false
                            ? Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.addNewTeacherPodcast.tr,
                                style: AppTextStyles.headingTextStyle1,
                              ),
                              SizedBox(
                                width: 70.w,
                                child: ButtonWidgetOne(
                                    onTap: () {
                                      setState(() {
                                        isVisiblePodcastForm = true;
                                        if (editProfileController
                                            .podcastNameController
                                            .text
                                            .isNotEmpty) {
                                          editProfileController
                                              .podcastNameController
                                              .clear();
                                          editProfileController
                                              .podcastDescriptionController
                                              .clear();
                                        }
                                      });
                                    },
                                    buttonText: LanguageConstant.add.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle9,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                              ),
                            ],
                          ),
                        )
                            : const SizedBox(),
                        isVisiblePodcastForm == true
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormFieldWidget(
                              hintText: LanguageConstant.name.tr,
                              controller:
                              editProfileController.podcastNameController,
                              onChanged: (String? value) {
                                editProfileController
                                    .podcastNameController.text ==
                                    value;
                                editProfileController.update();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return LanguageConstant
                                      .nameFieldRequired.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.h),
                            Material(
                              elevation: 6.0,
                              borderRadius: BorderRadius.circular(30),
                              shadowColor: Colors.grey.withOpacity(0.4),
                              child: TextField(
                                style: AppTextStyles.hintTextStyle1,
                                maxLines: 4,
                                controller: editProfileController
                                    .podcastDescriptionController,
                                onChanged: (String? value) {
                                  editProfileController
                                      .podcastDescriptionController
                                      .text ==
                                      value;
                                  editProfileController.update();
                                },
                                decoration: InputDecoration(
                                  hintText: LanguageConstant.description.tr,
                                  hintStyle: AppTextStyles.hintTextStyle1,
                                  labelStyle: AppTextStyles.hintTextStyle1,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20, 12, 20, 12),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: AppColors.transparent),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(children: [
                              Expanded(
                                child: Material(
                                  elevation: 6.0,
                                  borderRadius: BorderRadius.circular(30),
                                  shadowColor: Colors.grey.withOpacity(0.4),
                                  child: DropdownButtonFormField(
                                    borderRadius: BorderRadius.circular(30),
                                    hint: Text(
                                      LanguageConstant.selectFileType.tr,
                                      style: AppTextStyles.hintTextStyle1,
                                    ),
                                    items: <String>[
                                      LanguageConstant.audio.tr,
                                      LanguageConstant.video.tr,
                                    ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: DropdownMenuItem(
                                              child: Row(
                                                children: [
                                                  Text(value,
                                                      style: AppTextStyles
                                                          .bodyTextStyle11),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedFileType = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                      const EdgeInsets.fromLTRB(
                                          16, 6, 16, 6),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: AppColors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: AppColors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.primaryColor,
                                    ),
                                    iconEnabledColor: Colors.white,
                                    style: AppTextStyles.subHeadingTextStyle1,
                                    dropdownColor: AppColors.white,
                                    isExpanded: true,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: Material(
                                  elevation: 6.0,
                                  borderRadius: BorderRadius.circular(30),
                                  shadowColor: Colors.grey.withOpacity(0.4),
                                  child: DropdownButtonFormField(
                                    borderRadius: BorderRadius.circular(30),
                                    hint: Text(
                                      LanguageConstant.selectLinkType.tr,
                                      style: AppTextStyles.hintTextStyle1,
                                    ),
                                    items: <String>[
                                      LanguageConstant.internal.tr,
                                      LanguageConstant.external.tr,
                                    ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: DropdownMenuItem(
                                              child: Row(
                                                children: [
                                                  Text(value,
                                                      style: AppTextStyles
                                                          .bodyTextStyle11),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedLinkType = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                      const EdgeInsets.fromLTRB(
                                          16, 6, 16, 6),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: AppColors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: AppColors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: AppColors.primaryColor,
                                    ),
                                    iconEnabledColor: Colors.white,
                                    style: AppTextStyles.subHeadingTextStyle1,
                                    dropdownColor: AppColors.white,
                                    isExpanded: true,
                                  ),
                                ),
                              ),
                            ]),
                            selectedLinkType == "external"
                                ? Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: TextFormFieldWidget(
                                hintText: LanguageConstant.fileURL.tr,
                                controller: editProfileController
                                    .podcastFileURLController,
                                onChanged: (String? value) {
                                  editProfileController
                                      .podcastFileURLController
                                      .text ==
                                      value;
                                  editProfileController.update();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return LanguageConstant
                                        .fileURLFieldRequired.tr;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            )
                                : selectedLinkType == "internal" &&
                                selectedFileType != null
                                ? Container(
                              padding: EdgeInsets.fromLTRB(
                                  0, 24.h, 0, 12.h),
                              margin: EdgeInsets.fromLTRB(
                                  0, 20.h, 0, 0.h),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor
                                    .withOpacity(0.15),
                                borderRadius:
                                BorderRadius.circular(30),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedFileType == "audio"
                                        ? LanguageConstant
                                        .uploadYourAudioFile.tr
                                        : LanguageConstant
                                        .uploadYourVideoFile.tr,
                                    style:
                                    AppTextStyles.bodyTextStyle2,
                                  ),
                                  SizedBox(width: 10.w),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        80.w, 16.h, 80.w, 12.h),
                                    child: ButtonWidgetOne(
                                        onTap: () {
                                          selectedFileType == "audio"
                                              ? audioFilePick()
                                              : videoFilePick();
                                        },
                                        buttonText: selectedFileType ==
                                            "audio"
                                            ? LanguageConstant
                                            .chooseAudioFile.tr
                                            : LanguageConstant
                                            .chooseVideoFile.tr,
                                        buttonTextStyle: AppTextStyles
                                            .buttonTextStyle9,
                                        borderRadius: 40,
                                        buttonColor:
                                        AppColors.gradientOne),
                                  ),
                                ],
                              ),
                            )
                                : Container(),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 24.h, 0, 12.h),
                              margin: EdgeInsets.fromLTRB(0, 20.h, 0, 24.h),
                              decoration: BoxDecoration(
                                color:
                                AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LanguageConstant.uploadYourDocument.tr,
                                    style: AppTextStyles.bodyTextStyle2,
                                  ),
                                  SizedBox(width: 10.w),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        80.w, 16.h, 80.w, 12.h),
                                    child: ButtonWidgetOne(
                                        onTap: () {
                                          filePick();
                                        },
                                        buttonText:
                                        LanguageConstant.chooseFile.tr,
                                        buttonTextStyle:
                                        AppTextStyles.buttonTextStyle9,
                                        borderRadius: 40,
                                        buttonColor: AppColors.gradientOne),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 12.h, 0, 12.h),
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 24.h),
                              decoration: BoxDecoration(
                                color:
                                AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding:
                                EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/File_dock.png",
                                          height: 24.h,
                                        ),
                                        SizedBox(width: 10.w),
                                        file == null
                                            ? Text(
                                          LanguageConstant
                                              .podcastFileNameHere.tr,
                                          style: AppTextStyles
                                              .hintTextStyle1,
                                        )
                                            : Text(
                                          file!.path
                                              .toString()
                                              .split("/")
                                              .last
                                              .toString(),
                                          style: AppTextStyles
                                              .hintTextStyle1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10.w),
                                    file == null
                                        ? const SizedBox()
                                        : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          file = null;
                                        });
                                      },
                                      child: Image.asset(
                                        "assets/icons/Subtract.png",
                                        color: AppColors.primaryColor,
                                        height: 20.h,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonWidgetOne(
                                    onTap: () {
                                      setState(() {
                                        isVisiblePodcastForm = false;
                                      });
                                    },
                                    buttonText: LanguageConstant.back.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                                SizedBox(width: 10.w),
                                ButtonWidgetOne(
                                    onTap: () async {
                                      FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      if (_userProfileUpdateFormKey
                                          .currentState!
                                          .validate()) {
                                        addUserProfilePodcastDataRepo(
                                            editProfileController
                                                .podcastNameController.text,
                                            editProfileController
                                                .podcastDescriptionController
                                                .text,
                                            selectedFileType,
                                            selectedLinkType,
                                            null,
                                            editProfileController
                                                .selectedMediaTagIds,
                                            editProfileController
                                                .podcastFileURLController
                                                .text,
                                            file,
                                            audioFile,
                                            videoFile,
                                            1);
                                      } else {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return CustomDialogBox(
                                                title:
                                                LanguageConstant.sorry.tr,
                                                titleColor: AppColors
                                                    .customDialogErrorColor,
                                                descriptions:
                                                'Inside Screen Popup',
                                                text: LanguageConstant.ok.tr,
                                                functionCall: () {
                                                  Navigator.pop(context);
                                                },
                                                img:
                                                'assets/icons/dialog_error.png',
                                              );
                                            });
                                      }
                                    },
                                    buttonText: LanguageConstant.submit.tr,
                                    buttonTextStyle:
                                    AppTextStyles.buttonTextStyle1,
                                    borderRadius: 40,
                                    buttonColor: AppColors.gradientOne),
                              ],
                            ),
                          ],
                        )
                            : editProfileController
                            .teacherProfilePodcastForPagination.isNotEmpty
                            ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: editProfileController
                              .teacherProfilePodcastForPagination.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 14.h),
                              padding: EdgeInsets.fromLTRB(
                                  12.w, 8.h, 12.w, 8.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColors.primaryColor
                                      .withOpacity(0.15)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        editProfileController
                                            .teacherProfilePodcastForPagination[
                                        index]
                                            .name!,
                                        style: AppTextStyles
                                            .bodyTextStyle20),
                                  ),
                                  SizedBox(width: 16.w),
                                  Row(
                                    children: [
                                      ButtonWidgetSeven(
                                        onTap: () {},
                                        buttonIconColor:
                                        AppColors.primaryColor,
                                        buttonIcon: Icons.download,
                                        iconSize: 22.h,
                                      ),
                                      SizedBox(width: 22.w),
                                      ButtonWidgetSeven(
                                          onTap: () {
                                            setState(() {
                                              isVisiblePodcastForm = true;
                                              editProfileController
                                                  .podcastNameController
                                                  .text =
                                              editProfileController
                                                  .teacherProfilePodcastForPagination[
                                              index]
                                                  .name!;
                                              editProfileController
                                                  .podcastDescriptionController
                                                  .text =
                                              editProfileController
                                                  .teacherProfilePodcastForPagination[
                                              index]
                                                  .description!;
                                              selectedFileType =
                                              editProfileController
                                                  .teacherProfilePodcastForPagination[
                                              index]
                                                  .fileType!;
                                              selectedLinkType =
                                              editProfileController
                                                  .teacherProfilePodcastForPagination[
                                              index]
                                                  .linkType!;
                                              editProfileController
                                                  .podcastFileURLController
                                                  .text =
                                              editProfileController
                                                  .teacherProfilePodcastForPagination[
                                              index]
                                                  .fileUrl!;
                                            });
                                          },
                                          buttonIconColor:
                                          AppColors.primaryColor,
                                          buttonIcon: Icons.edit,
                                          iconSize: 22.h),
                                      SizedBox(width: 22.w),
                                      ButtonWidgetSeven(
                                          onTap: () {
                                            deleteMethod(
                                                context,
                                                "$addEditUserProfilePodcastURL/${editProfileController.teacherProfilePodcastForPagination[index].id!}",
                                                null,
                                                true,
                                                deleteUserProfilePodcastDataRepo);
                                          },
                                          buttonIconColor:
                                          AppColors.carrotRed,
                                          buttonIcon: Icons.delete,
                                          iconSize: 22.h)
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            : Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 80.h),
                            child: Text(
                              LanguageConstant.noDataFound.tr,
                              style: AppTextStyles.bodyTextStyle2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE COMPLETION BAR
// ─────────────────────────────────────────────────────────────────────────────

class ProfileCompletionBarWidget extends StatelessWidget {
  const ProfileCompletionBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.primaryColor)),
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width - 140,
        barRadius: const Radius.circular(30),
        padding: EdgeInsets.zero,
        animation: true,
        lineHeight: 16.0,
        backgroundColor: AppColors.white,
        animationDuration: 2500,
        percent: Get.find<EditProfileController>()
            .teacherProfileEducationForPagination
            .isNotEmpty
            ? 0.4
            : Get.find<EditProfileController>()
            .teacherProfileCertificateForPagination
            .isNotEmpty
            ? 0.6
            : Get.find<EditProfileController>()
            .teacherProfileExperienceForPagination
            .isNotEmpty
            ? 0.8
            : Get.find<EditProfileController>()
            .teacherProfilePodcastForPagination
            .isNotEmpty
            ? 1
            : 0.2,
        center: Text(
          Get.find<EditProfileController>()
              .teacherProfileEducationForPagination
              .isNotEmpty
              ? "40.0%"
              : Get.find<EditProfileController>()
              .teacherProfileCertificateForPagination
              .isNotEmpty
              ? "60.0%"
              : Get.find<EditProfileController>()
              .teacherProfileExperienceForPagination
              .isNotEmpty
              ? "80.0%"
              : Get.find<EditProfileController>()
              .teacherProfilePodcastForPagination
              .isNotEmpty
              ? "100.0%"
              : "20.0%",
          style: AppTextStyles.bodyTextStyle15,
        ),
        progressColor: AppColors.primaryColor,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SOCIAL INFO
// ─────────────────────────────────────────────────────────────────────────────

class TeacherSocialInfoWidget extends StatefulWidget {
  const TeacherSocialInfoWidget({super.key});

  @override
  State<TeacherSocialInfoWidget> createState() =>
      _TeacherSocialInfoWidgetState();
}

class _TeacherSocialInfoWidgetState extends State<TeacherSocialInfoWidget> {
  final Map<String, TextEditingController> _controllers = {
    'facebook_url': TextEditingController(),
    'twitter_url': TextEditingController(),
    'youtube_url': TextEditingController(),
    'tiktok_url': TextEditingController(),
    'linkedin_url': TextEditingController(),
    'whatsapp_url': TextEditingController(),
    'snapchat_url': TextEditingController(),
    'instagram_url': TextEditingController(),
    'pinterest_url': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _loadSocialInfo();
  }

  void _loadSocialInfo() {
    getMethod(context, getSocialInfoURL, null, true, (ctx, success, data) {
      if (success && data['data'] != null) {
        final Map<String, dynamic> settings = data['data'];
        setState(() {
          settings.forEach((key, val) {
            if (_controllers.containsKey(key)) {
              _controllers[key]!.text = val['value'] ?? '';
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          children: [
            _buildSocialRow(Icons.facebook, 'facebook_url', "Facebook Url"),
            const SizedBox(height: 14),
            _buildSocialRow(Icons.close, 'twitter_url', "Twitter/X Url"),
            const SizedBox(height: 14),
            _buildSocialRow(
                Icons.play_circle_fill, 'youtube_url', "Youtube Url"),
            const SizedBox(height: 14),
            _buildSocialRow(Icons.music_note, 'tiktok_url', "TikTok Url"),
            const SizedBox(height: 14),
            _buildSocialRow(Icons.work, 'linkedin_url', "LinkedIn Url"),
            const SizedBox(height: 14),
            _buildSocialRow(Icons.message, 'whatsapp_url', "Whatsapp Url"),
            const SizedBox(height: 14),
            _buildSocialRow(Icons.camera_alt, 'snapchat_url', "Snapchat Url"),
            const SizedBox(height: 14),
            _buildSocialRow(Icons.camera, 'instagram_url', "Instagram Url"),
            const SizedBox(height: 14),
            _buildSocialRow(Icons.push_pin, 'pinterest_url', "Pinterest Url"),
            const SizedBox(height: 30),
            ButtonWidgetOne(
              onTap: _saveSocialInfo,
              buttonText: "Save Changes",
              buttonTextStyle: AppTextStyles.buttonTextStyle1,
              borderRadius: 40,
              buttonColor: AppColors.gradientOne,
            ),
          ],
        ),
      ),
    );
  }

  void _saveSocialInfo() {
    final Map<String, String> payload = {};
    _controllers.forEach((key, controller) {
      payload[key] = controller.text.trim();
    });
    Get.find<GeneralController>().updateFormLoaderController(true);
    postMethod(
      context,
      updateSocialInfoURL,
      payload,
      true,
          (ctx, success, data) {
        Get.find<GeneralController>().updateFormLoaderController(false);
        if (success) {
          Get.snackbar('Success', 'Social Info Updated Successfully',
              backgroundColor: AppColors.primaryColor,
              colorText: AppColors.white);
        }
      },
    );
  }

  Widget _buildSocialRow(IconData icon, String fieldKey, String hint) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withOpacity(0.2),
          ),
          child: Icon(icon, color: AppColors.primaryColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormFieldWidget(
            hintText: hint,
            controller: _controllers[fieldKey],
            onChanged: (val) {},
            validator: (val) => null,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BLOGS
// ─────────────────────────────────────────────────────────────────────────────

class TeacherBlogsWidget extends StatefulWidget {
  const TeacherBlogsWidget({super.key});

  @override
  State<TeacherBlogsWidget> createState() => _TeacherBlogsWidgetState();
}

class _TeacherBlogsWidgetState extends State<TeacherBlogsWidget> {
  bool isVisibleBlogForm = false;
  bool isActive = true;
  File? file;

  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => file = File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorTwo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBarWidget(
          leadingIcon: 'assets/icons/Expand_left.png',
          leadingOnTap: () => Get.back(),
          titleText: "Blogs".tr,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              !isVisibleBlogForm ? _buildList() : _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("All Post", style: AppTextStyles.headingTextStyle1),
            SizedBox(
              width: 100,
              child: ButtonWidgetOne(
                onTap: () => setState(() => isVisibleBlogForm = true),
                buttonText: "Add New",
                buttonTextStyle: AppTextStyles.buttonTextStyle9,
                borderRadius: 40,
                buttonColor: AppColors.gradientOne,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("No items found.")
      ],
    );
  }

  Widget _buildForm() {
    return GetBuilder<EditProfileController>(builder: (editProfileController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Create post", style: AppTextStyles.headingTextStyle1),
          const SizedBox(height: 20),
          TextFormFieldWidget(
            hintText: "Name (en)",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.podcastNameController,
          ),
          const SizedBox(height: 14),
          TextFormFieldWidget(
            hintText: "Description (en)",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.podcastDescriptionController,
          ),
          const SizedBox(height: 14),
          CategoryDropDownWidget(
            title: "Choose Blog Category",
            categories: editProfileController.blogCategories,
            selectedId: editProfileController.selectedBlogCategoryId,
            onChanged: (id) {
              editProfileController.selectedBlogCategoryId = id;
              editProfileController.update();
            },
          ),
          const SizedBox(height: 14),
          MultiSelectTagsWidget(
            onChanged: (selectedIds) {
              editProfileController.selectedBlogTagIds = selectedIds;
              editProfileController.update();
            },
            selectedIds: editProfileController.selectedBlogTagIds,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                SizedBox(
                    width: 120,
                    child: ButtonWidgetOne(
                        onTap: () => filePick(),
                        buttonText: "Select a File",
                        buttonTextStyle: AppTextStyles.buttonTextStyle9,
                        borderRadius: 40,
                        buttonColor: const LinearGradient(
                            colors: [Color(0xff4b4c4d), Color(0xff4b4c4d)]))),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    file == null
                        ? "File Must Be Of Type doc, docx, pdf, xls, png, jpeg"
                        : file!.path.toString().split("/").last.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Row(children: [
          //   Switch(
          //       value: isActive,
          //       onChanged: (v) {
          //         setState(() {
          //           isActive = v;
          //         });
          //       }),
          //   const Text("Active?")
          // ]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: 100,
                  child: ButtonWidgetOne(
                      onTap: () => setState(() => isVisibleBlogForm = false),
                      buttonText: "Cancel",
                      buttonTextStyle: AppTextStyles.buttonTextStyle1,
                      borderRadius: 40,
                      buttonColor: const LinearGradient(
                          colors: [Color(0xff2d2e2f), Color(0xff2d2e2f)]))),
              const SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  child: ButtonWidgetOne(
                      onTap: () {
                        addUserProfileBlogDataRepo(
                          editProfileController.podcastNameController.text,
                          editProfileController
                              .podcastDescriptionController.text,
                          editProfileController.selectedBlogCategoryId
                              .toString(),
                          editProfileController.selectedBlogTagIds,
                          file,
                        );
                        setState(() => isVisibleBlogForm = false);
                      },
                      buttonText: "Create",
                      buttonTextStyle: AppTextStyles.buttonTextStyle1,
                      borderRadius: 40,
                      buttonColor: AppColors.gradientOne)),
            ],
          )
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CALENDLY
// ─────────────────────────────────────────────────────────────────────────────

class TeacherCalendlyWidget extends StatefulWidget {
  const TeacherCalendlyWidget({super.key});

  @override
  State<TeacherCalendlyWidget> createState() => _TeacherCalendlyWidgetState();
}

class _TeacherCalendlyWidgetState extends State<TeacherCalendlyWidget> {
  final TextEditingController _calendlyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCalendly();
  }

  void _loadCalendly() {
    getMethod(context, getCalendlyURL, null, true, (ctx, success, data) {
      if (success && data['data'] != null) {
        setState(() {
          _calendlyController.text = data['data']['value'] ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _calendlyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorTwo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBarWidget(
          leadingIcon: 'assets/icons/Expand_left.png',
          leadingOnTap: () => Get.back(),
          titleText: "Calendly",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Calendly Link", style: AppTextStyles.headingTextStyle1),
              const SizedBox(height: 20),
              TextFormFieldWidget(
                hintText: "Enter Calendly Link",
                controller: _calendlyController,
                onChanged: (v) {},
                validator: (v) => null,
              ),
              const SizedBox(height: 20),
              ButtonWidgetOne(
                onTap: _saveCalendly,
                buttonText: "Save",
                buttonTextStyle: AppTextStyles.buttonTextStyle1,
                borderRadius: 40,
                buttonColor: AppColors.gradientOne,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCalendly() {
    if (_calendlyController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a Calendly link',
          backgroundColor: AppColors.carrotRed, colorText: AppColors.white);
      return;
    }
    Get.find<GeneralController>().updateFormLoaderController(true);
    postMethod(
      context,
      updateCalendlyURL,
      {"calendly_link": _calendlyController.text.trim()},
      true,
          (ctx, success, data) {
        Get.find<GeneralController>().updateFormLoaderController(false);
        if (success) {
          Get.snackbar('Success', 'Calendly Link Saved Successfully',
              backgroundColor: AppColors.primaryColor,
              colorText: AppColors.white);
        }
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EVENTS
// ─────────────────────────────────────────────────────────────────────────────

class TeacherEventsWidget extends StatefulWidget {
  const TeacherEventsWidget({super.key});

  @override
  State<TeacherEventsWidget> createState() => _TeacherEventsWidgetState();
}

class _TeacherEventsWidgetState extends State<TeacherEventsWidget> {
  bool isVisibleForm = false;
  bool isActive = true;
  File? file;

  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => file = File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorTwo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBarWidget(
          leadingIcon: 'assets/icons/Expand_left.png',
          leadingOnTap: () => Get.back(),
          titleText: LanguageConstant.events.tr,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              !isVisibleForm ? _buildList() : _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("All Events", style: AppTextStyles.headingTextStyle1),
            SizedBox(
              width: 100,
              child: ButtonWidgetOne(
                  onTap: () => setState(() => isVisibleForm = true),
                  buttonText: "Add New",
                  buttonTextStyle: AppTextStyles.buttonTextStyle9,
                  borderRadius: 40,
                  buttonColor: AppColors.gradientOne),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("No items found.")
      ],
    );
  }

  Widget _buildForm() {
    return GetBuilder<EditProfileController>(builder: (editProfileController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Create event", style: AppTextStyles.headingTextStyle1),
          const SizedBox(height: 20),
          TextFormFieldWidget(
            hintText: "Event Name (en)",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.podcastNameController,
          ),
          const SizedBox(height: 14),
          TextFormFieldWidget(
            hintText: "Description (en)",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.podcastDescriptionController,
          ),
          const SizedBox(height: 14),
          CategoryDropDownWidget(
            title: "Choose Event Category",
            categories: editProfileController.eventCategories,
            selectedId: editProfileController.selectedEventCategoryId,
            onChanged: (id) {
              editProfileController.selectedEventCategoryId = id;
              editProfileController.update();
            },
          ),
          const SizedBox(height: 14),
          MultiSelectTagsWidget(
            onChanged: (selectedIds) {
              editProfileController.selectedEventTagIds = selectedIds;
              editProfileController.update();
            },
            selectedIds: editProfileController.selectedEventTagIds,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                // FIX: Use GestureDetector + AbsorbPointer instead of
                // unsupported readOnly / onTap params on TextFormFieldWidget
                child: GestureDetector(
                  onTap: () => _selectDate(
                      context, editProfileController.eventDateController),
                  child: AbsorbPointer(
                    child: TextFormFieldWidget(
                      hintText: "Start Date",
                      controller: editProfileController.eventDateController,
                      onChanged: (v) {},
                      validator: (v) => null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context,
                      editProfileController.eventEndDateController),
                  child: AbsorbPointer(
                    child: TextFormFieldWidget(
                      hintText: "End Date",
                      onChanged: (v) {},
                      validator: (v) => null,
                      controller:
                      editProfileController.eventEndDateController,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextFormFieldWidget(
                  hintText: "Address line 1",
                  onChanged: (v) {},
                  validator: (v) => null,
                  controller: editProfileController
                      .userProfileAddressLine1Controller,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormFieldWidget(
                  hintText: "Address line 2",
                  onChanged: (v) {},
                  validator: (v) => null,
                  controller: editProfileController
                      .userProfileAddressLine2Controller,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text("Sponsors", style: AppTextStyles.headingTextStyle1),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                SizedBox(
                    width: 120,
                    child: ButtonWidgetOne(
                        onTap: () => filePick(),
                        buttonText: "Select a File",
                        buttonTextStyle: AppTextStyles.buttonTextStyle9,
                        borderRadius: 40,
                        buttonColor: const LinearGradient(
                            colors: [Color(0xff4b4c4d), Color(0xff4b4c4d)]))),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    file == null
                        ? "File Must Be Of Type doc, docx, pdf, xls, png, jpeg"
                        : file!.path.toString().split("/").last.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Row(children: [
          //   Switch(
          //       value: isActive,
          //       onChanged: (v) {
          //         setState(() {
          //           isActive = v;
          //         });
          //       }),
          //   const Text("Active?")
          // ]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: 100,
                  child: ButtonWidgetOne(
                      onTap: () => setState(() => isVisibleForm = false),
                      buttonText: "Cancel",
                      buttonTextStyle: AppTextStyles.buttonTextStyle1,
                      borderRadius: 40,
                      buttonColor: const LinearGradient(
                          colors: [Color(0xff2d2e2f), Color(0xff2d2e2f)]))),
              const SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  child: ButtonWidgetOne(
                      onTap: () {
                        addUserProfileEventDataRepo(
                          editProfileController.podcastNameController.text,
                          editProfileController
                              .podcastDescriptionController.text,
                          editProfileController.selectedEventCategoryId
                              .toString(),
                          editProfileController.selectedEventTagIds,
                          editProfileController.eventDateController.text,
                          editProfileController.eventEndDateController.text,
                          editProfileController
                              .userProfileAddressLine1Controller.text,
                          editProfileController
                              .userProfileAddressLine2Controller.text,
                          file,
                        );
                        setState(() => isVisibleForm = false);
                      },
                      buttonText: "Create",
                      buttonTextStyle: AppTextStyles.buttonTextStyle1,
                      borderRadius: 40,
                      buttonColor: AppColors.gradientOne)),
            ],
          )
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SERVICES
// ─────────────────────────────────────────────────────────────────────────────

class TeacherServicesWidget extends StatefulWidget {
  const TeacherServicesWidget({super.key});

  @override
  State<TeacherServicesWidget> createState() => _TeacherServicesWidgetState();
}

class _TeacherServicesWidgetState extends State<TeacherServicesWidget> {
  bool isVisibleForm = false;
  bool isActive = true;
  File? file;

  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => file = File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorTwo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBarWidget(
          leadingIcon: 'assets/icons/Expand_left.png',
          leadingOnTap: () => Get.back(),
          titleText: "Services".tr,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              !isVisibleForm ? _buildList() : _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("All service", style: AppTextStyles.headingTextStyle1),
            SizedBox(
              width: 100,
              child: ButtonWidgetOne(
                  onTap: () => setState(() => isVisibleForm = true),
                  buttonText: "Add New",
                  buttonTextStyle: AppTextStyles.buttonTextStyle9,
                  borderRadius: 40,
                  buttonColor: AppColors.gradientOne),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("No items found.")
      ],
    );
  }

  Widget _buildForm() {
    return GetBuilder<EditProfileController>(builder: (editProfileController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategoryDropDownWidget(
            title: "Choose Service Category",
            categories: editProfileController.serviceCategories,
            selectedId: editProfileController.selectedServiceCategoryId,
            onChanged: (id) {
              editProfileController.selectedServiceCategoryId = id;
              editProfileController.update();
            },
          ),
          const SizedBox(height: 14),
          MultiSelectTagsWidget(
            onChanged: (selectedIds) {
              editProfileController.selectedServiceTagIds = selectedIds;
              editProfileController.update();
            },
            selectedIds: editProfileController.selectedServiceTagIds,
          ),
          const SizedBox(height: 14),
          // FIX: Use dedicated servicePriceController instead of
          // the non-existent experiencePositionController
          TextFormFieldWidget(
            hintText: "Price",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.servicePriceController,
          ),
          const SizedBox(height: 14),
          Text("Image", style: AppTextStyles.bodyTextStyle2),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                  width: 120,
                  child: ButtonWidgetOne(
                      onTap: () => filePick(),
                      buttonText: "Choose File",
                      buttonTextStyle: AppTextStyles.buttonTextStyle9,
                      borderRadius: 40,
                      buttonColor: const LinearGradient(
                          colors: [Color(0xff4b4c4d), Color(0xff4b4c4d)]))),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  file == null
                      ? "No file chosen"
                      : file!.path.toString().split("/").last.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormFieldWidget(
            hintText: "Name (en)",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.podcastNameController,
          ),
          const SizedBox(height: 14),
          TextFormFieldWidget(
            hintText: "Description (en)",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.podcastDescriptionController,
          ),
          const SizedBox(height: 14),
          SizedBox(
              width: 100,
              child: ButtonWidgetOne(
                  onTap: () {},
                  buttonText: "Add FAQ",
                  buttonTextStyle: AppTextStyles.buttonTextStyle9,
                  borderRadius: 10,
                  buttonColor: const LinearGradient(
                      colors: [Color(0xff2d2e2f), Color(0xff2d2e2f)]))),
          const SizedBox(height: 14),
          // Row(children: [
          //   Switch(
          //       value: isActive,
          //       onChanged: (v) {
          //         setState(() {
          //           isActive = v;
          //         });
          //       }),
          //   const Text("Active?")
          // ]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: 100,
                  child: ButtonWidgetOne(
                      onTap: () => setState(() => isVisibleForm = false),
                      buttonText: "Cancel",
                      buttonTextStyle: AppTextStyles.buttonTextStyle1,
                      borderRadius: 40,
                      buttonColor: const LinearGradient(
                          colors: [Color(0xff2d2e2f), Color(0xff2d2e2f)]))),
              const SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  child: ButtonWidgetOne(
                      onTap: () {
                        addUserProfileServiceDataRepo(
                          editProfileController.podcastNameController.text,
                          editProfileController
                              .podcastDescriptionController.text,
                          editProfileController.selectedServiceCategoryId
                              .toString(),
                          editProfileController.selectedServiceTagIds,
                          editProfileController.servicePriceController.text,
                          file,
                        );
                        setState(() => isVisibleForm = false);
                      },
                      buttonText: "Create",
                      buttonTextStyle: AppTextStyles.buttonTextStyle1,
                      borderRadius: 40,
                      buttonColor: AppColors.gradientOne)),
            ],
          )
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BROADCASTS / PODCASTS (section)
// ─────────────────────────────────────────────────────────────────────────────

class TeacherBroadcastsWidget extends StatefulWidget {
  const TeacherBroadcastsWidget({super.key});

  @override
  State<TeacherBroadcastsWidget> createState() =>
      _TeacherBroadcastsWidgetState();
}

class _TeacherBroadcastsWidgetState extends State<TeacherBroadcastsWidget> {
  bool isVisibleForm = false;
  bool isActive = true;
  File? file;

  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() => file = File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorTwo,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBarWidget(
          leadingIcon: 'assets/icons/Expand_left.png',
          leadingOnTap: () => Get.back(),
          titleText: LanguageConstant.podcasts.tr,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              !isVisibleForm ? _buildList() : _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("All Podcasts", style: AppTextStyles.headingTextStyle1),
            SizedBox(
              width: 100,
              child: ButtonWidgetOne(
                  onTap: () => setState(() => isVisibleForm = true),
                  buttonText: "Add New",
                  buttonTextStyle: AppTextStyles.buttonTextStyle9,
                  borderRadius: 40,
                  buttonColor: AppColors.gradientOne),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("No items found.")
      ],
    );
  }

  Widget _buildForm() {
    return GetBuilder<EditProfileController>(builder: (editProfileController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormFieldWidget(
            hintText: "Name (en)",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.podcastNameController,
          ),
          const SizedBox(height: 14),
          TextFormFieldWidget(
            hintText: "Description (en)",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.podcastDescriptionController,
          ),
          const SizedBox(height: 14),
          CategoryDropDownWidget(
            title: "Choose Podcast Category",
            categories: editProfileController.broadcastCategories,
            selectedId: editProfileController.selectedPodcastCategoryId,
            onChanged: (id) {
              editProfileController.selectedPodcastCategoryId = id;
              editProfileController.update();
            },
          ),
          const SizedBox(height: 14),
          MultiSelectTagsWidget(
            onChanged: (selectedIds) {
              editProfileController.selectedPodcastTagIds = selectedIds;
              editProfileController.update();
            },
            selectedIds: editProfileController.selectedPodcastTagIds,
          ),
          const SizedBox(height: 14),
          // FIX: Use dedicated broadcastFileTypeController
          TextFormFieldWidget(
            hintText: "Choose file type",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.broadcastFileTypeController,
          ),
          const SizedBox(height: 14),
          // FIX: Use dedicated broadcastFileLinkController
          TextFormFieldWidget(
            hintText: "File link",
            onChanged: (v) {},
            validator: (v) => null,
            controller: editProfileController.broadcastFileLinkController,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                SizedBox(
                    width: 120,
                    child: ButtonWidgetOne(
                        onTap: () => filePick(),
                        buttonText: "Select a File",
                        buttonTextStyle: AppTextStyles.buttonTextStyle9,
                        borderRadius: 40,
                        buttonColor: const LinearGradient(
                            colors: [Color(0xff4b4c4d), Color(0xff4b4c4d)]))),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    file == null
                        ? "File Must Be Of Type doc, docx, pdf, xls, png, jpeg"
                        : file!.path.toString().split("/").last.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Row(children: [
          //   Switch(
          //       value: isActive,
          //       onChanged: (v) {
          //         setState(() {
          //           isActive = v;
          //         });
          //       }),
          //   const Text("Active?")
          // ]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: 100,
                  child: ButtonWidgetOne(
                      onTap: () => setState(() => isVisibleForm = false),
                      buttonText: "Cancel",
                      buttonTextStyle: AppTextStyles.buttonTextStyle1,
                      borderRadius: 40,
                      buttonColor: const LinearGradient(
                          colors: [Color(0xff2d2e2f), Color(0xff2d2e2f)]))),
              const SizedBox(width: 10),
              SizedBox(
                  width: 100,
                  child: ButtonWidgetOne(
                      onTap: () {
                        addUserProfileBroadcastDataRepo(
                          editProfileController.podcastNameController.text,
                          editProfileController
                              .podcastDescriptionController.text,
                          editProfileController.selectedPodcastCategoryId
                              .toString(),
                          editProfileController.selectedPodcastTagIds,
                          editProfileController.broadcastFileTypeController.text,
                          editProfileController.broadcastFileLinkController.text,
                          file,
                        );
                        setState(() => isVisibleForm = false);
                      },
                      buttonText: "Create",
                      buttonTextStyle: AppTextStyles.buttonTextStyle1,
                      borderRadius: 40,
                      buttonColor: AppColors.gradientOne)),
            ],
          )
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class MultiSelectTagsWidget extends StatefulWidget {
  final List<int> selectedIds;
  final Function(List<int>) onChanged;

  const MultiSelectTagsWidget({
    super.key,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  State<MultiSelectTagsWidget> createState() => _MultiSelectTagsWidgetState();
}

class _MultiSelectTagsWidgetState extends State<MultiSelectTagsWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tags", style: AppTextStyles.bodyTextStyle1),
          const SizedBox(height: 8),
          Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(30),
            shadowColor: Colors.grey.withOpacity(0.4),
            child: InkWell(
              onTap: () => _showTagsDialog(controller),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.transparent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.selectedIds.isEmpty
                            ? "Choose Tags"
                            : controller.allTags
                            .where((tag) =>
                            widget.selectedIds.contains(tag.id))
                            .map((tag) => tag.name)
                            .join(", "),
                        style: AppTextStyles.hintTextStyle1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down,
                        color: AppColors.primaryColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showTagsDialog(EditProfileController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Select Tags"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.allTags.length,
                itemBuilder: (context, index) {
                  final tag = controller.allTags[index];
                  final isSelected = widget.selectedIds.contains(tag.id);
                  return CheckboxListTile(
                    title: Text(tag.name ?? ""),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setDialogState(() {
                        if (value == true) {
                          widget.selectedIds.add(tag.id!);
                        } else {
                          widget.selectedIds.remove(tag.id);
                        }
                      });
                      widget.onChanged(widget.selectedIds);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          );
        });
      },
    );
  }
}

/// Generic category drop-down.
/// FIX: [CategoryModel] must be imported from your models directory.
/// Adjust the import path at the top of the file if needed.
class CategoryDropDownWidget extends StatelessWidget {
  final String title;
  final List<CategoryModel> categories;
  final int? selectedId;
  final Function(int?) onChanged;

  const CategoryDropDownWidget({
    super.key,
    required this.title,
    required this.categories,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.bodyTextStyle1),
        const SizedBox(height: 8),
        Material(
          elevation: 6.0,
          borderRadius: BorderRadius.circular(30),
          shadowColor: Colors.grey.withOpacity(0.4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.transparent),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedId,
                isExpanded: true,
                hint: Text("Choose Category",
                    style: AppTextStyles.hintTextStyle1),
                items: categories.map((CategoryModel category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name?.en ?? "",
                        style: AppTextStyles.hintTextStyle1),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

Future<void> _selectDate(
    BuildContext context, TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null) {
    controller.text =
    "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  }
}