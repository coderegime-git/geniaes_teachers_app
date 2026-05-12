import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_configs.dart';
import '../config/app_font.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/live_chat_controller.dart';
import '../repositories/live_chat_messages_repo.dart';
import '../widgets/appbar_widget.dart';

class LiveServiceChatScreen extends StatefulWidget {
  const LiveServiceChatScreen({super.key});

  @override
  State<LiveServiceChatScreen> createState() => _LiveServiceChatScreenState();
}

class _LiveServiceChatScreenState extends State<LiveServiceChatScreen> {
  final logic = Get.put(LiveChatController());
  PusherChannelsFlutter pusherChannels = PusherChannelsFlutter.getInstance();
  final _apiKey = AppConfigs.pusherAppKey;

  final _channelName =
      "private-chat-message-service.${Get.find<GeneralController>().selectedBookedServiceForView.id}";
  final _eventName = "chat-message-service";

  String responseData = '';

  Map<String, dynamic> eventResponseMap = {};

  dynamic messageData = {};

  @override
  void initState() {
    super.initState();

    getMethod(
        context,
        "$getServiceMessagesUrl${Get.find<GeneralController>().selectedBookedServiceForView.id}",
        null,
        true,
        getServiceChatMessagesRepo);

    print("${Get.find<LiveChatController>().serviceMessageList} MMMM");

    // Initialize Pusher Channel
    try {
      pusherChannels.init(
        apiKey: _apiKey,
        cluster: AppConfigs.pusherAppCluster,
        logToConsole: true,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent(
            PusherEvent(channelName: _channelName, eventName: _eventName)),
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onAuthorizer: onAuthorizer,
      );

      final myChannel = pusherChannels.subscribe(
          channelName: _channelName,
          onEvent: (event) {
            log("Got channel event [${event.eventName}]: ${event.data}");
            
            // Ignore internal Pusher events
            if (event.eventName.startsWith('pusher:')) return;
            
            if (event.data == null || event.data.toString().isEmpty) return;

            setState(() {
              responseData = event.data.toString();
            });

            try {
              eventResponseMap = jsonDecode(responseData) as Map<String, dynamic>;
              dynamic message = eventResponseMap["message"] ?? eventResponseMap;

              if (message != null && message is Map) {
                Get.find<LiveChatController>()
                    .updateServiceMessageList(message);
                
                final ctrl = Get.find<LiveChatController>().serviceChatScrollController;
                if (ctrl != null && ctrl.hasClients) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (ctrl.hasClients) {
                      ctrl.animateTo(ctrl.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                    }
                  });
                }
              }
            } catch (e) {
              log("LiveServiceChat: decode error - $e");
            }

            log("Got channel event messageData11: ${Get.find<LiveChatController>().serviceMessageList.length} items");
          });
      pusherChannels.connect();
    } catch (e) {
      log("ERROR: $e");
    }
    log("${pusherChannels.channels.toString()} PUSHERDATA");
    log("${eventResponseMap['channel'].toString()} CHANNELNAME2");
  }

  dynamic onAuthorizer(String channelName, String socketId, dynamic options) {
    log("OnAuthorizer: $channelName OnAuthorizerSocket: $socketId");

    String calculateHMAC(String secret, String stringToSign) {
      final secretKey = utf8.encode(secret);
      final message = utf8.encode(stringToSign);
      final hmac = Hmac(sha256, secretKey);
      final digest = hmac.convert(message);
      final signature = digest.toString();
      return signature;
    }

    final secret = AppConfigs.pusherAppSecret;
    final stringToSign = '$socketId:$channelName';

    final signature = calculateHMAC(secret, stringToSign);

    final auth = '$_apiKey:$signature';

    print('auth = $auth');

    return {"auth": auth};
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    if (currentState == "CONNECTING" || currentState == "RECONNECTING") {
      Get.find<GeneralController>().updateCallLoaderController(true);
      log("Connecting Loader");
    } else if (currentState == "CONNECTED") {
      Get.find<GeneralController>().updateCallLoaderController(false);
      log("Connected Loader");
    }
    log("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  onEvent(PusherEvent event) {
    log("onEvent: ${event.data}");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusherChannels.getChannel(channelName)?.me;
    log("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }

  void onTriggerEventPressed() {
    pusherChannels
        .trigger(PusherEvent(channelName: _channelName, eventName: _eventName));
    log("TRIGGERSUCCESS");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<LiveChatController>(builder: (liveChatController) {
        return ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
          inAsyncCall: generalController.callLoaderController,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBarWidget(
                leadingIcon: 'assets/icons/Expand_left.png',
                leadingOnTap: () {
                  Get.back();
                  pusherChannels.unsubscribe(channelName: _channelName);
                  pusherChannels.disconnect();
                },
                titleText:
                    generalController.selectedBookedServiceForView.studentName!,
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.w, 0, 5.w, 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: AppFont.primaryFontFamily,
                        fontSize: 14.sp,
                        color: AppColors.white,
                      ),
                      controller: liveChatController.serviceMessageController,
                      onTap: () {
                        Future.delayed(const Duration(seconds: 1)).whenComplete(
                            () => liveChatController
                                .serviceChatScrollController!
                                .animateTo(
                                    liveChatController
                                        .serviceChatScrollController!
                                        .position
                                        .maxScrollExtent,
                                    curve: Curves.easeOut,
                                    duration:
                                        const Duration(milliseconds: 500)));
                      },
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {
                        // if (_chatLogic.serviceMessageController.text.isEmpty) {
                        //   _chatLogic.updateShowSendIcon(false);
                        // } else {
                        //   _chatLogic.updateShowSendIcon(true);
                        // }
                      },
                      onFieldSubmitted: (value) {
                        // Get.find<GeneralController>()
                        //     .notificationRouteApp = null;
                        generalController.focusOut(context);
                        postMethod(
                            context,
                            sendServiceMessageUrl,
                            {
                              'booked_service_id': generalController
                                  .selectedBookedServiceForView.id,
                              'attachment_file': null,
                              'message': liveChatController
                                  .serviceMessageController.text
                            },
                            true,
                            sendServiceMessagesRepo);
                      },
                      // textDirection: generalController.isDirectionRTL(context) ? TextDirection.rtl : TextDirection.ltr,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 20.w),
                        filled: true,
                        fillColor: AppColors.primaryColor,
                        hintText: LanguageConstant.yourTextHere.tr,
                        // hintStyle: state.textFieldTextStyle,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                                color: AppColors.primaryColor)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(color: Colors.red)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                  // _chatLogic.showSendIcon!
                  //     ?
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10.w, 0, 0, 0),
                    child: InkWell(
                      onTap: () {
                        // Get.find<GeneralController>().notificationRouteApp = null;
                        generalController.focusOut(context);
                        postMethod(
                            context,
                            sendServiceMessageUrl,
                            {
                              'booked_service_id': generalController
                                  .selectedBookedServiceForView.id,
                              'attachment_file': null,
                              'message': liveChatController
                                  .serviceMessageController.text
                            },
                            true,
                            sendServiceMessagesRepo);
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(
                          Icons.send,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                  // : const SizedBox()
                ],
              ),
            ),
            body: !liveChatController.getServiceMessagesLoader
                ? Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                    child: liveChatController.serviceMessageList.isNotEmpty
                        ? ListView(
                            controller:
                                liveChatController.serviceChatScrollController,
                            children: List.generate(
                              liveChatController.serviceMessageList.length,
                              (index) {
                                return Align(
                                  alignment: liveChatController
                                                  .serviceMessageList[index]
                                              ["sender_id"] ==
                                          generalController
                                              .selectedBookedServiceForView
                                              .teacherId
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin:
                                        EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 8.h),
                                    padding: EdgeInsets.fromLTRB(
                                        10.w, 12.h, 10.w, 12.h),
                                    decoration: BoxDecoration(
                                        color: liveChatController
                                                        .serviceMessageList[
                                                    index]["sender_id"] ==
                                                generalController
                                                    .selectedBookedServiceForView
                                                    .teacherId
                                            ? AppColors.primaryColor
                                            : AppColors.primaryColor
                                                .withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${liveChatController.serviceMessageList[index]["message"]}",
                                          style: AppTextStyles.bodyTextStyle15,
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          generalController.displayDateTime(
                                              "${liveChatController.serviceMessageList[index]["created_at"]}"),
                                          style: AppTextStyles.bodyTextStyle4,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                  )
                : Container(),
          ),
        );
      });
    });
  }
}
