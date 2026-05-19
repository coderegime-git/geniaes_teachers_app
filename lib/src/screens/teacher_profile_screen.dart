import 'dart:developer';

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resize/resize.dart';
import 'package:tutorhub_for_teachers/src/widgets/chat_appointment_slots_widget.dart';
import 'package:tutorhub_for_teachers/src/widgets/video_call_appointment_slots_widget.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

import '../controllers/appoinment_commission_controller.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/general_controller.dart';
import '../repositories/delete_account_repo.dart';
import '../repositories/edit_user_profile_repo.dart';

import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/audio_call_appointment_slots_widget.dart';
import '../widgets/button_widget.dart';

import '../widgets/custom_tile_widget.dart';
import '../widgets/teacher_profile_widgets.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<TeacherProfileScreen> createState() => TeacherProfileScreenState();
}

class TeacherProfileScreenState extends State<TeacherProfileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _userProfileUpdateFormKey = GlobalKey();
  final editProfileLogic = Get.put(EditProfileController());
  final generalLogic = Get.put(GeneralController());
  final appointmentCommissionLogic =
      Get.put(GetAppoinmentCommissionController());
  File? file;
  int tabsLength = 3;
  int indexPage = 0;
  TabController? tabController;
  bool isVisibleEducationForm = false;
  var fromAppointmentSchduleSlots =
      Get.parameters["fromAppointmentSchduleSlots"];

  filePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });

      print(file!.path);
    } else {
      // User canceled the picker
    }
  }

  bool _hasModule(String moduleName) {
    return Get.find<GeneralController>()
            .currentTeacherModel
            ?.teacherModules
            ?.contains(moduleName) ??
        false;
  }

  List<Tab> getTabs() {
    List<Tab> tabs = [Tab(text: LanguageConstant.generalInfo.tr)];
    if (_hasModule("teacher-appointment")) {
      tabs.add(Tab(text: LanguageConstant.scheduleSlots.tr));
    }
    if (_hasModule("teacher-social-info")) {
      tabs.add(Tab(text: LanguageConstant.socialInfo.tr));
    }
    return tabs;
  }

  List<Widget> getTabViews() {
    List<Widget> views = [const GeneralInfoWidget()];
    if (_hasModule("teacher-appointment")) {
      views.add(const AppointmentScheduleWidget());
    }
    if (_hasModule("teacher-social-info")) {
      views.add(const TeacherSocialInfoWidget());
    }
    return views;
  }

  @override
  void initState() {
    super.initState();

    tabsLength = getTabs().length;
    int initIndex = fromAppointmentSchduleSlots == "Yes" &&
            _hasModule("teacher-appointment")
        ? 1
        : 0;

    tabController =
        TabController(vsync: this, length: tabsLength, initialIndex: initIndex);
    // getMethod(context, getLoggedInUserUrl, null, true, loggedInUserRepo);
    editProfileLogic.userProfileFirstNameController.text =
        generalLogic.currentTeacherModel!.loginInfo!.firstName ?? '';

    editProfileLogic.userProfileLastNameController.text =
        generalLogic.currentTeacherModel!.loginInfo!.lastName ?? '';

    editProfileLogic.userProfileUserNameController.text =
        generalLogic.currentTeacherModel!.loginInfo!.userName ?? '';

    editProfileLogic.userProfileDescriptionController.text =
        generalLogic.currentTeacherModel!.loginInfo!.description ?? '';

    editProfileLogic.userProfileAddressLine1Controller.text =
        generalLogic.currentTeacherModel!.loginInfo!.addressLine1 ?? '';

    editProfileLogic.userProfileAddressLine2Controller.text =
        generalLogic.currentTeacherModel!.loginInfo!.addressLine1 ?? '';

    editProfileLogic.userProfileZipCodeController.text =
        generalLogic.currentTeacherModel!.loginInfo!.zipCode ?? '';

    // editProfileLogic.uploadedProfileImage =
    //     generalLogic.currentTeacherModel!.loginInfo!.image;

    log("${generalLogic.currentTeacherModel!.loginInfo!.image} Log Image");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<EditProfileController>(
          builder: (editProfileController) {
        return ModalProgressHUD(
            progressIndicator: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
            inAsyncCall: generalController.formLoaderController,
            child: GestureDetector(
              onTap: () {
                final FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(310.h),
                  child: Stack(
                    children: [
                      AppBarWidgetThree(
                        titleText: LanguageConstant.profile.tr,
                        leadingIcon: "assets/icons/Expand_left.png",
                        leadingOnTap: () {
                          Get.back();
                        },
                        searchOnTap: () {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 150.h),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          decoration:
                              const BoxDecoration(color: AppColors.bgColorTwo),
                        ),
                      ),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              margin: EdgeInsets.only(top: 85.h),
                              child: Column(
                                children: [
                                  editProfileLogic.profileImage == null
                                      ? generalLogic.currentTeacherModel == null
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 20, 20, 20),
                                              decoration: BoxDecoration(
                                                  color: AppColors.offWhite,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: AppColors
                                                          .primaryColor)),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                      "assets/icons/Upload_duotone_line.png"),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    LanguageConstant
                                                        .uploadImage.tr,
                                                    style: AppTextStyles
                                                        .bodyTextStyle1,
                                                  )
                                                ],
                                              ),
                                            )
                                          : generalLogic.currentTeacherModel!
                                                      .loginInfo!.image ==
                                                  null
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 20, 20, 20),
                                                  decoration: BoxDecoration(
                                                      color: AppColors.offWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: AppColors
                                                              .primaryColor)),
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                          "assets/icons/Upload_duotone_line.png"),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        LanguageConstant
                                                            .uploadImage.tr,
                                                        style: AppTextStyles
                                                            .bodyTextStyle1,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  child: Image.network(
                                                    scale: 4.h,
                                                    '$mediaUrl${generalLogic.currentTeacherModel!.loginInfo!.image}',
                                                    fit: BoxFit.cover,
                                                    height: 110.h,
                                                    width: 120.w,
                                                  ))
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          child: Image.file(
                                            scale: 3.h,
                                            // '$mediaUrl${generalLogic.currentTeacherModel!.loginInfo!.image}',
                                            editProfileController.profileImage!,
                                            height: 110.h,
                                            width: 120.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    generalController.storageBox
                                                .read('authToken') !=
                                            null
                                        ? "${generalController.currentTeacherModel!.loginInfo!.firstName} ${generalController.currentTeacherModel!.loginInfo!.lastName}"
                                        : "",
                                    style: AppTextStyles.bodyTextStyle13,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    generalController.storageBox
                                                .read('authToken') !=
                                            null
                                        ? "${generalController.currentTeacherModel!.email}"
                                        : "",
                                    style: AppTextStyles.bodyTextStyle2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              imagePickerDialog(context);
                            },
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                                margin:
                                    EdgeInsets.only(bottom: 100.h, left: 88.w),
                                decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.edit,
                                  color: AppColors.white,
                                  size: 16.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        child: Theme(
                          data: ThemeData()
                              .copyWith(dividerColor: AppColors.primaryColor),
                          child: TabBar(
                            controller: tabController,
                            isScrollable: true,
                            labelColor: AppColors.primaryColor,
                            unselectedLabelColor: AppColors.textColorOne,
                            padding: EdgeInsets.fromLTRB(28.w, 0.h, 28.w, 0.h),
                            labelStyle: AppTextStyles.tabbarTextStyle1,
                            unselectedLabelStyle:
                                AppTextStyles.tabbarTextStyle2,
                            indicator: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: AppColors.primaryColor,
                                width: 3.w,
                              ),
                            )),
                            tabs: getTabs(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top:
                            BorderSide(color: AppColors.primaryColor, width: 1),
                      ),
                    ),
                    child: TabBarView(
                        controller: tabController, children: getTabViews())),
              ),
            ));
      });
    });
  }

  // Socail Links
  Widget social() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            style: AppTextStyles.hintTextStyle1,
            // controller: controller,
            decoration: InputDecoration(
              hintText: "Instagram link",
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              isDense: true,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            style: AppTextStyles.hintTextStyle1,
            // controller: controller,
            decoration: InputDecoration(
              hintText: "Facebook link",
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              isDense: true,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            style: AppTextStyles.hintTextStyle1,
            // controller: controller,
            decoration: InputDecoration(
              hintText: "Youtube link",
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              isDense: true,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            style: AppTextStyles.hintTextStyle1,
            // controller: controller,
            decoration: InputDecoration(
              hintText: "Linkedin link",
              hintStyle: AppTextStyles.hintTextStyle1,
              labelStyle: AppTextStyles.hintTextStyle1,
              contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              isDense: true,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ButtonWidgetOne(
              onTap: () {
                Get.toNamed(PageRoutes.homeScreen);
                setState(() {
                  indexPage++;
                });
              },
              buttonText: "Continue",
              buttonTextStyle: AppTextStyles.buttonTextStyle1,
              borderRadius: 40,
              buttonColor: AppColors.gradientOne),
        ],
      ),
    );
  }

  void imagePickerDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() {
                    Get.find<EditProfileController>().profileImagesList = [];
                  });
                  await pickImage(context, ImageSource.camera);
                  setState(
                    () {
                      Get.find<EditProfileController>().profileImage = File(
                          Get.find<EditProfileController>()
                              .profileImagesList[0]
                              .path);
                      editUserProfileImageRepo(
                        Get.find<EditProfileController>()
                            .userProfileFirstNameController
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileLastNameController
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileUserNameController
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileDescriptionController
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileAddressLine1Controller
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileAddressLine2Controller
                            .text,
                        // 1,
                        // 1,
                        // 1,
                        Get.find<EditProfileController>()
                            .userProfileZipCodeController
                            .text,
                        [1],
                        [1],
                        [1],
                        Get.find<EditProfileController>().profileImage,
                        Get.find<EditProfileController>().profileImage,
                      );
                    },
                  );
                },
                child: Text(
                  LanguageConstant.camera.tr,
                  style: AppTextStyles.buttonTextStyle8,
                ),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() {
                    Get.find<EditProfileController>().profileImagesList = [];
                  });
                  await pickImage(context, ImageSource.gallery);
                  setState(
                    () {
                      Get.find<EditProfileController>().profileImage = File(
                          Get.find<EditProfileController>()
                              .profileImagesList[0]
                              .path);
                      editUserProfileImageRepo(
                        Get.find<EditProfileController>()
                            .userProfileFirstNameController
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileLastNameController
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileUserNameController
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileDescriptionController
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileAddressLine1Controller
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileAddressLine2Controller
                            .text,
                        Get.find<EditProfileController>()
                            .userProfileZipCodeController
                            .text,
                        [1],
                        [1],
                        [1],
                        Get.find<EditProfileController>().profileImage,
                        Get.find<EditProfileController>().profileImage,
                      );
                    },
                  );
                },
                child: Text(
                  LanguageConstant.gallery.tr,
                  style: AppTextStyles.buttonTextStyle8,
                ),
              ),
            ],
          );
        });
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    final EditProfileController controller = Get.find<EditProfileController>();

    // Request permission before accessing the camera/gallery
    bool hasPermission = await requestPermission(source);
    if (!hasPermission) return;

    final ImagePicker _picker = ImagePicker();
    XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 10,
      maxWidth: 400,
      maxHeight: 600,
    );
    setState(() {});
    if (pickedFile != null) {
      controller.profileImagesList = [File(pickedFile.path)];
      controller.profileImage = File(pickedFile.path);

      print(pickedFile.path);
      print(controller.profileImage);
    }
  }

  Future<bool> requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      PermissionStatus status = await Permission.camera.request();
      return status.isGranted;
    } else {
      if (Platform.isAndroid) {
        // The Android system photo picker handles permissions internally.
        return true;
      } else {
        PermissionStatus status = await Permission.photos.request();
        return status.isGranted || status.isLimited;
      }
    }
  }
}

