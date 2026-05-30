import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart' as dio_instance;
import '../api_services/delete_service.dart';
import '../api_services/get_service.dart';
import '../api_services/header.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/general_controller.dart';

import '../models/get_teacher_profile_certificate_model.dart';
import '../models/get_teacher_profile_education_model.dart';
import '../models/get_teacher_profile_experience_model.dart';
import '../models/logged_in_teacher_model.dart';

import '../widgets/custom_dialog.dart';

import 'get_teacher_archives_repo.dart';
import 'get_teacher_blogs_repo.dart';
import 'get_teacher_events_repo.dart';
import 'get_teacher_podcasts_repo.dart';
import 'get_teacher_broadcasts_repo.dart';
import 'logged_in_user_repo.dart';
import 'get_teacher_service_repo.dart';

editUserProfileDataRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response['success'].toString() == 'true') {
      print("${response['data']} Response Data 1");
      log("${Get.find<GeneralController>().storageBox.read('userData')} Response Data 1.1");
      log("${jsonEncode(Get.find<GeneralController>().currentTeacherModel)} Response Data 1.2");
      log("${jsonEncode(GetLoggedInTeacherDataModel.fromJson(response['data']))} Response Data 1.3");
      Get.find<GeneralController>().currentTeacherModel =
          GetLoggedInTeacherDataModel.fromJson(response);
      if (Get.find<GeneralController>().storageBox.hasData('userData')) {
        Get.find<GeneralController>().currentTeacherModel =
            GetLoggedInTeacherDataModel.fromJson(response['data']);
        Get.find<GeneralController>().storageBox.write('userData',
            jsonEncode(Get.find<GeneralController>().currentTeacherModel));
      }
      Get.find<GeneralController>().update();

      print(
          "${Get.find<GeneralController>().storageBox.read('userData')} Response Data 2");
      // Get.find<EditUserProfileController>().update();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Profile Updated Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                Get.back();
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    } else {
      print("$response False Response");
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Failed",
              titleColor: AppColors.customDialogErrorColor,
              descriptions: '${response["message"]}',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    }
  } else if (!responseCheck) {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Failed",
            titleColor: AppColors.customDialogErrorColor,
            descriptions: '${response["message"]}!',
            text: "Ok",
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

editUserProfileImageRepo(
    String? firstName,
    String? lastName,
    String? userName,
    String? description,
    String? addressLine1,
    String? addressLine2,
    String? zipCode,
    dynamic teacherCategories,
    dynamic languages,
    dynamic tags,
    File? file1,
    File? file2,
    ) async {
  dio_instance.FormData formData =
  dio_instance.FormData.fromMap(<String, dynamic>{
    "logged-in-as": "teacher",
    'first_name': firstName,
    'last_name': lastName,
    "user_name": userName,
    "description": description,
    "address_line_1": addressLine1,
    "address_line_2": addressLine2,
    "zip_code": zipCode,
    "teacher_categories[]": teacherCategories,
    "languages[]": languages,
    "tags[]": tags,
    'image': await dio_instance.MultipartFile.fromFile(
      file1!.path,
    ),
    'icon': await dio_instance.MultipartFile.fromFile(
      file2!.path,
    )
  });
  dio_instance.Dio dio = dio_instance.Dio();
  setAcceptHeader(dio);
  setContentHeader(dio);
  setCustomHeader(dio, 'Authorization',
      'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');
  setCustomHeader(dio, 'Content-Type', 'application/json');
  log('postData.... ${formData.fields}');

  dio_instance.Response response;

  try {
    response = await dio.post(
      editUserProfileURL,
      data: formData,
      options: Options(
        followRedirects: false, // default is true, change to false
        maxRedirects: 0, // set to 0
        contentType:
        "${ContentType.parse("application/x-www-form-urlencoded")}",
      ),
    );
    log("${response} Image Repo Response");

    if (response.statusCode == 200) {
      log("${response}Image Repo Response 2");
      if (response.data['success'].toString() == 'true') {
        getMethod(Get.context!, getLoggedInUserUrl, {'login_as': "teacher"},
            true, loggedInUserRepo);
        Get.find<GeneralController>().currentTeacherModel =
            GetLoggedInTeacherDataModel.fromJson(response.data['data']);
        Get.find<GeneralController>().update();
        // Get.find<GeneralController>().storageBox.write('userData',
        //     jsonEncode(Get.find<GeneralController>().currentTeacherModel));
        log("${response.data['data']}Image Repo Response 3");
        showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: 'Succes',
                titleColor: AppColors.customDialogSuccessColor,
                descriptions: 'Profile Updated Successfully',
                text: 'Ok',
                functionCall: () {
                  Navigator.pop(context);
                  Get.back();
                },
                img: 'assets/icons/dialog_success.png',
              );
            });
        Get.find<GeneralController>().updateFormLoaderController(false);
      } else {
        Get.find<EditProfileController>().profileImage = null;
        showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: 'Failed',
                titleColor: AppColors.customDialogErrorColor,
                descriptions: '${response.data["message"]}',
                text: 'Ok',
                functionCall: () {
                  Navigator.pop(context);
                },
                img: 'assets/icons/dialog_error.png',
              );
            });
        Get.find<GeneralController>().updateFormLoaderController(false);
      }
    } else {
      Get.find<EditProfileController>().profileImage = null;
      Get.find<GeneralController>().updateFormLoaderController(false);
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Failed',
              titleColor: AppColors.customDialogErrorColor,
              descriptions: '${response.data["message"]}',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log("${e} Image Cath Response");
    Get.find<EditProfileController>().profileImage = null;
    Get.find<GeneralController>().updateFormLoaderController(false);
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Failed',
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Kindly Fill the Basic Information',
            text: 'Ok',
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
    log('Exception..${e.response}');
  }
}

