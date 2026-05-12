import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resize/resize.dart';

import '../../api_services/post_service.dart';
import '../../api_services/urls.dart';
import '../../config/app_colors.dart';
import '../../config/app_font.dart';
import '../../controllers/general_controller.dart';
import 'agora.config.dart' as config;
import 'repo.dart';

/// Teacher-side audio call screen.
class JoinChannelAudio extends StatefulWidget {
  final String? channelId;

  const JoinChannelAudio({super.key, this.channelId});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelAudio> {
  late final RtcEngine _engine;

  bool isJoined = false;
  bool openMicrophone = true;
  bool enableSpeakerphone = false;
  int? callEnd = 0;
  bool _disposed = false;

  Timer? _timer;

  // ─── Lifecycle ─────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    log('JoinChannelAudio: initState – channel=${Get.find<GeneralController>().channelForCall}');

    // 1. Notify student via backend (fires FCM to student).
    postMethod(
        context,
        makeAgoraCall,
        {
          'appointment': {
            'student_id': Get.find<GeneralController>()
                .selectedAppointmentHistoryForView
                .studentId,
            'id': Get.find<GeneralController>()
                .selectedAppointmentHistoryForView
                .id,
          },
          'channel': Get.find<GeneralController>().channelForCall,
          'token': Get.find<GeneralController>().tokenForCall,
        },
        true,
        makeAgoraCallRepo);

    // 2. Poll every 2 s for call-end state.
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _callEndCheckMethod();
    });

    // 3. Init engine then join (properly chained).
    _initAndJoin();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  // ─── Engine setup ───────────────────────────────────────────

  Future<void> _initAndJoin() async {
    await _initEngine();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!_disposed) await _joinChannel();
  }

  Future<void> _initEngine() async {
    // Wait for Agora App ID to be loaded if it's currently empty
    int retryCount = 0;
    while (config.agoraAppId.isEmpty && retryCount < 10 && !_disposed) {
      log('Agora App ID is empty, waiting... (Attempt ${retryCount + 1})');
      await Future.delayed(const Duration(milliseconds: 500));
      retryCount++;
    }

    if (config.agoraAppId.isEmpty) {
      log('JoinChannelAudio: Agora App ID is still empty after retries. Initialization aborted.');
      return;
    }

    _engine = createAgoraRtcEngineEx();
    await _engine.initialize(RtcEngineContext(
      appId: config.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _addListeners(); // Registered exactly ONCE.

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    log('JoinChannelAudio: engine ready');
  }

  /// Registers all Agora event callbacks (called exactly once).
  void _addListeners() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('JoinChannelAudio: joined ${connection.channelId}');
        if (!_disposed) setState(() => isJoined = true);
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('JoinChannelAudio: left channel');
        if (!_disposed) setState(() => isJoined = false);
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        log('JoinChannelAudio: remote user $remoteUid joined');
        if (!_disposed) setState(() => callEnd = 1);
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        log('JoinChannelAudio: remote user $remoteUid offline');
        if (!_disposed) {
          setState(() {
            if (callEnd == 1) callEnd = 2;
          });
        }
      },
    ));
  }

  Future<void> _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    final gc = Get.find<GeneralController>();
    await _engine
        .joinChannel(
          token: gc.tokenForCall ?? '',    // '' = no-token mode (development)
          channelId: gc.channelForCall!,
          uid: gc.callerType,
          options: const ChannelMediaOptions(
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            publishMicrophoneTrack: true,
            publishCameraTrack: false,
            autoSubscribeAudio: true,
            autoSubscribeVideo: false,
          ),
        )
        .catchError((e) => log('JoinChannelAudio joinChannel error: $e'));
    log('JoinChannelAudio: joinChannel called');
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
    if (!_disposed) Get.back();
  }

  // ─── Call-end polling ───────────────────────────────────────

  void _callEndCheckMethod() {
    if (callEnd == 2 && !_disposed) {
      _timer?.cancel();
      _leaveChannel();
    }
  }

  // ─── Controls ───────────────────────────────────────────────

  void _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((_) {
      if (!_disposed) setState(() => openMicrophone = !openMicrophone);
    }).catchError((e) => log('mic toggle error: $e'));
  }

  void _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((_) {
      if (!_disposed) setState(() => enableSpeakerphone = !enableSpeakerphone);
    }).catchError((e) => log('speaker toggle error: $e'));
  }

  // ─── UI ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/call-bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .1),

                // Avatar
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      '$mediaUrl${Get.find<GeneralController>().currentTeacherModel!.loginInfo!.image}'),
                  radius: 75.h,
                ),

                SizedBox(height: 16.h),

                // Status label
                Text(
                  isJoined ? 'Audio Call in Progress' : 'Connecting…',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: AppFont.primaryFontFamily,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * .12),

                // Controls
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Mute button
                          InkWell(
                            onTap: _switchMicrophone,
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: !openMicrophone
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              child: Icon(
                                openMicrophone ? Icons.mic : Icons.mic_off,
                                color: openMicrophone
                                    ? AppColors.primaryColor
                                    : Colors.white,
                                size: 25,
                              ),
                            ),
                          ),

                          // Speaker button
                          InkWell(
                            onTap: _switchSpeakerphone,
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: enableSpeakerphone
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              child: Icon(
                                enableSpeakerphone
                                    ? Icons.volume_up
                                    : Icons.volume_off,
                                color: enableSpeakerphone
                                    ? Colors.white
                                    : AppColors.primaryColor,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // End call
                      InkWell(
                        onTap: _leaveChannel,
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.call_end,
                              color: Colors.white, size: 25),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
