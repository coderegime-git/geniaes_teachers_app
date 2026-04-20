import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../models/get_live_chat_messages_model.dart';
import '../models/get_live_service_chat_messages_model.dart';

class LiveChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController serviceMessageController =
      TextEditingController();
  bool getMessagesLoader = true;
  bool getServiceMessagesLoader = true;

  updateGetMessagesLoader(bool newValue) {
    getMessagesLoader = newValue;
    update();
  }

  updateGetServiceMessagesLoader(bool newValue) {
    getServiceMessagesLoader = newValue;
    update();
  }

  // final ScrollController messageScrollController = ScrollController();
  List<dynamic> messageList = [];
  List<dynamic> serviceMessageList = [];
  updateMessageList(newValue) {
    messageList.add(newValue);
    update();
  }

  updateServiceMessageList(newValue) {
    serviceMessageList.add(newValue);
    update();
  }

  emptyMessageList() {
    messageList = [];
    update();
  }

  emptyServiceMessageList() {
    serviceMessageList = [];
    update();
  }

  bool? showSendIcon = false;
  updateShowSendIcon(bool? newValue) {
    showSendIcon = newValue;
    update();
  }

  int? senderMessageGetId;

  updateSenderMessageGetId(int? newValue) {
    senderMessageGetId = newValue;
    update();
  }

  int? receiverMessageGetId;

  updateReceiverMessageGetId(int? newValue) {
    receiverMessageGetId = newValue;
    update();
  }

// Appointment Chat Messages
  GetLiveChatMessagesModel getLiveChatMessagesModel =
      GetLiveChatMessagesModel();
  GetLiveChatMessagesDataModel? getLiveChatMessagesDataModel =
      GetLiveChatMessagesDataModel();

// Service Chat Messages
  GetLiveServiceChatMessagesModel getLiveServiceChatMessagesModel =
      GetLiveServiceChatMessagesModel();
  GetLiveServiceChatMessagesDataModel? getLiveServiceChatMessagesDataModel =
      GetLiveServiceChatMessagesDataModel();

  ScrollController? scrollController;
  ScrollController? chatScrollController;
  ScrollController? serviceChatScrollController;
  bool lastStatus = true;
  double height = 100.h;

  bool get isShrink {
    return scrollController!.hasClients &&
        scrollController!.offset > (height - kToolbarHeight);
  }

  void scrollListener() {
    if (isShrink != lastStatus) {
      lastStatus = isShrink;
      update();
    }
  }

  String? userName;
  String? userEmail;
  String? userImage;
}
