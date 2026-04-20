import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_colors.dart';
import '../controllers/live_chat_controller.dart';
import '../models/get_live_chat_messages_model.dart';

import '../models/get_live_service_chat_messages_model.dart';
import '../widgets/custom_dialog.dart';

getLiveChatMessagesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<LiveChatController>().getLiveChatMessagesModel =
        GetLiveChatMessagesModel.fromJson(response);
    if (Get.find<LiveChatController>().getLiveChatMessagesModel.success ==
        true) {
      Get.find<LiveChatController>().emptyMessageList();
      for (var element in response["data"]) {
        Get.find<LiveChatController>().updateMessageList(element);
      }
      Get.find<LiveChatController>().updateGetMessagesLoader(false);
      dynamic txData = jsonEncode(Get.find<LiveChatController>().messageList);
      print(
          "${jsonEncode(Get.find<LiveChatController>().getLiveChatMessagesModel)} Get Live Chat Messages");
      print("${Get.find<LiveChatController>().messageList.length} MESSAGELIST");
      print("${Get.find<LiveChatController>().messageList} 777");
    } else {
      Get.find<LiveChatController>().updateGetMessagesLoader(false);
    }
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Failed to Load Chat",
            titleColor: AppColors.customDialogErrorColor,
            descriptions:
                '${Get.find<LiveChatController>().getLiveChatMessagesModel.message}',
            text: "Ok",
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}

getServiceChatMessagesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<LiveChatController>().getLiveServiceChatMessagesModel =
        GetLiveServiceChatMessagesModel.fromJson(response);
    if (Get.find<LiveChatController>()
            .getLiveServiceChatMessagesModel
            .success ==
        true) {
      Get.find<LiveChatController>().emptyServiceMessageList();
      for (var element in response["data"]) {
        Get.find<LiveChatController>().updateServiceMessageList(element);
      }
      Get.find<LiveChatController>().updateGetServiceMessagesLoader(false);
      dynamic txData =
          jsonEncode(Get.find<LiveChatController>().serviceMessageList);
      print(
          "${jsonEncode(Get.find<LiveChatController>().getLiveServiceChatMessagesModel)} Get Live Service Chat Messages");
      print(
          "${Get.find<LiveChatController>().serviceMessageList.length} MESSAGELIST");
      print("${Get.find<LiveChatController>().serviceMessageList} 777");
    } else {
      Get.find<LiveChatController>().updateGetServiceMessagesLoader(false);
    }
  } else {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Failed to Load Chat",
            titleColor: AppColors.customDialogErrorColor,
            descriptions:
                '${Get.find<LiveChatController>().getLiveServiceChatMessagesModel.message}',
            text: "Ok",
            functionCall: () {
              Navigator.pop(context);
            },
            img: 'assets/icons/dialog_error.png',
          );
        });
  }
}

sendMessagesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<LiveChatController>().messageController.clear();
    if (response['Status'].toString() == 'true') {
      Get.find<LiveChatController>().updateGetMessagesLoader(false);
    } else {
      Get.find<LiveChatController>().updateGetMessagesLoader(false);
    }
  } else if (!responseCheck) {
    Get.find<LiveChatController>().updateGetMessagesLoader(false);
  }
}

sendServiceMessagesRepo(
    BuildContext context, bool responseCheck, Map<String, dynamic> response) {
  if (responseCheck) {
    Get.find<LiveChatController>().serviceMessageController.clear();
    if (response['Status'].toString() == 'true') {
      Get.find<LiveChatController>().updateGetServiceMessagesLoader(false);
    } else {
      Get.find<LiveChatController>().updateGetServiceMessagesLoader(false);
    }
  } else if (!responseCheck) {
    Get.find<LiveChatController>().updateGetServiceMessagesLoader(false);
  }
}
