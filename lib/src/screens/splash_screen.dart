import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_colors.dart';
import '../config/app_configs.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_appointment_history_controller.dart';

import '../controllers/teacher_booked_services_controller.dart';
import '../models/logged_in_teacher_model.dart';
import '../routes.dart';
import '../widgets/background_widgets/splash_screen_background_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final logic = Get.put(TeacherAppointmentHistoryController());
  final teacherProfileLogic = Get.put(EditProfileController());
  final teacherBookedServicesLogic = Get.put(TeacherBookedServicesController());

  late AnimationController animationController;
  late Animation<double> animation;
  late AnimationController _controller;
  late Animation<double> _animation;

  startTime() async {
    final controller = Get.find<GetAllSettingsController>();
    final logo = controller.getAllSettingsModel.data?.logo;

    // If logo is null or empty, fallback to default delay
    if (logo == null || logo.isEmpty) {
      await Future.delayed(const Duration(seconds: 3));
      checkFirstSeenAndNavigate();
      return;
    }

    final image = NetworkImage("${AppConfigs.mediaUrl}$logo");

    final completer = Completer();

    image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo imageInfo, bool synchronousCall) {
              // Logo loaded successfully
              completer.complete();
            },
            onError: (dynamic exception, StackTrace? stackTrace) {
              // Logo failed to load; still navigate
              completer.complete();
            },
          ),
        );

    // Wait for logo load or timeout as fallback
    await Future.any([
      completer.future,
      Future.delayed(const Duration(seconds: 6)), // max wait
    ]);

    checkFirstSeenAndNavigate();
  }

  Future checkFirstSeenAndNavigate() async {
    bool seen =
        (Get.find<GeneralController>().storageBox.read('seen') ?? false);

    if (seen) {
      if (Get.find<GeneralController>().storageBox.read('authToken') != null) {
        Get.toNamed(PageRoutes.homeScreen);
      } else {
        Get.toNamed(PageRoutes.signinScreen);
      }
    } else {
      await Get.find<GeneralController>().storageBox.write('seen', true);
      Get.toNamed(PageRoutes.introScreen);
    }
  }

  @override
  void initState() {
    super.initState();

    if (Get.find<GeneralController>().storageBox.hasData('userData') &&
        Get.find<GeneralController>().storageBox.hasData('authToken')) {
      Get.find<GeneralController>().currentTeacherModel =
          GetLoggedInTeacherDataModel.fromJson(jsonDecode(
              Get.find<GeneralController>().storageBox.read('userData')));
    }
    log("${Get.find<GeneralController>().storageBox.read('userData')} Intro User Data");

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    startTime();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 10800),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetAllSettingsController>(
        builder: (getAllSettingsController) {
      final logo = getAllSettingsController.getAllSettingsModel.data?.logo;
      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: <Widget>[
            Positioned(child: SplashBackgroundWidget()),
            Container(
              decoration: const BoxDecoration(color: AppColors.white),
              child: Center(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return logo == null || logo.isEmpty
                        ? const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          )
                        : SizedBox(
                            width: animation.value * 350,
                            height: animation.value * 150,
                            child: Image.network(
                              "${AppConfigs.mediaUrl}$logo",
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