// Education Profile
editUserProfileEducationDataRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response['success'].toString() == 'true') {
      print("${response['data']} Response Data 1");
      log("${Get.find<GeneralController>().storageBox.read('userData')} Response Data 1.1");
      log("${jsonEncode(Get.find<GeneralController>().currentTeacherModel)} Response Data 1.2");
      log("${jsonEncode(GetLoggedInTeacherDataModel.fromJson(response['data']))} Response Data 1.3");
      Get.find<GeneralController>().currentTeacherModel =
          GetLoggedInTeacherDataModel.fromJson(response);
      if (Get.find<GeneralController>().storageBox.hasData('userData')) {
        Get.find<GeneralController>().currentTeacherModel =
            GetLoggedInTeacherDataModel.fromJson(response['data']);
        Get.find<GeneralController>().storageBox.write('userData',
            jsonEncode(Get.find<GeneralController>().currentTeacherModel));
      }
      Get.find<GeneralController>().update();

      print(
          "${Get.find<GeneralController>().storageBox.read('userData')} Response Data 2");
      // Get.find<EditUserProfileController>().update();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Profile Updated Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                Get.back();
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    } else {
      print("$response False Response");
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Failed",
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Inside Repo 1 Popup 1',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    }
  } else if (!responseCheck) {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Failed",
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Inside Repo 1 Popup 2',
            text: "Ok",
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

// Certificate Profile
editUserProfileCertificateDataRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response['success'].toString() == 'true') {
      Get.find<EditProfileController>().teacherProfileCertificateModel =
          TeacherProfileCertificateModel.fromJson(response);

      // Get.find<EditProfileController>().currentTeacherModel =
      //     GetLoggedInTeacherDataModel.fromJson(response['data']);

      print(
          "${Get.find<GeneralController>().storageBox.read('userData')} Response Data 2");
      // Get.find<EditUserProfileController>().update();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Certificate Updated Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                Get.back();
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    } else {
      print("$response False Response");
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Failed",
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Inside Repo 1 Popup 1',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    }
  } else if (!responseCheck) {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Failed",
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Inside Repo 1 Popup 2',
            text: "Ok",
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

// Delete Certificate Profile
deleteUserProfileCertificateDataRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response['success'].toString() == 'true') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Certificate Deleted Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                Get.back();
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    } else {
      print("$response False Response");
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Failed",
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Please Try Again!',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    }

    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

addUserProfileCertificateDataRepo(
    String? name,
    description,
    File? file1,
    int? isActive,
    ) async {
  dio_instance.FormData formData =
  dio_instance.FormData.fromMap(<String, dynamic>{
    'name': name,
    'description': description,
    'image': await dio_instance.MultipartFile.fromFile(file1!.path),
    'is_active': 1,
  });
  dio_instance.Dio dio = dio_instance.Dio();
  setAcceptHeader(dio);
  setContentHeader(dio);
  setCustomHeader(dio, 'Authorization',
      'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');
  setCustomHeader(dio, 'Content-Type', 'application/json');
  log('postData.... ${formData.fields}');

  dio_instance.Response response;

  try {
    response = await dio.post(
      addEditUserProfileCertificateURL,
      data: formData,
      options: Options(
        followRedirects: false, // default is true, change to false
        maxRedirects: 0, // set to 0
        // contentType: ContentType.parse("application/x-www-form-urlencoded"),
      ),
    );
    log("${response} Response");

    if (response.statusCode == 200) {
      if (response.data['success'].toString() == 'true') {
        Get.find<EditProfileController>().teacherProfileCertificateModel =
            TeacherProfileCertificateModel.fromJson(response.data);
        showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: 'Succes',
                titleColor: AppColors.customDialogSuccessColor,
                descriptions: 'Profile Updated Successfully',
                text: 'Ok',
                functionCall: () {
                  Navigator.pop(context);
                  Get.back();
                },
                img: 'assets/icons/dialog_success.png',
              );
            });
        Get.find<GeneralController>().updateFormLoaderController(false);
      } else {
        showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: 'Failed',
                titleColor: AppColors.customDialogErrorColor,
                descriptions: 'Inside Repo Popup 1',
                text: 'Ok',
                functionCall: () {
                  Navigator.pop(context);
                },
                img: 'assets/icons/dialog_error.png',
              );
            });
        Get.find<GeneralController>().updateFormLoaderController(false);
      }
    } else {
      Get.find<GeneralController>().updateFormLoaderController(false);
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Failed',
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Inside Repo Popup 2',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log("${e} Image Cath Response");
    Get.find<GeneralController>().updateFormLoaderController(false);
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Failed',
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Inside Repo Popup 3',
            text: 'Ok',
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
    log('Exception..${e.response}');
  }
}

