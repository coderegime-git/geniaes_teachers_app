import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api_services/post_service.dart';
import '../../api_services/urls.dart';
import '../../controllers/general_controller.dart';
import 'get_agora_token_model.dart';

// ─── getAgoraTokenRepo ────────────────────────────────────────────────────────
/// Called when the teacher fetches the Agora token from the backend.
/// Saves the token into GeneralController so the call screens can use it.
getAgoraTokenRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<GeneralController>().getAgoraTokenModel =
        GetAgoraTokenModel.fromJson(response);

    if (Get.find<GeneralController>().getAgoraTokenModel.success == true) {
      Get.find<GeneralController>().updateFormLoaderController(false);
      Get.find<GeneralController>().updateCallerType(1);

      // data is the token string directly (teacher model).
      Get.find<GeneralController>().updateTokenForCall(
          Get.find<GeneralController>().getAgoraTokenModel.data!);

      log('getAgoraTokenRepo: token saved successfully');
    } else {
      Get.find<GeneralController>().updateFormLoaderController(false);
      log('getAgoraTokenRepo: success=false – ${response['message']}');
    }
  } else {
    Get.find<GeneralController>().updateFormLoaderController(false);
    log('getAgoraTokenRepo: request failed – $response');
  }
}

// ─── makeAgoraCallRepo ────────────────────────────────────────────────────────
/// Called once the call screen is open. Sends an FCM push notification to the
/// student via the backend, carrying channel_name, token and call_type so the
/// student app can open the correct screen.
makeAgoraCallRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (!responseCheck) {
    log('makeAgoraCallRepo: makeAgoraCall API failed – $response');
  }
  // Even if makeAgoraCall fails or succeeds, we should explicitly send the notification using the new route.
  sendCallNotificationToStudent(context);
}

void sendCallNotificationToStudent(BuildContext context) {
  final gc = Get.find<GeneralController>();

  // appointmentObject is set in AppointmentDetailScreen.initState()
  final appt          = gc.appointmentObject!;
  final appointmentId = appt['id'].toString();
  final channelName   = gc.channelForCall!;
  final token         = gc.tokenForCall ?? '';
  final typeId        = appt['appointment_type_id'];         // 1=video,2=audio,3=chat

  // Derive human-readable call type label for the notification title.
  final callLabel = typeId == 1
      ? 'Video Call'
      : typeId == 2
          ? 'Audio Call'
          : 'Live Chat';

  postMethod(
      context,
      sendCallNotification,
      {
        'title': '$callLabel from Teacher',
        'body': 'Please join the $callLabel. Tap to open.',
        'deep_link':
            '/appointment_log/detail/$appointmentId'
            '?auth_tocken=$token'
            '&channel_name=$channelName'
            '&call_type=$typeId',
        'reciever_id': appt['student_id'],
        'payload': {
          'appointment'  : appt,
          'channel_name' : channelName,
          'token'        : token,
          'call_type'    : typeId,        // ← NEW: lets student open correct screen
          'call_label'   : callLabel,
        },
      },
      true,
      sendCallNotificationRepo);
}

// ─── sendCallNotificationRepo ─────────────────────────────────────────────────
/// Response handler for the send-notification API call.
sendCallNotificationRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    log('sendCallNotificationRepo: notification sent – $response');
  } else {
    log('sendCallNotificationRepo: notification send FAILED – $response');
    Get.find<GeneralController>().updateFormLoaderController(false);
  }
}
