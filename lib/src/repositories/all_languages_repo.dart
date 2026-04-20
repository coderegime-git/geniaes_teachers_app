import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/all_languages_controller.dart';
import '../controllers/general_controller.dart';
import '../models/all_languages_model.dart';

getAllLanguagesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<GetAllLanguagesController>().getAllLanguagesModel =
        GetAllLanguagesModel.fromJson(response);
    print('Get All Languages $response');

    log("${Get.find<GetAllLanguagesController>().getAllLanguagesModel.data!.length.toString()} Total Languages Length");

    Get.find<GeneralController>().localeList.clear();
    for (var item in response['data']) {
      Get.find<GeneralController>().localeList.add(Language.fromJson(item));
    }
    Get.find<GeneralController>().checkLanguage();
    Get.updateLocale(Locale(
        '${Get.find<GeneralController>().storageBox.read('languageCode')}',
        '${Get.find<GeneralController>().storageBox.read('countryCode')}'));
    print(
        '${Get.find<GeneralController>().localeList.length} Get LocaleList Length');

    // Get.find<GeneralController>().updateFormLoaderController(false);
    Get.find<GetAllLanguagesController>().updateAllLanguagesLoader(true);
  } else if (!responseCheck) {
    Get.find<GeneralController>().localeList.clear();
    Get.find<GetAllLanguagesController>().updateAllLanguagesLoader(false);
    print('Get All Languages');
  }
}
