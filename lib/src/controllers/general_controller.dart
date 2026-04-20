import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import 'package:resize/resize.dart';

import '../config/app_colors.dart';
import '../config/app_font.dart';
import '../config/app_text_styles.dart';
import '../models/teacher_booked_services_model.dart';
import '../models/teacher_appointment_history_model.dart';
import '../models/logged_in_teacher_model.dart';
import '../models/response_model.dart';
import '../routes.dart';
import '../screens/agora_call/get_agora_token_model.dart';
import '../widgets/custom_dialog.dart';
import 'all_settings_controller.dart';

class GeneralController extends GetxController {
  GetStorage storageBox = GetStorage();
  int bottomNavIndex = 1;
  bool formLoaderController = false;

  updateFormLoaderController(bool newValue) {
    formLoaderController = newValue;
    update();
  }

  bool callLoaderController = false;

  updateCallLoaderController(bool newValue) {
    callLoaderController = newValue;
    update();
  }

  bool appointmentStatusLoaderController = false;

  updateAppointmentStatusLoaderController(bool newValue) {
    appointmentStatusLoaderController = newValue;
    update();
  }

  bool bookedServiceStatusLoaderController = false;

  updateBookedServiceStatusLoaderController(bool newValue) {
    bookedServiceStatusLoaderController = newValue;
    update();
  }

  ///---appbar-open
  String? appBarSelectedCountryCode = '+92';

  updateAppBarSelectedCountryCode(String? newValue) {
    appBarSelectedCountryCode = newValue;
    update();
  }

  ///---appbar-close

