import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resize/resize.dart';

import '../../../multi_language/language_constants.dart';
import '../../api_services/post_service.dart';
import '../../api_services/urls.dart';
import '../../config/app_colors.dart';
import '../../config/app_font.dart';
import '../../controllers/general_controller.dart';
import '../../widgets/appbar_widget.dart';
import 'agora.config.dart' as config;
import 'repo.dart';

class JoinChannelVideo extends StatefulWidget {
  const JoinChannelVideo({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelVideo> with WidgetsBindingObserver {
  late final RtcEngine _engine;

  bool _engineReady = false; // ← Guard: only render AgoraVideoView when true
  bool isJoined = false;
  int? remoteUid;
  int? callEnd = 0;
  bool muted = false;
  bool _disposed = false;

  Timer? _timer;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    log('JoinChannelVideo: initState – channel=${Get.find<GeneralController>().channelForCall}');

    // 1. Notify student via backend (fires FCM notification to student).
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

    // 3. Init engine (properly awaited) then join channel.
    _initAndJoin();
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  /// Restart preview when app comes back to foreground (fixes black SurfaceView
  /// after permission dialog or app-switch destroys the surface texture).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_engineReady || _disposed) return;
    if (state == AppLifecycleState.resumed) {
      log('JoinChannelVideo: app resumed – restarting preview');
      _engine.enableLocalVideo(true);
      _engine.startPreview();
    } else if (state == AppLifecycleState.paused) {
      // Optionally stop preview to free camera while backgrounded.
      // _engine.stopPreview();
    }
  }

  // ─── Engine setup ─────────────────────────────────────────────────────────

  /// Initialises the RTC engine, registers event listeners (once!), then joins
  /// the channel. All async so nothing races.
  Future<void> _initAndJoin() async {
    await _initEngine();
    // Small delay lets the engine settle and the widget tree to mount so the
    // AgoraVideoView SurfaceTexture is ready before preview starts.
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_disposed) {
      // Signal UI to show AgoraVideoView widgets (so SurfaceTexture is created).
      setState(() => _engineReady = true);
      // Wait one more frame for the widget to attach its texture.
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Start preview BEFORE join so local camera is visible immediately
      await _engine.startPreview();
    }
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
      log('JoinChannelVideo: Agora App ID is still empty after retries. Initialization aborted.');
      return;
    }

    _engine = createAgoraRtcEngineEx();
    await _engine.initialize(RtcEngineContext(
      appId: config.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    // Register handlers ONCE here – never again in _joinChannel.
    _addListeners();

    await _engine.enableAudio();
    await _engine.enableVideo();
    await _engine.enableLocalVideo(true);
    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 800,
        orientationMode: OrientationMode.orientationModeAdaptive,
      ),
    );

    // NOTE: startPreview() is called AFTER _engineReady = true so the
    // AgoraVideoView SurfaceTexture is already mounted when preview begins.

    log('JoinChannelVideo: engine ready');
  }

  /// Registers all Agora event callbacks.  Called exactly ONCE per session.
  void _addListeners() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('JoinChannelVideo: joined channel ${connection.channelId}');
        if (!_disposed) {
          setState(() => isJoined = true);
        }
      },
      onUserJoined: (RtcConnection connection, int uid, int elapsed) {
        log('JoinChannelVideo: remote user $uid joined');
        if (!_disposed) {
          setState(() {
            remoteUid = uid;
            callEnd = 1;
          });
        }
      },
      onUserOffline: (RtcConnection connection, int uid,
          UserOfflineReasonType reason) {
        log('JoinChannelVideo: remote user $uid went offline');
        if (!_disposed) {
          setState(() {
            if (callEnd == 1) callEnd = 2;
            remoteUid = null;
          });
        }
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('JoinChannelVideo: left channel');
        if (!_disposed) {
          setState(() {
            isJoined = false;
            remoteUid = null;
          });
        }
      },
      onLocalVideoStateChanged: (VideoSourceType source,
          LocalVideoStreamState state, LocalVideoStreamReason error) {
        log('JoinChannelVideo: localVideoState source=$source state=$state error=$error');
      },
      onCameraReady: () {
        log('JoinChannelVideo: camera ready');
      },
    ));
  }

  Future<void> _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final statuses =
          await [Permission.microphone, Permission.camera].request();
      log('JoinChannelVideo: permissions → $statuses');
    }

    final gc = Get.find<GeneralController>();
    log('JoinChannelVideo: joining channel=${gc.channelForCall} uid=${gc.callerType}');

    await _engine.joinChannel(
      token: gc.tokenForCall ?? '',
      channelId: gc.channelForCall!,
      uid: gc.callerType,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
    log('JoinChannelVideo: joinChannel called');
  }

  Future<void> _leaveChannel() async {
    await _engine.leaveChannel();
  }

  // ─── Call-end polling ─────────────────────────────────────────────────────

  void _callEndCheckMethod() {
    if (callEnd == 2 && !_disposed) {
      _leaveChannel();
      Get.back();
    }
  }

  // ─── Controls ─────────────────────────────────────────────────────────────

  void _onToggleMute() {
    setState(() => muted = !muted);
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // ── Full-screen remote video (or waiting view) ──
            Positioned.fill(child: _remoteVideoOrWaiting()),

            // ── Local camera PiP (top-right corner) ──
            // Only rendered once the engine is ready to avoid LateInitializationError
            if (_engineReady)
              Positioned(
                top: 50.h,
                right: 16.w,
                child: SizedBox(
                  width: 120.w,
                  height: 160.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ),

            // ── Control toolbar (bottom) ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _toolbar(),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the remote participant's video full-screen, or a waiting screen.
  Widget _remoteVideoOrWaiting() {
    if (_engineReady && remoteUid != null) {
      final gc = Get.find<GeneralController>();
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: remoteUid!),
          connection: RtcConnection(channelId: gc.channelForCall),
        ),
      );
    }

    // Waiting / calling view while no remote user has joined.
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white24,
              child: Icon(Icons.videocam, size: 50, color: Colors.white),
            ),
            SizedBox(height: 24.h),
            Text(
              LanguageConstant.videoCall.tr,
              style: TextStyle(
                fontSize: 22.sp,
                fontFamily: AppFont.primaryFontFamily,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _engineReady
                  ? (isJoined ? 'Ringing…' : 'Connecting…')
                  : 'Initialising camera…',
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: AppFont.primaryFontFamily,
                color: Colors.white70,
              ),
            ),
            if (!_engineReady) ...[
              SizedBox(height: 16.h),
              const CircularProgressIndicator(color: Colors.white54),
            ],
          ],
        ),
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mute / unmute
          _controlButton(
            icon: muted ? Icons.mic_off : Icons.mic,
            color: muted ? AppColors.primaryColor : Colors.white,
            iconColor: muted ? Colors.white : AppColors.primaryColor,
            onPressed: _onToggleMute,
            size: 24.0,
          ),
          SizedBox(width: 24.w),
          // End call
          _controlButton(
            icon: Icons.call_end,
            color: Colors.redAccent,
            iconColor: Colors.white,
            onPressed: () async {
              await _leaveChannel();
              Get.back();
            },
            size: 32.0,
            padding: 18.0,
          ),
          SizedBox(width: 24.w),
          // Switch camera
          _controlButton(
            icon: Icons.switch_camera,
            color: Colors.white,
            iconColor: AppColors.primaryColor,
            onPressed: _onSwitchCamera,
            size: 24.0,
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onPressed,
    double size = 24.0,
    double padding = 14.0,
  }) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: EdgeInsets.all(padding),
      child: Icon(icon, color: iconColor, size: size),
    );
  }
}
