import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';
import '../controllers/general_controller.dart';
import '../api_services/AgoraCallService.dart';

/// VideoCallScreen — Teacher side
/// Channel: "appt_{appointmentId}" — matches student app automatically.
/// Agora App ID is loaded from settings API (no hardcoding).

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int?  _remoteUid;
  bool  _localUserJoined = false;
  bool  _isMuted         = false;
  bool  _isCameraOff     = false;
  bool  _isSpeakerOn     = true;
  bool  _isConnecting    = true;

  late final String _channelName;

  @override
  void initState() {
    super.initState();
    // Channel is set in GeneralController before navigating here
    _channelName = Get.find<GeneralController>().channelForCall!;
    _initAgora();
  }

  Future<void> _initAgora() async {
    final granted = await AgoraCallService.requestVideoPermissions();
    if (!granted) {
      Get.snackbar(
        "Permission Denied",
        "Camera and microphone access required for video calls.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Future.delayed(const Duration(seconds: 2), () => Get.back());
      return;
    }

    // AgoraCallService reads App ID from GetAllSettingsController automatically
    await AgoraCallService.initialize();

    if (AgoraCallService.engine == null) {
      Get.snackbar("Error", "Could not start call. Please try again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      Future.delayed(const Duration(seconds: 2), () => Get.back());
      return;
    }

    AgoraCallService.engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          log("Teacher joined video channel: ${connection.channelId}");
          setState(() {
            _localUserJoined = true;
            _isConnecting    = false;
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          log("Student joined video: uid=$remoteUid");
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (connection, remoteUid, reason) {
          log("Student left video: uid=$remoteUid reason=$reason");
          setState(() => _remoteUid = null);
          _showCallEndedDialog("Student has left the call.");
        },
        onError: (err, msg) => log("Agora error: $err – $msg"),
      ),
    );

    // Token: null = testing mode (no token auth in Agora Console).
    // For production: generate token on Laravel backend using agora_app_certificate
    // from your settings model, then pass it here.
    await AgoraCallService.joinVideoChannel(
      channelName: _channelName,
      token: null,
    );

    await AgoraCallService.toggleSpeaker(_isSpeakerOn);
  }

  void _showCallEndedDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Call Ended"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () { Get.back(); _endCall(); },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _endCall() async {
    await AgoraCallService.leaveChannel();
    if (mounted) Get.back();
  }

  @override
  void dispose() {
    AgoraCallService.leaveChannel();
    super.dispose();
  }

  // ─── UI ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        _remoteVideo(),
        if (_localUserJoined) _localVideoOverlay(),
        if (_isConnecting) _connectingOverlay(),
        Positioned(bottom: 40.h, left: 0, right: 0, child: _controlBar()),
        Positioned(top: 0, left: 0, right: 0, child: _topBar()),
      ]),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return SizedBox.expand(
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: AgoraCallService.engine!,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: RtcConnection(channelId: _channelName),
          ),
        ),
      );
    }
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 52.r,
              backgroundColor: AppColors.primaryColor.withOpacity(0.3),
              child: Icon(Icons.person, size: 52.r, color: Colors.white54),
            ),
            SizedBox(height: 16.h),
            Text(
              _isConnecting ? "Connecting..." : "Waiting for student...",
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _localVideoOverlay() {
    return Positioned(
      top: 80.h,
      right: 16.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: 110.w,
          height: 160.h,
          child: _isCameraOff
              ? Container(
            color: Colors.grey[900],
            child: const Center(
              child: Icon(Icons.videocam_off, color: Colors.white54),
            ),
          )
              : AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: AgoraCallService.engine!,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _connectingOverlay() => Container(
    color: Colors.black54,
    child: const Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    ),
  );

  Widget _topBar() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            const Icon(Icons.videocam, color: Colors.white, size: 20),
            SizedBox(width: 8.w),
            const Text("Video Call",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _remoteUid != null
                    ? Colors.green.withOpacity(0.8)
                    : Colors.orange.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _remoteUid != null ? "Connected" : "Waiting",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _circleButton(
          icon: _isMuted ? Icons.mic_off : Icons.mic,
          color: _isMuted ? Colors.red : Colors.white24,
          onTap: () async {
            setState(() => _isMuted = !_isMuted);
            await AgoraCallService.toggleMute(_isMuted);
          },
        ),
        _circleButton(
          icon: Icons.call_end,
          color: Colors.red,
          size: 56,
          onTap: _endCall,
        ),
        _circleButton(
          icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
          color: _isCameraOff ? Colors.red : Colors.white24,
          onTap: () async {
            setState(() => _isCameraOff = !_isCameraOff);
            await AgoraCallService.toggleCamera(_isCameraOff);
          },
        ),
        _circleButton(
          icon: Icons.flip_camera_ios,
          color: Colors.white24,
          onTap: () => AgoraCallService.switchCamera(),
        ),
        _circleButton(
          icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
          color: Colors.white24,
          onTap: () async {
            setState(() => _isSpeakerOn = !_isSpeakerOn);
            await AgoraCallService.toggleSpeaker(_isSpeakerOn);
          },
        ),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 48,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, color: Colors.white, size: size * 0.45),
      ),
    );
  }
}