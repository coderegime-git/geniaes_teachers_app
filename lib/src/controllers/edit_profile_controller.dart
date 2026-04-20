import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/get_teacher_profile_certificate_model.dart';
import '../models/get_teacher_profile_certificate_model.dart';
import '../models/get_teacher_profile_education_model.dart';
import '../models/get_teacher_profile_experience_model.dart';
import '../models/get_teacher_profile_podcast_model.dart';
import 'general_controller.dart';

class EditProfileController extends GetxController {
  GetTeacherProfileCertificateModel getTeacherProfileCertificateModel =
      GetTeacherProfileCertificateModel(); //  for saving User Certificate Profile
  GetTeacherProfileExperienceModel getTeacherProfileExperienceModel =
      GetTeacherProfileExperienceModel(); //  for saving User Experience Profile
  GetTeacherProfileEducationModel getTeacherProfileEducationModel =
      GetTeacherProfileEducationModel(); //  for saving User Education Profile
  GetTeacherProfilePodcastModel getTeacherProfilePodcastModel =
      GetTeacherProfilePodcastModel(); //  for saving User Podcast Profile
  TeacherProfileCertificateModel teacherProfileCertificateModel =
      TeacherProfileCertificateModel(); //  for saving User Certificate Profile
  TeacherProfileExperienceModel teacherProfileExperienceModel =
      TeacherProfileExperienceModel(); //  for saving User Experience Profile
  TeacherProfileEducationModel teacherProfileEducationModel =
      TeacherProfileEducationModel(); //  for saving User Education Profile
  TeacherProfilePodcastModel teacherProfilePodcastModel =
      TeacherProfilePodcastModel(); //  for saving User Podcast Profile

  // Basic Information Controllers
  TextEditingController userProfileFirstNameController =
      TextEditingController();
  TextEditingController userProfileLastNameController = TextEditingController();

  TextEditingController userProfileUserNameController = TextEditingController();
  TextEditingController userProfileDescriptionController =
      TextEditingController();
  TextEditingController userProfileAddressLine1Controller =
      TextEditingController();
  TextEditingController userProfileAddressLine2Controller =
      TextEditingController();
  TextEditingController userProfileZipCodeController = TextEditingController();

  // Education Controllers
  TextEditingController educationInstituteNameController =
      TextEditingController();
  TextEditingController educationDescriptionController =
      TextEditingController();
  TextEditingController educationDegreeController = TextEditingController();
  TextEditingController educationSubjectController = TextEditingController();
  TextEditingController educationStartDateController = TextEditingController();
  TextEditingController educationEndDateController = TextEditingController();

  // Certificate Controllers
  TextEditingController certificateNameController = TextEditingController();
  TextEditingController certificateDescriptionController =
      TextEditingController();
  TextEditingController certificateFileController = TextEditingController();

  // Experience Controllers
  TextEditingController experienceCompanyNameController =
      TextEditingController();
  TextEditingController experienceDescriptionController =
      TextEditingController();
  TextEditingController experienceStartDateController = TextEditingController();
  TextEditingController experienceEndDateController = TextEditingController();

  // Podcast Controllers
  TextEditingController podcastNameController = TextEditingController();
  TextEditingController podcastDescriptionController = TextEditingController();
  TextEditingController podcastFileTypeController = TextEditingController();
  TextEditingController podcastLinkTypeController = TextEditingController();
  TextEditingController podcastCategoryController = TextEditingController();
  TextEditingController podcastTagController = TextEditingController();
  TextEditingController podcastFileURLController = TextEditingController();

  String? userProfileSelectedGender;
  DateTime? userProfileSelectedDate;

  File? profileImage;
  String? uploadedProfileImage;
  List profileImagesList = [];

  List<TeacherProfileCertificateModel> teacherProfileCertificateForPagination =
      [];
  List<TeacherProfileExperienceModel> teacherProfileExperienceForPagination =
      [];
  List<TeacherProfileEducationModel> teacherProfileEducationForPagination = [];
  List<TeacherProfilePodcastModel> teacherProfilePodcastForPagination = [];

