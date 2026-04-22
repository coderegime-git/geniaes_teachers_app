import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/all_settings_controller.dart';

class AgoraCallService {
  static RtcEngine? _engine;
  static bool _isInitialized = false;
  static String _initializedWithAppId = "";

  /// Reads Agora App ID live from the settings API response.
  static String get _appId =>
      Get.find<GetAllSettingsController>()
          .getAllSettingsModel
          .data
          ?.agoraAppId ??
      "";

  static RtcEngine? get engine => _engine;

  /// Initialize Agora engine.
  /// Re-initializes automatically if the Agora App ID changed since the last
  /// init (e.g. settings API finished loading after the first attempt).
  static Future<void> initialize() async {
    final currentAppId = _appId;
    if (_isInitialized && _initializedWithAppId == currentAppId) return;

    // If engine already exists with a different (or empty) App ID, release it.
    if (_engine != null) {
      await _engine!.leaveChannel();
      await _engine!.release();
      _engine = null;
      _isInitialized = false;
    }

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: currentAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _isInitialized = true;
    _initializedWithAppId = currentAppId;
    log("AgoraCallService: Engine initialized with appId=$currentAppId");
  }

  /// Request camera + mic permissions (video call).
  static Future<bool> requestVideoPermissions() async {
    final camera = await Permission.camera.request();
    final mic = await Permission.microphone.request();
    return camera.isGranted && mic.isGranted;
  }

  /// Request mic permission only (audio call).
  static Future<bool> requestAudioPermissions() async {
    final mic = await Permission.microphone.request();
    return mic.isGranted;
  }

  /// Join a video call channel.
  /// [token] – Pass null if you disabled token auth in Agora Console (testing only).
  /// [channelName] – Unique channel name (use appointment ID or random string).
  /// [uid] – 0 = Agora auto-assigns UID.
  static Future<void> joinVideoChannel({
    required String channelName,
    String? token,
    int uid = 0,
  }) async {
    await initialize();

    await _engine!.enableVideo();
    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: token ?? "",
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );

    log("AgoraCallService: Joined VIDEO channel '$channelName'");
  }

  /// Join an audio-only call channel.
  static Future<void> joinAudioChannel({
    required String channelName,
    String? token,
    int uid = 0,
  }) async {
    await initialize();

    await _engine!.disableVideo();

    await _engine!.joinChannel(
      token: token ?? "",
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: false,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: false,
      ),
    );

    log("AgoraCallService: Joined AUDIO channel '$channelName'");
  }

  /// Leave current channel and clean up.
  static Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
    await _engine?.stopPreview();
    log("AgoraCallService: Left channel");
  }

  /// Fully destroy the engine (call in app dispose).
  static Future<void> dispose() async {
    await leaveChannel();
    await _engine?.release();
    _engine = null;
    _isInitialized = false;
    _initializedWithAppId = "";
    log("AgoraCallService: Engine disposed");
  }

  static Future<void> toggleMute(bool mute) async {
    await _engine?.muteLocalAudioStream(mute);
  }

  static Future<void> toggleCamera(bool disable) async {
    await _engine?.muteLocalVideoStream(disable);
  }

  static Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  static Future<void> toggleSpeaker(bool enable) async {
    await _engine?.setEnableSpeakerphone(enable);
  }
}