// Delete Experience Profile
deleteUserProfileExperienceDataRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response['success'].toString() == 'true') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Experience Deleted Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                Get.back();
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    } else {
      print("$response False Response");
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Failed",
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Please Try Again!',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    }

    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

addUserProfileExperienceDataRepo(
    String? companyName,
    String? description,
    dynamic from,
    dynamic to,
    File? file1,
    int? isActive,
    ) async {
  dio_instance.FormData formData =
  dio_instance.FormData.fromMap(<String, dynamic>{
    'company': companyName,
    'description': description,
    'from': from,
    'to': to,
    'file': await dio_instance.MultipartFile.fromFile(file1!.path),
    'is_active': 1,
  });
  dio_instance.Dio dio = dio_instance.Dio();
  setAcceptHeader(dio);
  setContentHeader(dio);
  setCustomHeader(dio, 'Authorization',
      'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');
  setCustomHeader(dio, 'Content-Type', 'application/json');
  log('postData.... ${formData.fields}');

  dio_instance.Response response;

  try {
    response = await dio.post(
      addEditUserProfileExperienceURL,
      data: formData,
      options: Options(
        followRedirects: false, // default is true, change to false
        maxRedirects: 0, // set to 0
        // contentType: ContentType.parse("application/x-www-form-urlencoded"),
      ),
    );
    log("${response} Response");

    if (response.statusCode == 200) {
      if (response.data['success'].toString() == 'true') {
        Get.find<EditProfileController>().teacherProfileExperienceModel =
            TeacherProfileExperienceModel.fromJson(response.data);
        showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: 'Succes',
                titleColor: AppColors.customDialogSuccessColor,
                descriptions: 'Profile Updated Successfully',
                text: 'Ok',
                functionCall: () {
                  Navigator.pop(context);
                  Get.back();
                },
                img: 'assets/icons/dialog_success.png',
              );
            });
        Get.find<GeneralController>().updateFormLoaderController(false);
      } else {
        showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: 'Failed',
                titleColor: AppColors.customDialogErrorColor,
                descriptions: 'Inside Repo Popup 1',
                text: 'Ok',
                functionCall: () {
                  Navigator.pop(context);
                },
                img: 'assets/icons/dialog_error.png',
              );
            });
        Get.find<GeneralController>().updateFormLoaderController(false);
      }
    } else {
      Get.find<GeneralController>().updateFormLoaderController(false);

      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Failed',
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Inside Repo Popup 2',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log("${e} Image Cath Response");
    Get.find<GeneralController>().updateFormLoaderController(false);
    String errorMessage = 'Something went wrong. Please try again.';
    try {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          errorMessage = data['message']?.toString() ?? errorMessage;
        }
      }
    } catch (_) {}
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Failed',
            titleColor: AppColors.customDialogErrorColor,
            descriptions: errorMessage,
            text: 'Ok',
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
    log('Exception..${e.response}');
  }
}

