import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart' as dio_instance;
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

import 'logged_in_user_repo.dart';

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
  } on dio_instance.DioError catch (e) {
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
  } on dio_instance.DioError catch (e) {
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
  } on dio_instance.DioError catch (e) {
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
  } on dio_instance.DioError catch (e) {
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

addUserProfilePodcastDataRepo(
  String? name,
  String? description,
  String? fileType,
  String? linkType,
  String? tagId,
  String? fileURL,
  File? file1,
  File? audioFile,
  File? videoFile,
  int? isActive,
) async {
  dio_instance.FormData formData =
      dio_instance.FormData.fromMap(<String, dynamic>{
    'name': name,
    'description': description,
    'file_type': fileType,
    'link_type': linkType,
    'tag_ids[]': tagId,
    'file_url': fileURL,
    'file': await dio_instance.MultipartFile.fromFile(file1!.path),
    'audio': await dio_instance.MultipartFile.fromFile(audioFile!.path),
    'video': await dio_instance.MultipartFile.fromFile(videoFile!.path),
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
      addEditUserProfilePodcastURL,
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
  } on dio_instance.DioError catch (e) {
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
