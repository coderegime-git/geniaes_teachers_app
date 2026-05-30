import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart' as dio_instance;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'in_app_attachment_viewer.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:resize/resize.dart';

import '../api_services/get_service.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_font.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/live_chat_controller.dart';
import '../repositories/live_chat_messages_repo.dart';
import '../widgets/appbar_widget.dart';
import 'agora_call/repo.dart';

/// LiveChatScreen — uses Pusher credentials from GetAllSettingsController
/// Channel: "private-chat-message.{appointmentId}"
/// Both teacher and student apps subscribe to the same channel name.

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final _liveChatLogic     = Get.put(LiveChatController());
  final _generalController = Get.find<GeneralController>();

  // Read Pusher credentials from settings API (fetched at app start)
  late final GetAllSettingsController _settingsCtrl;

  PusherChannelsFlutter pusherChannels = PusherChannelsFlutter.getInstance();

  late final String _channelName;
  static const String _eventName = "chat-message";

  // Getters for dynamic credentials
  String get _pusherAppKey =>
      _settingsCtrl.getAllSettingsModel.data?.pusherAppKey ?? "";
  String get _pusherAppSecret =>
      _settingsCtrl.getAllSettingsModel.data?.pusherAppSecret ?? "";
  String get _pusherAppCluster =>
      _settingsCtrl.getAllSettingsModel.data?.pusherAppCluster ?? "mt1";

  @override
  void initState() {
    super.initState();

    _settingsCtrl = Get.find<GetAllSettingsController>();

    final appointmentId =
        _generalController.selectedAppointmentHistoryForView.id;

    // Channel name — must match student app exactly
    _channelName = "private-chat-message.$appointmentId";

    // Fetch message history
    getMethod(
      context,
      "$getMessagesUrl$appointmentId",
      null,
      true,
      getLiveChatMessagesRepo,
    );

    _initPusher();
    
    // Notify student via push notification
    sendCallNotificationToStudent(context);
  }

  Future<void> _initPusher() async {
    if (_pusherAppKey.isEmpty) {
      log("LiveChatScreen: pusherAppKey is empty – check settings API response");
      return;
    }

    try {
      await pusherChannels.init(
        apiKey: _pusherAppKey,
        cluster: _pusherAppCluster,
        logToConsole: true,
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onEvent: _onGlobalEvent,
        onSubscriptionError: _onSubscriptionError,
        onDecryptionFailure: _onDecryptionFailure,
        onMemberAdded: _onMemberAdded,
        onMemberRemoved: _onMemberRemoved,
        onAuthorizer: _onAuthorizer,
      );

      await pusherChannels.subscribe(
        channelName: _channelName,
        onEvent: (event) {
          log("LiveChat event received [${event.eventName}]: ${event.data}");
          
          // Ignore internal Pusher events like pusher:subscription_succeeded
          if (event.eventName.startsWith('pusher:')) return;
          
          if (event.data == null || (event.data as String).isEmpty) return;

          try {
            final decoded =
            jsonDecode(event.data as String) as Map<String, dynamic>;
            
            // The Laravel backend usually wraps the data in the model name or "message"
            // We check for "message" key, or if the root is the message itself.
            dynamic message = decoded["message"] ?? decoded;
            
            if (message != null && message is Map) {
              // Ensure we don't duplicate messages we already sent (if socketId isn't excluded)
              Get.find<LiveChatController>().updateMessageList(message);
              _scrollToBottom();
            }
          } catch (e) {
            log("LiveChat: decode error – $e");
          }
        },
      );

      await pusherChannels.connect();
      log("LiveChat: Connected to Pusher, subscribed to $_channelName");
    } catch (e) {
      log("LiveChat Pusher init error: $e");
    }
  }

  // ─── Pusher private channel auth (HMAC-SHA256) ────────────────────────────
  dynamic _onAuthorizer(String channelName, String socketId, dynamic options) {
    if (_pusherAppSecret.isEmpty || _pusherAppKey.isEmpty) {
      log("LiveChat: Pusher credentials missing for auth");
      Get.find<GeneralController>().updateCallLoaderController(false);
      // Optionally show a snackbar:
      Get.snackbar("Chat Error", "Unable to connect — missing credentials");
      return {"auth": ""};
    }

    final stringToSign = "$socketId:$channelName";
    final secretBytes  = utf8.encode(_pusherAppSecret);
    final msgBytes     = utf8.encode(stringToSign);
    final signature    = Hmac(sha256, secretBytes).convert(msgBytes).toString();
    final auth         = "$_pusherAppKey:$signature";

    log("LiveChat: Auth generated for $channelName");
    return {"auth": auth};
  }

  // ─── Pusher callbacks ─────────────────────────────────────────────────────
  void _onGlobalEvent(PusherEvent event) {
    log("Pusher global event: ${event.channelName} / ${event.eventName}");
  }

  void _onConnectionStateChange(dynamic current, dynamic previous) {
    log("Pusher: $previous → $current");
    if (current == "CONNECTING" || current == "RECONNECTING") {
      _generalController.updateCallLoaderController(true);
    } else if (current == "CONNECTED") {
      _generalController.updateCallLoaderController(false);
    }
  }

  void _onError(String message, int? code, dynamic e) =>
      log("Pusher error: $message code: $code ex: $e");

  void _onSubscriptionSucceeded(String channelName, dynamic data) =>
      log("Subscribed: $channelName");

  void _onSubscriptionError(String message, dynamic e) =>
      log("Sub error: $message ex: $e");

  void _onDecryptionFailure(String event, String reason) =>
      log("Decrypt fail: $event reason: $reason");

  void _onMemberAdded(String channelName, PusherMember member) =>
      log("Member added: $channelName – $member");

  void _onMemberRemoved(String channelName, PusherMember member) =>
      log("Member removed: $channelName – $member");

  // ─── Helpers ──────────────────────────────────────────────────────────────
  void _scrollToBottom() {
    final ctrl = _liveChatLogic.chatScrollController;
    if (ctrl == null || !ctrl.hasClients) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      if (ctrl.hasClients) {
        ctrl.animateTo(
          ctrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final generalController = Get.find<GeneralController>();
    final liveChatController = Get.find<LiveChatController>();

    generalController.focusOut(context);

    if (liveChatController.messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please type a message"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (liveChatController.selectedFile != null) {
      dio_instance.FormData formData = dio_instance.FormData.fromMap({
        'appointment_id': generalController.selectedAppointmentHistoryForView.id,
        'message': liveChatController.messageController.text,
        'attachment_file': await dio_instance.MultipartFile.fromFile(
          liveChatController.selectedFile!.path,
          filename: liveChatController.selectedFile!.path.split('/').last,
        ),
      });
      postMethod(
          context,
          sendMessageUrl,
          formData,
          true,
          (context, success, data) {
            sendMessagesRepo(context, success, data);
            if (success) {
              liveChatController.updateSelectedFile(null);
              liveChatController.messageController.clear();
            }
          });
    } else {
      postMethod(
          context,
          sendMessageUrl,
          {
            'appointment_id': generalController.selectedAppointmentHistoryForView.id,
            'attachment_file': null,
            'message': liveChatController.messageController.text
          },
          true,
          sendMessagesRepo);
      liveChatController.messageController.clear();
    }
  }

  @override
  void dispose() {
    pusherChannels.unsubscribe(channelName: _channelName);
    pusherChannels.disconnect();
    super.dispose();
  }

  // ─── UI ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(
      builder: (generalController) {
        return GetBuilder<LiveChatController>(
          builder: (liveChatController) {
            return ModalProgressHUD(
              progressIndicator: const CircularProgressIndicator(
                  color: AppColors.primaryColor),
              inAsyncCall: generalController.callLoaderController,
              child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: AppBarWidget(
                    leadingIcon: 'assets/icons/Expand_left.png',
                    leadingOnTap: () {
                      pusherChannels.unsubscribe(channelName: _channelName);
                      pusherChannels.disconnect();
                      Get.back();
                    },
                    titleText: generalController
                        .selectedAppointmentHistoryForView.studentName ??
                        "",
                  ),
                ),

                // ── Input bar ──
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10.h,
                    left: 5.w,
                    right: 5.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (liveChatController.selectedFile != null)
                        Container(
                          padding: EdgeInsets.all(8.w),
                          margin: EdgeInsets.only(bottom: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.insert_drive_file, color: AppColors.primaryColor),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Text(
                                  liveChatController.selectedFile!.path.split(Platform.pathSeparator).last,
                                  style: TextStyle(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red, size: 20),
                                onPressed: () {
                                  liveChatController.updateSelectedFile(null);
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.attach_file, color: AppColors.primaryColor),
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles();
                              if (result != null && result.files.single.path != null) {
                                liveChatController.updateSelectedFile(File(result.files.single.path!));
                              }
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                fontFamily: AppFont.primaryFontFamily,
                                fontSize: 14.sp,
                                color: AppColors.white,
                              ),
                              controller: liveChatController.messageController,
                              onTap: _scrollToBottom,
                              textInputAction: TextInputAction.send,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onFieldSubmitted: (_) => _sendMessage(),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 20.w),
                                filled: true,
                                fillColor: AppColors.primaryColor,
                                hintText: 'Type a message...',
                                hintStyle: AppTextStyles.bodyTextStyle16,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide:
                              const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: const BorderSide(
                                  color: AppColors.primaryColor),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide:
                              const BorderSide(color: Colors.red),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide:
                              const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.fromSTEB(10.w, 0, 0, 0),
                        child: InkWell(
                          onTap: _sendMessage,
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(Icons.send,
                                color: AppColors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                 ],
                ),
                ),

                body: _buildBody(liveChatController, generalController),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
      LiveChatController liveChatController,
      GeneralController generalController,
      ) {
    // Show spinner while loading history
    if (liveChatController.getMessagesLoader) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (liveChatController.messageList.isEmpty) {
      return Center(
        child: Text(
          "No messages yet.\nSay hello! 👋",
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyTextStyle13,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: ListView.builder(
        controller: liveChatController.chatScrollController,
        itemCount: liveChatController.messageList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final msg = liveChatController.messageList[index];
          if (msg == null) return const SizedBox.shrink();

          final isTeacher = msg["sender_id"] ==
              generalController
                  .selectedAppointmentHistoryForView.teacherId;

          return Align(
            alignment:
            isTeacher ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.fromLTRB(10.w, 12.h, 10.w, 12.h),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: BoxDecoration(
                color: isTeacher
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft: isTeacher
                      ? Radius.circular(12.r)
                      : Radius.circular(2.r),
                  bottomRight: isTeacher
                      ? Radius.circular(2.r)
                      : Radius.circular(12.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (msg["is_attachment"] == 1 || msg["is_attachment"] == true || msg["attachment_url"] != null)
                    GestureDetector(
                      onTap: () {
                        final urlStr = msg["attachment_url"]?.toString() ?? "";
                        if (urlStr.isNotEmpty) {
                          final fullUrl = urlStr.startsWith('http') ? urlStr : "$mediaUrl$urlStr";
                          Get.to(() => InAppAttachmentViewer(url: fullUrl));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.insert_drive_file, color: AppColors.primaryColor),
                            SizedBox(width: 8.w),
                            Flexible(
                              child: Text(
                                "View Attachment",
                                style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (msg["message"] != null && msg["message"].toString().isNotEmpty)
                    Text(
                      "${msg["message"]}",
                      style: AppTextStyles.bodyTextStyle16,
                    ),
                  SizedBox(height: 4.h),
                  Text(
                    generalController
                        .displayDateTime("${msg["created_at"]}"),
                    style: AppTextStyles.bodyTextStyle4,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}