// Delete Education Profile
deleteUserProfileEducationDataRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response['success'].toString() == 'true') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Education Deleted Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                Get.back();
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    } else {
      print("$response False Response");
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Failed",
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Please Try Again!',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    }

    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

addUserProfileEducationDataRepo(
    String? instituteName,
    String? description,
    String? from,
    String? to,
    String? degree,
    String? subject,
    File? file1,
    int? isActive,
    ) async {
  dio_instance.FormData formData =
  dio_instance.FormData.fromMap(<String, dynamic>{
    'institute': instituteName,
    'description': description,
    'from': from,
    'to': to,
    'degree': degree,
    'subject': subject,
    'file': await dio_instance.MultipartFile.fromFile(file1!.path),
    'is_active': 1,
  });
  dio_instance.Dio dio = dio_instance.Dio();
  setAcceptHeader(dio);
  setContentHeader(dio);
  setCustomHeader(dio, 'Authorization',
      'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');
  setCustomHeader(dio, 'Content-Type', 'application/json');
  log('postData.... ${formData.fields}');
  dio_instance.Response response;

  try {
    response = await dio.post(
      addEditUserProfileEducationURL,
      data: formData,
      options: Options(
        followRedirects: false, // default is true, change to false
        maxRedirects: 0, // set to 0
        // contentType: ContentType.parse("application/x-www-form-urlencoded"),
      ),
    );
    log("${response} Response");

    if (response.statusCode == 200) {
      if (response.data['success'].toString() == 'true') {
        Get.find<EditProfileController>().teacherProfileEducationModel =
            TeacherProfileEducationModel.fromJson(response.data);
        showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: 'Succes',
                titleColor: AppColors.customDialogSuccessColor,
                descriptions: 'Profile Updated Successfully',
                text: 'Ok',
                functionCall: () {
                  Navigator.pop(context);
                  Get.back();
                },
                img: 'assets/icons/dialog_success.png',
              );
            });
        Get.find<GeneralController>().updateFormLoaderController(false);
      } else {
        showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: 'Failed',
                titleColor: AppColors.customDialogErrorColor,
                descriptions: 'Inside Repo Popup 1',
                text: 'Ok',
                functionCall: () {
                  Navigator.pop(context);
                },
                img: 'assets/icons/dialog_error.png',
              );
            });
        Get.find<GeneralController>().updateFormLoaderController(false);
      }
    } else {
      Get.find<GeneralController>().updateFormLoaderController(false);
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Failed',
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Inside Repo Popup 2',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log("${e} Image Cath Response");
    Get.find<GeneralController>().updateFormLoaderController(false);
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Failed',
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Inside Repo Popup 3',
            text: 'Ok',
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
    log('Exception..${e.response}');
  }
}

