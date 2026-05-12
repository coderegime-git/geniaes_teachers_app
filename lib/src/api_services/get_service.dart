import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio_instance;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../widgets/custom_dialog.dart';
import 'header.dart';
import 'logic.dart';

getMethod(BuildContext context, String apiUrl, dynamic queryData,
    bool addAuthHeader, Function executionMethod) async {
  dio_instance.Response response;
  dio_instance.Dio dio = dio_instance.Dio();

  // Always set Accept and Content-Type so Laravel returns JSON, not HTML
  setCustomHeader(dio, 'Accept', 'application/json');
  setCustomHeader(dio, 'Content-Type', 'application/json');

  if (addAuthHeader &&
      Get.find<GeneralController>().storageBox.hasData('authToken')) {
    setCustomHeader(dio, 'Authorization',
        'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}');
    setCustomHeader(dio, 'logged-in-as', 'teacher');
  }

  log('Get Method Api $apiUrl ---->>>>');
  log('queryData $queryData ---->>>>');
  log('Get Token ${Get.find<GeneralController>().storageBox.read('authToken')} ---->>>>');

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      Get.find<ApiController>().changeInternetCheckerState(true);
      try {
        response = await dio.get(apiUrl, queryParameters: queryData);

        if (response.statusCode == 200) {
          log('getApi $apiUrl ---->>>>  ${response.data}');

          // Guard: if server returned HTML instead of JSON (e.g. Laravel
          // redirected to /login because token was rejected), skip execution
          // so the repository does not crash trying to cast String to Map.
          if (_isHtmlResponse(response.data)) {
            log('ERROR: API returned HTML for $apiUrl — token may be invalid or missing Accept header.');
            executionMethod(context, false, <String, dynamic>{
              'success': false,
              'message': 'Unexpected HTML response from server.',
            });
            return;
          }

          executionMethod(context, true, response.data);
          return;
        }

        log('getApi $apiUrl ---->>>>  ${response.data}');

        if (_isHtmlResponse(response.data)) {
          log('ERROR: Non-200 HTML response for $apiUrl');
          executionMethod(context, false, <String, dynamic>{
            'success': false,
            'message': 'Unexpected HTML response from server.',
          });
          return;
        }

        executionMethod(context, false, response.data);
      } on dio_instance.DioError catch (e) {
        log('Dio Error     $apiUrl $queryData ---->>>>${e.response}');

        if (e.response != null) {
          final errorData = e.response!.data;
          if (_isHtmlResponse(errorData)) {
            log('ERROR: DioError HTML response for $apiUrl');
            executionMethod(context, false, <String, dynamic>{
              'success': false,
              'message': 'Unexpected HTML response from server.',
            });
          } else {
            executionMethod(context, false, errorData);
          }
        } else {
          executionMethod(context, false, <String, dynamic>{
            'success': false,
            'message': 'Network error occurred.',
          });
        }
      }
    }
  } on SocketException catch (_) {
    Get.find<GeneralController>().updateFormLoaderController(false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Please Try Again",
            titleColor: AppColors.customDialogErrorColor,
            descriptions: 'Internet Not Connected!',
            text: "Ok",
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
    Get.find<ApiController>().changeInternetCheckerState(false);
  }
}

/// Returns true if the response body is an HTML page rather than JSON.
/// This happens when Laravel redirects to /login because the request
/// did not include a valid Bearer token or Accept: application/json header.
bool _isHtmlResponse(dynamic data) {
  if (data is String) {
    final trimmed = data.trimLeft();
    return trimmed.startsWith('<!DOCTYPE') ||
        trimmed.startsWith('<!doctype') ||
        trimmed.startsWith('<html');
  }
  return false;
}