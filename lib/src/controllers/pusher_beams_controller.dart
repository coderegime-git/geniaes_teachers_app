import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:pusher_beams/pusher_beams.dart';

import '../api_services/urls.dart';
import '../config/app_configs.dart';

import 'general_controller.dart';
import 'pusher_payload_model.dart';

class PusherBeamsController extends GetxController {
  GetPusherBeamsPayloadModel getPusherBeamsPayloadModel =
      GetPusherBeamsPayloadModel();
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getSecure() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    try {
      var rawUserId = Get.find<GeneralController>().storageBox.read('pusherID');
      if (rawUserId == null || rawUserId.toString().isEmpty || rawUserId.toString() == "null") {
        log("PusherBeams getSecure aborted: pusherID is null or empty");
        return;
      }
      final userId = rawUserId.toString();
      print("PUSHER USER ID: $userId");
      log("PUSHER USER ID: $userId");
      log("PUSHER AUTH URL: ${apiBaseUrl}pusher/beams-auth");

      final BeamsAuthProvider provider = BeamsAuthProvider()
        ..authUrl = '${apiBaseUrl}pusher/beams-auth'
        ..headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Get.find<GeneralController>().storageBox.read('authToken')}',
          'logged-in-as': 'teacher',
        }
        ..queryParams = {
          'user_id': userId
        }
        ..credentials = 'omit';
        
      await PusherBeams.instance.clearDeviceInterests();
      
      await PusherBeams.instance.setUserId(
        userId,
        provider,
        (error) {
          if (error != null) {
              print("$error ERROR PUSHER");
          } else {
              print("$error PUSHER2");
          }
        },
      );
    } catch (e) {
      log("PusherBeams getSecure error: $e");
    }
  }

  initPusherBeams() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    log("INITIALIZE PUSHER");
    log("${Get.find<GeneralController>().storageBox.hasData('pusherID')} USERIDTRUE");
    log("${Get.find<GeneralController>().storageBox.read('pusherID')} USERIDREAD");
    
    try {
      String instanceId = AppConfigs.pusherBeamsInstanceId != null && AppConfigs.pusherBeamsInstanceId.toString().isNotEmpty 
          ? AppConfigs.pusherBeamsInstanceId.toString() 
          : '9466bd1b-2413-4135-badc-36ae30931bac';
      await PusherBeams.instance.start(instanceId);
      var rawUserId = Get.find<GeneralController>().storageBox.read('pusherID');
      if (rawUserId == null || rawUserId.toString().isEmpty || rawUserId.toString() == "null") {
        log("PusherBeams init aborted: pusherID is null or empty");
      }
    } catch (e) {
      log("PusherBeams start error: $e");
    }

    // Let's see our current interests
    await getSecure();

    try {
      log(await "${PusherBeams.instance.getDeviceInterests()} DEVICEINTEREST");

      await PusherBeams.instance
          .onInterestChanges((interests) { print('Interests: $interests'); });

      await PusherBeams.instance
          .onMessageReceivedInTheForeground(_onMessageReceivedInTheForeground);
    } catch (e) {
      log("PusherBeams init error: $e");
    }
    await _checkForInitialMessage();
  }

  Future<void> _checkForInitialMessage() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    try {
      final initialMessage = await PusherBeams.instance.getInitialMessage();
      if (initialMessage != null) {
        log(initialMessage.toString());
        // _showAlert(
        //   'Initial Message Is:',
        //   initialMessage.toString(),
        // );
      }
    } catch (e) {
      log("PusherBeams getInitialMessage error: $e");
    }
  }

  void _onMessageReceivedInTheForeground(Map<Object?, Object?> data) {
    try {
      if (data["data"] == null) return;
      dynamic allData = data["data"];
      
      if (allData is! Map || allData["payload"] == null) {
        log("Payload missing in notification data: $data");
        return;
      }
      
      Map<String, dynamic> payload = jsonDecode(allData["payload"]);
      dynamic appointmentData = payload["appointment"];

      log("$payload PAYLOAD");
      log("$appointmentData APPOINTMENT");

      if (payload["channel_name"] != null) {
        Get.find<GeneralController>().updateChannelForCall(payload["channel_name"]);
      }
      if (payload["token"] != null) {
        Get.find<GeneralController>().updateTokenForCall(payload["token"]);
      }
      
      if (appointmentData != null) {
        log("${appointmentData["teacher_name"]} TEACHERNAME");
      }
      log("${payload["channel_name"]} CHANNELNAME");
    } catch (e) {
      log("Error parsing foreground notification: $e");
    }

    if (Get.find<GeneralController>().storageBox.hasData('userData') &&
        Get.find<GeneralController>().storageBox.hasData('authToken')) {
      // Get.to(
      //     IncomingCallScreen(
      //       callAcceptOnTap:
      //           appointmentData["appointment_type_id"].toString() == "1"
      //               ? () {
      //                   // Get.to(VideoCall());
      //                   Get.toNamed(PageRoutes.videoCallScreen);
      //                 }
      //               : appointmentData["appointment_type_id"].toString() == "2"
      //                   ? () {
      //                       Get.toNamed(PageRoutes.audioCallScreen);
      //                     }
      //                   : () {},
      //       callRejectOnTap: () {
      //         Get.back();
      //       },
      //       callingUserName: appointmentData["teacher_name"].toString(),
      //       image: '',
      //       incomingCallType:
      //           "Incoming ${appointmentData["appointment_type_name"]}",
      //     ),
      //     fullscreenDialog: true,
      //     transition: Transition.downToUp,
      //     duration: const Duration(milliseconds: 600));
    } else {
      log("Pusher Beams Call Notification is not Initialized");
    }
  }

  clearAllStatePusherBeams() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    try {
      await PusherBeams.instance.clearAllState();
      log("Pusher Beams States are cleared");
    } catch (e) {
      log("PusherBeams clearAllState error: $e");
    }
  }
}