class GeneralInfoWidget extends StatelessWidget {
  const GeneralInfoWidget({super.key});

  bool _hasModule(String moduleName) {
    return Get.find<GeneralController>()
            .currentTeacherModel
            ?.teacherModules
            ?.contains(moduleName) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          children: [
            if (_hasModule("teacher-basic-profile"))
              CustomTileWidgetTwo(
                tileTitle: LanguageConstant.basicInformation.tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(const TeacherBasicInformationWidget());
                },
              ),
            CustomTileWidgetTwo(
                tileTitle: LanguageConstant.education.tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(TeacherEducationWidget());
                }),
            if (_hasModule("teacher-certifications"))
              CustomTileWidgetTwo(
                tileTitle: LanguageConstant.certificate.tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(TeacherCertificateWidget());
                },
              ),
            CustomTileWidgetTwo(
              tileTitle: LanguageConstant.experience.tr,
              tileColor: AppColors.primaryColor,
              onTap: () {
                Get.to(TeacherExperienceWidget());
              },
            ),
            if (_hasModule("teacher-broadcasts"))
              CustomTileWidgetTwo(
                tileTitle: "Media".tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(TeacherPodcastsWidget());
                },
              ),
            if (_hasModule("teacher-podcasts"))
              CustomTileWidgetTwo(
                tileTitle: LanguageConstant.podcasts.tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(const TeacherBroadcastsWidget());
                },
              ),
            if (_hasModule("teacher-blogs"))
              CustomTileWidgetTwo(
                tileTitle: LanguageConstant.blogs.tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(const TeacherBlogsWidget());
                },
              ),
            if (_hasModule("teacher-calendly"))
              CustomTileWidgetTwo(
                tileTitle: "Calendly".tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(const TeacherCalendlyWidget());
                },
              ),
            if (_hasModule("teacher-events"))
              CustomTileWidgetTwo(
                tileTitle: LanguageConstant.events.tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(const TeacherEventsWidget());
                },
              ),
            if (_hasModule("teacher-services"))
              CustomTileWidgetTwo(
                tileTitle: "Services".tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(const TeacherServicesWidget());
                },
              ),
            if (_hasModule("teacher-archives"))
              CustomTileWidgetTwo(
                tileTitle: LanguageConstant.courses.tr,
                tileColor: AppColors.primaryColor,
                onTap: () {
                  Get.to(const TeacherArchivesWidget());
                },
              ),
            Center(
              child: SizedBox(
                width: 140.w,
                child: ButtonWidgetOne(
                  onTap: () {
                    getMethod(context, deleteAccountURL, null, true,
                        deleteAccountRepo);
                  },
                  buttonText: LanguageConstant.deleteAccount.tr,
                  buttonTextStyle: AppTextStyles.bodyTextStyle9
                      .copyWith(color: Colors.black),
                  borderRadius: 40,
                  buttonColor: AppColors.gradientOne,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AppointmentScheduleWidget extends StatelessWidget {
  const AppointmentScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          children: [
            CustomTileWidgetOne(
              tileTitle: LanguageConstant.videoCall.tr,
              tileColor: AppColors.primaryColor,
              onTap: () {
                Get.to(const VideoCallAppointmentSlotsWidget());
              },
              leadingIcon: 'assets/icons/icon_Video_.png',
            ),
            CustomTileWidgetOne(
              tileTitle: LanguageConstant.audioCall.tr,
              tileColor: AppColors.primaryColor,
              onTap: () {
                Get.to(const AudioCallAppointmentSlotsWidget());
              },
              leadingIcon: 'assets/icons/icon_Volume_Up_.png',
            ),
            CustomTileWidgetOne(
              tileTitle: LanguageConstant.liveChat.tr,
              tileColor: AppColors.primaryColor,
              onTap: () {
                Get.to(const ChatAppointmentSlotsWidget());
              },
              leadingIcon: 'assets/icons/icon_comments_.png',
            ),
          ],
        ),
      ),
    );
  }
}
