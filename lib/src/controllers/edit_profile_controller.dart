import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/all_blog_posts_model.dart';
import '../models/get_teacher_profile_certificate_model.dart';
import '../models/get_teacher_profile_education_model.dart';
import '../models/get_teacher_profile_experience_model.dart';
import '../models/get_teacher_profile_podcast_model.dart';
import '../models/get_teacher_profile_event_model.dart';
import '../models/get_teacher_profile_service_model.dart';
import '../models/categories_tags_model.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
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
  GetTeacherProfileEventModel getTeacherProfileEventModel =
      GetTeacherProfileEventModel(); //  for saving User Event Profile
  GetTeacherProfilePodcastModel getTeacherProfileBroadcastModel =
      GetTeacherProfilePodcastModel(); //  for saving User Broadcast Profile
  GetAllBlogPostsModel getTeacherProfileBlogModel =
      GetAllBlogPostsModel(); //  for saving User Blog Profile
  GetTeacherProfilePodcastModel getTeacherProfileArchiveModel =
      GetTeacherProfilePodcastModel(); //  for saving User Archive Profile
  GetTeacherProfileServiceModel getTeacherProfileServiceModel =
      GetTeacherProfileServiceModel(); //  for saving User Service Profile
  TeacherProfileCertificateModel teacherProfileCertificateModel =
      TeacherProfileCertificateModel(); //  for saving User Certificate Profile
  TeacherProfileExperienceModel teacherProfileExperienceModel =
      TeacherProfileExperienceModel(); //  for saving User Experience Profile
  TeacherProfileEducationModel teacherProfileEducationModel =
      TeacherProfileEducationModel(); //  for saving User Education Profile
  TeacherProfilePodcastModel teacherProfilePodcastModel =
      TeacherProfilePodcastModel(); //  for saving User Podcast Profile
  TeacherProfileEventModel teacherProfileEventModel =
      TeacherProfileEventModel(); //  for saving User Event Profile
  TeacherProfileServiceModel teacherProfileServiceModel =
      TeacherProfileServiceModel(); //  for saving User Service Profile
  TeacherProfilePodcastModel teacherProfileBroadcastModel =
      TeacherProfilePodcastModel(); //  for saving User Broadcast Profile

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

  // Event Date Controller
  TextEditingController eventDateController = TextEditingController();

  TextEditingController servicePriceController = TextEditingController();
  TextEditingController broadcastFileTypeController = TextEditingController();
  TextEditingController broadcastFileLinkController = TextEditingController();
  TextEditingController eventEndDateController = TextEditingController();
  int? selectedBlogCategoryId, selectedEventCategoryId;
  int? selectedServiceCategoryId, selectedPodcastCategoryId, selectedArchiveCategoryId;
  List<int> selectedBlogTagIds = [], selectedEventTagIds = [];
  List<int> selectedServiceTagIds = [], selectedPodcastTagIds = [], selectedArchiveTagIds = [];

  // Category and Tag Lists
  List<CategoryModel> broadcastCategories = [];
  List<CategoryModel> eventCategories = [];
  List<CategoryModel> blogCategories = [];
  List<CategoryModel> serviceCategories = [];
  List<CategoryModel> archiveCategories = [];
  List<TagModel> allTags = [];
  
  List<int> selectedMediaTagIds = []; // For Teacher Posts (Media)

  @override
  void onInit() {
    super.onInit();
    fetchAllCategoriesAndTags();
  }

  Future<void> fetchAllCategoriesAndTags() async {
    await Future.wait([
      fetchBroadcastCategories(),
      fetchEventCategories(),
      fetchBlogCategories(),
      fetchServiceCategories(),
      fetchArchiveCategories(),
      fetchTags(),
    ]);
  }

  Future<void> fetchBroadcastCategories() async {
    await getMethod(
        Get.context!,
        getBroadcastCategoriesURL,
        null,
        false,
            (context, success, data) {
          if (success && data != null && data['success'] == true) {
            broadcastCategories = (data['data'] as List)
                .map((e) => CategoryModel.fromJson(e))
                .toList();
            update();
          }
        }
    );
  }

  Future<void> fetchEventCategories() async {
    await getMethod(
        Get.context!,
        getEventCategoriesURL,
        null,
        false,
            (context, success, data) {
          if (success && data != null && data['success'] == true) {
            eventCategories = (data['data'] as List)
                .map((e) => CategoryModel.fromJson(e))
                .toList();
            update();
          }
        }
    );
  }

  Future<void> fetchBlogCategories() async {
    await getMethod(
        Get.context!,
        blogCategoriesUrl,
        null,
        false,
            (context, success, data) {
          if (success && data != null && data['success'] == true) {
            blogCategories = (data['data'] as List)
                .map((e) => CategoryModel.fromJson(e))
                .toList();
            update();
          }
        }
    );
  }

  Future<void> fetchServiceCategories() async {
    await getMethod(
        Get.context!,
        getServiceCategoriesURL,
        null,
        false,
            (context, success, data) {
          if (success && data != null && data['success'] == true) {
            serviceCategories = (data['data'] as List)
                .map((e) => CategoryModel.fromJson(e))
                .toList();
            update();
          }
        }
    );
  }

  Future<void> fetchArchiveCategories() async {
    await getMethod(
        Get.context!,
        getArchiveCategoriesURL,
        null,
        false,
            (context, success, data) {
          if (success && data != null && data['success'] == true) {
            archiveCategories = (data['data'] as List)
                .map((e) => CategoryModel.fromJson(e))
                .toList();
            update();
          }
        }
    );
  }

  Future<void> fetchTags() async {
    await getMethod(
        Get.context!,
        tagsUrl,
        null,
        false,
            (context, success, data) {
          if (success && data != null && data['success'] == true) {
            allTags = (data['data'] as List)
                .map((e) => TagModel.fromJson(e))
                .toList();
            update();
          }
        }
    );
  }

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
  List<TeacherProfileEventModel> teacherProfileEventForPagination = [];
  List<TeacherProfileServiceModel> teacherProfileServiceForPagination = [];
  List<TeacherProfilePodcastModel> teacherProfileBroadcastForPagination = [];
  List<BlogModel> teacherProfileBlogForPagination = [];
  List<TeacherProfilePodcastModel> teacherProfileArchiveForPagination = [];

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

  bool allTeacherBroadcastLoader = false;
  updateTeacherBroadcastLoader(bool newValue) {
    allTeacherBroadcastLoader = newValue;
    update();
  }

  bool allTeacherBlogLoader = false;
  updateTeacherBlogLoader(bool newValue) {
    allTeacherBlogLoader = newValue;
    update();
  }

  bool allTeacherEventLoader = false;
  updateTeacherEventLoader(bool newValue) {
    allTeacherEventLoader = newValue;
    update();
  }

  bool allTeacherArchiveLoader = false;
  updateTeacherArchiveLoader(bool newValue) {
    allTeacherArchiveLoader = newValue;
    update();
  }

  bool allTeacherServiceLoader = false;
  updateTeacherServiceLoader(bool newValue) {
    allTeacherServiceLoader = newValue;
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

  bool getTeacherEventCheck = false;
  getTeacherEventDataCheck(bool value) {
    getTeacherEventCheck = value;
    update();
  }

  bool getTeacherServiceCheck = false;
  getTeacherServiceDataCheck(bool value) {
    getTeacherServiceCheck = value;
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

  int? selectedTeacherEventIndex = 0;
  updateSelectedTeacherEventIndex(int? newValue) {
    selectedTeacherEventIndex = newValue;
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

  /// Event-paginated-data-fetch
  Future paginationEventDataLoad(BuildContext context) async {
    log("load more");
    // update data and loading status
    if (getTeacherProfileEventModel.data!.meta!.lastPage! >
        getTeacherProfileEventModel.data!.meta!.currentPage!) {
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

  updateTeacherBroadcastForPagination(
      TeacherProfilePodcastModel teacherProfilePodcastModel) {
    teacherProfileBroadcastForPagination.add(teacherProfilePodcastModel);
    update();
  }

  updateTeacherEventForPagination(
      TeacherProfileEventModel teacherProfileEventModel) {
    teacherProfileEventForPagination.add(teacherProfileEventModel);
    update();
  }

  updateTeacherBlogForPagination(BlogModel blogModel) {
    teacherProfileBlogForPagination.add(blogModel);
    update();
  }

  updateTeacherArchiveForPagination(TeacherProfilePodcastModel element) {
    teacherProfileArchiveForPagination.add(element);
    update();
  }

  updateTeacherServiceForPagination(
      TeacherProfileServiceModel teacherProfileServiceModel) {
    teacherProfileServiceForPagination.add(teacherProfileServiceModel);
    update();
  }

  ///------------------------------- user-profile-data-check
  bool getUserProfileDataCheck = false;

  changeGetUserProfileDataCheck(bool value) {
    getUserProfileDataCheck = value;
    update();
  }
}