  ///--focus-out
  focusOut(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

// Get Generic Response Model
  GetResponseModel genericResponseModel = GetResponseModel();

  GetLoggedInTeacherDataModel?
      currentTeacherModel; //  for saving all-generic-app-data

  ///---random-string-open
  String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  math.Random rnd = math.Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  int callerType = 2;

  updateCallerType(int i) {
    callerType = i;
    update();
  }

  // isSubscriptionEnabled() {
  //   return Get.find<GetAllSettingsController>()
  //           .getAllSettingsModel
  //           .data!
  //           .commissionType! ==
  //       'subscription_base';
  // }

  // isCommissionEnabled() {
  //   return Get.find<GetAllSettingsController>()
  //           .getAllSettingsModel
  //           .data!
  //           .commissionType! ==
  //       'commission_base';
  // }

  Map<String, dynamic>? appointmentObject;

  // Teacher Modules
  List<String>? teacherModules;

  GetAgoraTokenModel getAgoraTokenModel = GetAgoraTokenModel();
  bool? goForCall = true;

  updateGoForCall(bool? newValue) {
    goForCall = newValue;
    update();
  }

  String? channelForCall;
  String? tokenForCall;

  updateTokenForCall(String? newValueToken) {
    tokenForCall = newValueToken;
    update();
  }

  updateChannelForCall(String? newValueChannel) {
    channelForCall = newValueChannel;
    update();
  }

  int? userIdForSendNotification;

  updateUserIdForSendNotification(int? newValue) {
    userIdForSendNotification = newValue;
    update();
  }

  int? appointmentIdForSendNotification;

  updateAppointmentIdForSendNotification(int? newValue) {
    appointmentIdForSendNotification = newValue;
    update();
  }

  dynamic displayDateTime(dateandTime) {
    return DateFormat('dd.MM.yyyy HH:mm')
        .format(DateTime.parse(dateandTime).toLocal());
  }

  dynamic displayDate(date) {
    return DateFormat('dd.MM.yyyy').format(DateTime.parse(date).toLocal());
  }

  String? notificationTitle;
  String? notificationBody;
  String? notificationRouteApp;
  String? notificationRouteWeb;
  String? sound;

  updateNotificationBody(String? newTitle, String? newBody, String? newRouteApp,
      String? newRouteWeb, String? newSound) {
    notificationTitle = newTitle;
    notificationBody = newBody;
    notificationRouteApp = newRouteApp;
    notificationRouteWeb = newRouteWeb;
    sound = newSound;
    update();
  }

  List<Language> localeList = [];
  Language? selectedLocale;

  updateSelectedLocale(Language? newValue) {
    selectedLocale = newValue;
    update();
  }

  checkLanguage() {
    if (storageBox.hasData('languageIndex')) {
      updateSelectedLocale(
          localeList[int.parse(storageBox.read('languageIndex').toString())]);
    } else {
      storageBox.write('languageCode', localeList[0].languageCode);
      storageBox.write('countryCode', localeList[0].countryCode);
      updateSelectedLocale(localeList[0]);
    }
  }

  ///------------------------------- pagination-check
  bool getPaginationProgressCheck = false;

  changeGetPaginationProgressCheck(bool value) {
    getPaginationProgressCheck = value;
    update();
  }

  //-----------------------------selected Appointment History for detail view
  TeacherAppointmentHistoryModel selectedAppointmentHistoryForView =
      TeacherAppointmentHistoryModel();
  updateSelectedAppointmentHistoryForView(
    TeacherAppointmentHistoryModel newValue,
  ) {
    selectedAppointmentHistoryForView = newValue;
    update();
  }

  //-----------------------------selected Booked Service for detail view
  TeacherBookedServiceModel selectedBookedServiceForView =
      TeacherBookedServiceModel();
  updateSelectedBookedServicesForView(
    TeacherBookedServiceModel newValue,
  ) {
    selectedBookedServiceForView = newValue;
    update();
  }

  ///-------------------------------server-check
  bool serverErrorCheck = true;

  changeServerErrorCheck(bool value) {
    serverErrorCheck = value;
    update();
  }

  ///------------------------------- loader-check
  bool loaderCheck = false;

  changeLoaderCheck(bool value) {
    loaderCheck = value;
    update();
  }

  showSnackBar(String content) {
    return SnackBar(
      content: Text(
        content,
        style: TextStyle(
          fontFamily: AppFont.primaryFontFamily,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
      backgroundColor: (AppColors.secondaryColor),
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      // action: SnackBarAction(
      //   label: 'dismiss',
      //   onPressed: () {},
      // ),
      margin: const EdgeInsets.all(8),
    );
  }

  //---------------- logged-in-user
  // ignore: prefer_typing_uninitialized_variables
  // var signInUserToken;

  showMessageDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: "Please Sign In First",
          titleColor: AppColors.customDialogInfoColor,
          descriptions: '',
          text: "Ok",
          functionCall: () {
            Get.back();
            Get.toNamed(PageRoutes.signinScreen);
          },
          img: 'assets/icons/error.png',
        );
      },
    );
  }

  customDropDownDialogForLocale(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 3,
                            blurRadius: 9,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "LanguageConstant.selectLanguage.tr",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.sp,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .3,
                        child: ListView(
                          children: List.generate(localeList.length, (index) {
                            return InkWell(
                              onTap: () {
                                storageBox.write('languageCode',
                                    localeList[index].languageCode);
                                storageBox.write('countryCode',
                                    localeList[index].countryCode);
                                storageBox.write('languageIndex', index);
                                selectedLocale = localeList[index];
                                var locale = Locale(
                                    localeList[index].languageCode,
                                    localeList[index].countryCode);
                                Get.updateLocale(locale);
                                update();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      localeList[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      localeList[index].image,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  String? inAppWebService;
  String? notificationMenteeId, notificationFee;
}

class Language {
  final num id;
  final String name;
  final String description;
  final String languageCode;
  final String image;
  final String countryCode;
  final num isDefault;
  final num isActive;
  final String createdAt;
  final String updatedAt;
  final dynamic deletedAt;

  Language(
      this.id,
      this.name,
      this.description,
      this.languageCode,
      this.image,
      this.countryCode,
      this.isDefault,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt);

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      json['id'] ?? "",
      json['name'] ?? "",
      json['description'] ?? "",
      json['code'] ?? "",
      json['image'] ?? "", // Use an empty string if "flag" is null
      json['country_code'] ??
          "", // Use an empty string if "country_code" is null
      json['is_default'] ?? "",
      json['is_active'] ?? "",
      json['created_at'] ?? "",
      json['updated_at'] ?? "",
      json['deleted_at'] ?? "",
    );
  }
}