// Delete Podcast Profile
deleteUserProfilePodcastDataRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    if (response['success'].toString() == 'true') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Podcast Deleted Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                getMethod(context, getUserProfilePodcastsURL, null, true, getTeacherPodcastsRepo);
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    } else {
      print("$response False Response");
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Failed",
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Please Try Again!',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    }

    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

addUserProfilePodcastDataRepo(
    String? name,
    String? description,
    String? fileType,
    String? linkType,
    String? categoryId,
    dynamic tagIds,
    String? fileURL,
    File? file1,
    File? audioFile,
    File? videoFile,
    int? isActive,
    ) async {
  final Map<String, dynamic> formFields = {
    'name': name,
    'description': description,
    'file_type': fileType,
    'link_type': linkType,
    'podcast_category_id': categoryId,
    'tag_ids[]': tagIds,
    'file_url': fileURL,
    'is_active': 1,
  };
  if (file1 != null) {
    formFields['image'] = await dio_instance.MultipartFile.fromFile(file1.path);
  }
  if (audioFile != null) {
    formFields['audio'] = await dio_instance.MultipartFile.fromFile(audioFile.path);
  }
  if (videoFile != null) {
    formFields['video'] = await dio_instance.MultipartFile.fromFile(videoFile.path);
  }
  dio_instance.FormData formData = dio_instance.FormData.fromMap(formFields);
  dio_instance.Dio dio = dio_instance.Dio();
  setAcceptHeader(dio);
  setContentHeader(dio);
  setCustomHeader(dio, 'Authorization',
      'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');
  setCustomHeader(dio, 'Content-Type', 'application/json');
  log('postData.... ${formData.fields}');
  dio_instance.Response response;

  try {
    response = await dio.post(
      addEditUserProfilePodcastURL,
      data: formData,
      options: Options(
        followRedirects: false,
        maxRedirects: 0,
      ),
    );
    log("${response} Response");

    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: 'Media added successfully',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
                getMethod(Get.context!, getUserProfilePodcastsURL, null, true, getTeacherPodcastsRepo);
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
      Get.find<GeneralController>().updateFormLoaderController(false);
    } else {
      Get.find<GeneralController>().updateFormLoaderController(false);
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Failed',
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Failed to add media. Please try again.',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log("${e} Image Cath Response");
    Get.find<GeneralController>().updateFormLoaderController(false);
    String errorMessage = 'Something went wrong. Please try again.';
    try {
      if (e.response?.data != null) {
        final data = e.response!.data;
        if (data is Map) {
          errorMessage = data['message']?.toString() ?? errorMessage;
        }
      }
    } catch (_) {}
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Failed',
            titleColor: AppColors.customDialogErrorColor,
            descriptions: errorMessage,
            text: 'Ok',
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
    log('Exception..${e.response}');
  }
}

addUserProfileEventDataRepo(
    String? name,
    String? description,
    String? categoryId,
    dynamic tagIds,
    String? startDate,
    String? endDate,
    String? addressLine1,
    String? addressLine2,
    File? file1,
    ) async {
  dio_instance.FormData formData = dio_instance.FormData.fromMap(<String, dynamic>{
    'name': name,
    'description': description,
    'event_category_id': categoryId,
    'tag_ids[]': tagIds,
    'start_date': startDate,
    'end_date': endDate,
    'address_line_1': addressLine1,
    'address_line_2': addressLine2,
    if (file1 != null) 'image': await dio_instance.MultipartFile.fromFile(file1.path),
    'is_active': 1,
  });
  dio_instance.Dio dio = dio_instance.Dio();
  setAcceptHeader(dio);
  setContentHeader(dio);
  setCustomHeader(dio, 'Authorization', 'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');

  try {
    final response = await dio.post(addEditUserProfileEventURL, data: formData);
    Get.find<GeneralController>().updateFormLoaderController(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Event Created Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                getMethod(Get.context!, getUserProfileEventsURL, null, true, getTeacherEventsRepo);
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log('Exception..$e');
    Get.find<GeneralController>().updateFormLoaderController(false);
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Failed',
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Failed to create event. Please try again.',
            text: 'Ok',
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}

addUserProfileBlogDataRepo(
    String? name,
    String? description,
    String? categoryId,
    dynamic tagIds,
    File? file1,
    ) async {
  dio_instance.FormData formData = dio_instance.FormData.fromMap(<String, dynamic>{
    'name': name,
    'description': description,
    'blog_category_id': categoryId,
    'tag_ids[]': tagIds,
    'image': await dio_instance.MultipartFile.fromFile(file1!.path),
    'is_active': 1,
  });
  dio_instance.Dio dio = dio_instance.Dio();
  setCustomHeader(dio, 'Authorization', 'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');

  try {
    final response = await dio.post(addEditUserProfileBlogURL, data: formData);
    Get.find<GeneralController>().updateFormLoaderController(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: 'Blog Post Created Successfully',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
                getMethod(Get.context!, getUserProfileBlogsURL, null, true, getTeacherBlogsRepo);
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
    } else {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Failed',
              titleColor: AppColors.customDialogErrorColor,
              descriptions: 'Failed to create blog post. Please try again.',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log('Exception..$e');
    Get.find<GeneralController>().updateFormLoaderController(false);
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Failed',
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Failed to create blog post. Please try again.',
            text: 'Ok',
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}

addUserProfileServiceDataRepo(
    String? name,
    String? description,
    String? categoryId,
    dynamic tagIds,
    String? price,
    File? file1,
    ) async {
  dio_instance.FormData formData = dio_instance.FormData.fromMap(<String, dynamic>{
    'name': name,
    'description': description,
    'service_category_id': categoryId,
    'tag_ids[]': tagIds,
    'price': price,
    'image': await dio_instance.MultipartFile.fromFile(file1!.path),
    'is_active': 1,
  });
  dio_instance.Dio dio = dio_instance.Dio();
  setCustomHeader(dio, 'Authorization', 'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');

  try {
    dio_instance.Response response = await dio.post(addEditUserProfileServiceURL, data: formData);
    Get.find<GeneralController>().updateFormLoaderController(false);
    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: 'Service Added Successfully',
              text: 'Ok',
              functionCall: () {
                Navigator.pop(context);
                getMethod(Get.context!, getUserProfileServicesURL, null, true,
                    getTeacherServiceRepo);
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log('Exception..$e');
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}

addUserProfileBroadcastDataRepo(
    String? name,
    String? description,
    String? categoryId,
    dynamic tagIds,
    String? fileType,
    String? fileURL,
    File? file1,
    ) async {
  dio_instance.FormData formData = dio_instance.FormData.fromMap(<String, dynamic>{
    'name': name,
    'description': description,
    'broadcast_category_id': categoryId,
    'tag_ids[]': tagIds,
    'file_type': fileType,
    'file_url': fileURL,
    'image': await dio_instance.MultipartFile.fromFile(file1!.path),
    'is_active': 1,
  });
  dio_instance.Dio dio = dio_instance.Dio();
  setCustomHeader(dio, 'Authorization', 'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');

  try {
    final response = await dio.post(addEditUserProfileBroadcastURL, data: formData);
    Get.find<GeneralController>().updateFormLoaderController(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Media Created Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                getMethod(Get.context!, getUserProfileBroadcastsURL, null, true, getTeacherBroadcastsRepo);
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log('Exception..$e');
    Get.find<GeneralController>().updateFormLoaderController(false);
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Failed',
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Failed to create media. Please try again.',
            text: "Ok",
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}

addUserProfileArchiveDataRepo(
    String? name,
    String? description,
    String? categoryId,
    dynamic tagIds,
    String? fileType,
    String? fileURL,
    File? file1,
    ) async {
  dio_instance.FormData formData = dio_instance.FormData.fromMap(<String, dynamic>{
    'name': name,
    'description': description,
    'archive_category_id': categoryId,
    'tag_ids[]': tagIds,
    'file_type': fileType,
    'file_url': fileURL,
    'image': file1 != null ? await dio_instance.MultipartFile.fromFile(file1.path) : null,
    'is_active': 1,
  });
  dio_instance.Dio dio = dio_instance.Dio();
  setCustomHeader(dio, 'Authorization', 'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
  setCustomHeader(dio, 'logged-in-as', 'teacher');

  try {
    final response = await dio.post(addEditUserProfileArchiveURL, data: formData);
    Get.find<GeneralController>().updateFormLoaderController(false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: 'Success!',
              titleColor: AppColors.customDialogSuccessColor,
              descriptions: "Course Created Successfully",
              text: "Ok",
              functionCall: () {
                Navigator.pop(context);
                getMethod(Get.context!, getUserProfileArchivesURL, null, true, getTeacherArchivesRepo);
              },
              img: 'assets/icons/dialog_success.png',
            );
          });
    }
  } on dio_instance.DioException catch (e) {
    log('Exception..$e');
    Get.find<GeneralController>().updateFormLoaderController(false);
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: 'Failed',
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Failed to create course. Please try again.',
            text: "Ok",
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}

deleteTeacherArchiveRepo(
    BuildContext context,
    String? url,
    dynamic payload,
    ) async {
  log("Deleting archive from $url");
  Get.find<GeneralController>().updateFormLoaderController(true);

  deleteMethod(context, url!, payload, true, (ctx, success, data) {
    Get.find<GeneralController>().updateFormLoaderController(false);
    if (success) {
      getMethod(Get.context!, getUserProfileArchivesURL, null, true, getTeacherArchivesRepo);
      Get.snackbar('Success', 'Course Deleted Successfully',
          backgroundColor: AppColors.primaryColor, colorText: AppColors.white);
    } else {
      Get.snackbar('Error', 'Failed to delete course',
          backgroundColor: AppColors.carrotRed, colorText: AppColors.white);
    }
  });
}

