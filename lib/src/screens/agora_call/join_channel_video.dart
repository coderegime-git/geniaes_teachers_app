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

/// MultiChannel Example
class JoinChannelVideo extends StatefulWidget {
  const JoinChannelVideo({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelVideo> {
  late final RtcEngine _engine;
  final formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> patientHealths = [];
  List<int>? selectedDiseasesIds;
  List<int>? selectedMedicalTestsIds;
  final List<Map<String, dynamic>> healthData = [
    {
      'selectedHealth': null,
      'valueController': TextEditingController(),
    }
  ];

  bool isJoined = false, switchCamera = true, switchRender = true;
  // List<int> remoteUid = [];
  int? remoteUid;
  bool localUserJoined = false;
  _callEndCheckMethod() {
    if (callEnd == 2) {
      _leaveChannel();
      Get.back();
    }
  }

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    log("${Get.arguments[0]} ARGUMENT");
    log("${Get.find<GeneralController>().appointmentObject} OBJECT");
    postMethod(
        context,
        makeAgoraCall,
        {
          "appointment": {
            "student_id": Get.find<GeneralController>()
                .selectedAppointmentHistoryForView
                .studentId,
            "id": Get.find<GeneralController>()
                .selectedAppointmentHistoryForView
                .id
          },
          "channel": Get.find<GeneralController>().channelForCall,
          "token": Get.find<GeneralController>().tokenForCall
        },
        true,
        makeAgoraCallRepo);

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _callEndCheckMethod();
    });

    Future.delayed(
      const Duration(seconds: 2),
    ).whenComplete(() => _joinChannel());
    // }

    _initEngine();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
    _engine.release();
  }

  int? callEnd = 0;

  _initEngine() async {
    _engine = createAgoraRtcEngineEx();
    await _engine.initialize(RtcEngineContext(
      appId: config.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _addListeners();

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.enableLocalVideo(true);

    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(),
    );
  }

  _addListeners() {
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        isJoined = true;
      },
      onUserJoined: (RtcConnection connection, int uid, int elapsed) {
        remoteUid = uid;
        callEnd = 1;
      },
      onUserOffline:
          (RtcConnection connection, int uid, UserOfflineReasonType reason) {
        remoteUid = uid;
        if (callEnd == 1) {
          callEnd = 2;
        }
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        _leaveChannel();
        isJoined = false;
        remoteUid = null;
      },
    ));
  }

  Future<dynamic> _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    await _engine.joinChannel(
      token: Get.find<GeneralController>().tokenForCall!,
      channelId: Get.find<GeneralController>().channelForCall!,
      uid: Get.find<GeneralController>().callerType,
      options: const ChannelMediaOptions(),
    );

    _addListeners();
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: remoteVideo(),
        onWillPop: () async {
          return false;
        });
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  bool muted = false;

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? AppColors.primaryColor : AppColors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : AppColors.primaryColor,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () {},
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: AppColors.white,
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              Icons.add,
              color: AppColors.primaryColor,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              _leaveChannel();
              // _onCallEnd(context);
              Get.back();
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.clear,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.switch_camera,
              color: AppColors.primaryColor,
              size: 20.0,
            ),
          )
        ],
      ),
    );
  }

  Widget remoteVideo() {
    if (remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(
              channelId: Get.find<GeneralController>().channelForCall),
        ),
      );
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBarWidget(
            leadingIcon: 'assets/icons/Expand_left.png',
            leadingOnTap: () {
              _leaveChannel();
              Get.back();
            },
            titleText: LanguageConstant.videoCall.tr,
          ),
        ),
        body: Center(
          child: Text(
            "LanguageConstant.pleaseWaitForRemoteUserToJoin.tr",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  ringingView() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.primaryColor,
              AppColors.customDialogSuccessColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              Container(
                height: 130.h,
                width: 130.w,
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                        image: AssetImage('assets/Icons/splash_logo.png'))),
              ),
              isJoined
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(0, 27.h, 0, 0),
                      child: Text(
                        'Ringing',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppFont.primaryFontFamily,
                            color: Colors.white),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.fromLTRB(0, 27.h, 0, 0),
                      child: Text(
                        'Calling',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppFont.primaryFontFamily,
                            color: Colors.white),
                      ),
                    ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: RawMaterialButton(
                      onPressed: () {
                        _leaveChannel();
                        _onCallEnd(context);
                      },
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.redAccent,
                      padding: const EdgeInsets.all(15.0),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 35.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  receiverView() {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppColors.primaryColor,
              AppColors.customDialogSuccessColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Image.asset(
                'assets/images/law-hammer.png',
                width: MediaQuery.of(context).size.width * .6,
              )),
              Text(
                'Call Alert',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: AppFont.primaryFontFamily,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                // '${LanguageConstant.youAreReceivingCallFrom.tr}'
                Get.find<GeneralController>()
                            .storageBox
                            .read('userRole')
                            .toString()
                            .toUpperCase() ==
                        'MENTEE'
                    ? 'CONSULTANT'
                    : 'USER',
                style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: AppFont.primaryFontFamily,
                    color: Colors.white),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _leaveChannel();
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 35.r,
                              child: const Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 35.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _joinChannel();
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.green,
                              radius: 35.r,
                              child: const Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 35.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