  bool allTeacherCertificateLoader = false;
  updateTeacherCertificateLoader(bool newValue) {
    allTeacherCertificateLoader = newValue;
    update();
  }

  bool allTeacherExperienceLoader = false;
  updateTeacherExperienceLoader(bool newValue) {
    allTeacherExperienceLoader = newValue;
    update();
  }

  bool allTeacherEducationLoader = false;
  updateTeacherEducationLoader(bool newValue) {
    allTeacherEducationLoader = newValue;
    update();
  }

  bool allTeacherPodcastLoader = false;
  updateTeacherPodcastLoader(bool newValue) {
    allTeacherPodcastLoader = newValue;
    update();
  }

  ///------------------------------- Teacher-Certificate-data-check
  bool getTeacherCertificateCheck = false;
  getTeacherCertificateDataCheck(bool value) {
    getTeacherCertificateCheck = value;
    update();
  }

  ///------------------------------- Teacher-Experience-data-check
  bool getTeacherExperienceCheck = false;
  getTeacherExperienceDataCheck(bool value) {
    getTeacherExperienceCheck = value;
    update();
  }

  ///------------------------------- Teacher-Education-data-check
  bool getTeacherEducationCheck = false;
  getTeacherEducationDataCheck(bool value) {
    getTeacherEducationCheck = value;
    update();
  }

  ///------------------------------- Teacher-Podcast-data-check
  bool getTeacherPodcastCheck = false;
  getTeacherPodcastDataCheck(bool value) {
    getTeacherPodcastCheck = value;
    update();
  }

  int? selectedTeacherCertificateIndex = 0;
  updateSelectedTeacherCertificateIndex(int? newValue) {
    selectedTeacherCertificateIndex = newValue;
    update();
  }

  int? selectedTeacherExperienceIndex = 0;
  updateSelectedTeacherExperienceIndex(int? newValue) {
    selectedTeacherExperienceIndex = newValue;
    update();
  }

  int? selectedTeacherEducationIndex = 0;
  updateSelectedTeacherEducationIndex(int? newValue) {
    selectedTeacherEducationIndex = newValue;
    update();
  }

  int? selectedTeacherPodcastIndex = 0;
  updateSelectedTeacherPodcastIndex(int? newValue) {
    selectedTeacherPodcastIndex = newValue;
    update();
  }

  /// Certificate-paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getTeacherProfileCertificateModel.data!.meta!.lastPage! >
        getTeacherProfileCertificateModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  /// Experience-paginated-data-fetch
  Future paginationExperienceDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getTeacherProfileExperienceModel.data!.meta!.lastPage! >
        getTeacherProfileExperienceModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  /// Education-paginated-data-fetch
  Future paginationEducationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getTeacherProfileEducationModel.data!.meta!.lastPage! >
        getTeacherProfileEducationModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  /// Podcast-paginated-data-fetch
  Future paginationPodcastDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getTeacherProfilePodcastModel.data!.meta!.lastPage! >
        getTeacherProfilePodcastModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  updateTeacherCertificateForPagination(
      TeacherProfileCertificateModel teacherProfileCertificateModel) {
    teacherProfileCertificateForPagination.add(teacherProfileCertificateModel);
    update();
  }

  updateTeacherExperienceForPagination(
      TeacherProfileExperienceModel teacherProfileExperienceModel) {
    teacherProfileExperienceForPagination.add(teacherProfileExperienceModel);
    update();
  }

  updateTeacherEducationForPagination(
      TeacherProfileEducationModel teacherProfileEducationModel) {
    teacherProfileEducationForPagination.add(teacherProfileEducationModel);
    update();
  }

  updateTeacherPodcastForPagination(
      TeacherProfilePodcastModel teacherProfilePodcastModel) {
    teacherProfilePodcastForPagination.add(teacherProfilePodcastModel);
    update();
  }

  ///------------------------------- user-profile-data-check
  bool getUserProfileDataCheck = false;

  changeGetUserProfileDataCheck(bool value) {
    getUserProfileDataCheck = value;
    update();
  }
}
