import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../api_services/AgoraCallService.dart';

/// AudioCallScreen — Teacher side
/// Uses dynamic Agora credentials from GetAllSettingsController.
/// Channel: "appt_{appointmentId}" — same formula as student app.

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({super.key});

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  int?     _remoteUid;
  bool     _isMuted      = false;
  bool     _isSpeakerOn  = true;
  bool     _isConnecting = true;
  Duration _callDuration = Duration.zero;

  late final String _channelName;
  late final String _studentName;

  final _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    final gc     = Get.find<GeneralController>();
    _channelName = gc.channelForCall!;
    _studentName =
        gc.selectedAppointmentHistoryForView.studentName ?? "Student";
    _startTimer();
    _initAgora();
  }

  void _startTimer() {
    _stopwatch.start();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _callDuration = _stopwatch.elapsed);
      return true;
    });
  }

  Future<void> _initAgora() async {
    final granted = await AgoraCallService.requestAudioPermissions();
    if (!granted) {
      Get.snackbar("Permission Denied",
          "Microphone access is required for audio calls.",
          backgroundColor: Colors.red, colorText: Colors.white);
      Future.delayed(const Duration(seconds: 2), () => Get.back());
      return;
    }

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
          log("Teacher joined audio channel: ${connection.channelId}");
          setState(() => _isConnecting = false);
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          log("Student joined audio: uid=$remoteUid");
          setState(() => _remoteUid = remoteUid);
          _stopwatch.reset();
          _stopwatch.start();
        },
        onUserOffline: (connection, remoteUid, reason) {
          log("Student left audio: uid=$remoteUid reason=$reason");
          setState(() => _remoteUid = null);
          _showCallEndedDialog();
        },
        onError: (err, msg) => log("Agora error: $err – $msg"),
      ),
    );

    await AgoraCallService.joinAudioChannel(
      channelName: _channelName,
      token: null, // Replace with token from backend for production
    );

    await AgoraCallService.toggleSpeaker(_isSpeakerOn);
  }

  void _showCallEndedDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Call Ended"),
        content: const Text("The student has left the call."),
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
    _stopwatch.stop();
    await AgoraCallService.leaveChannel();
    if (mounted) Get.back();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    AgoraCallService.leaveChannel();
    super.dispose();
  }

  String get _formattedDuration {
    final m = _callDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _callDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  // ─── UI ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, Color(0xFF003366)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 60.h),

              // ── Avatar ──
              CircleAvatar(
                radius: 64.r,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: CircleAvatar(
                  radius: 56.r,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  child: Icon(Icons.person,
                      size: 64.r, color: Colors.white70),
                ),
              ),

              SizedBox(height: 24.h),

              // ── Student name ──
              Text(
                _studentName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),

              SizedBox(height: 8.h),

              // ── Status / Timer ──
              Text(
                _isConnecting
                    ? "Calling..."
                    : _remoteUid != null
                    ? _formattedDuration
                    : "Waiting for student...",
                style: TextStyle(color: Colors.white70, fontSize: 16.sp),
              ),

              if (_isConnecting) ...[
                SizedBox(height: 20.h),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white70, strokeWidth: 2),
                ),
              ],

              const Spacer(),

              // ── Controls ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _roundButton(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      label: _isMuted ? "Unmute" : "Mute",
                      color: _isMuted
                          ? Colors.red.withOpacity(0.8)
                          : Colors.white24,
                      onTap: () async {
                        setState(() => _isMuted = !_isMuted);
                        await AgoraCallService.toggleMute(_isMuted);
                      },
                    ),
                    _roundButton(
                      icon: Icons.call_end,
                      label: "End",
                      color: Colors.red,
                      size: 72,
                      onTap: _endCall,
                    ),
                    _roundButton(
                      icon: _isSpeakerOn
                          ? Icons.volume_up
                          : Icons.volume_off,
                      label: _isSpeakerOn ? "Speaker" : "Earpiece",
                      color: Colors.white24,
                      onTap: () async {
                        setState(() => _isSpeakerOn = !_isSpeakerOn);
                        await AgoraCallService.toggleSpeaker(_isSpeakerOn);
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    double size = 56,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: Icon(icon, color: Colors.white, size: size * 0.4),
          ),
          SizedBox(height: 8.h),
          Text(label,
              style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
        ],
      ),
    );
  }
}