import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';

import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/general_controller.dart';
import '../controllers/logged_in_user_controller.dart';
import '../controllers/sign_out_user_controller.dart';
import '../controllers/signin_controller.dart';
import '../models/logged_in_teacher_model.dart';
import '../repositories/lawyer_booked_services_repo.dart';
import '../repositories/teacher_appointment_history_repo.dart';
import '../repositories/sign_out_user_repo.dart';
import '../routes.dart';
import '../screens/appointment_history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/webview_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final loggedInUserLogic = Get.put(LoggedInUserController());
  final signInLogic = Get.put(SigninController());
  final signOutUserLogic = Get.put(SignOutUserController());

  int currentIndex = 1;

  @override
  void initState() {
    print("TEACHER MODULES ${Get.find<GeneralController>().teacherModules}");
    if (Get.find<GeneralController>().storageBox.hasData('userData')) {
      Get.find<GeneralController>().currentTeacherModel =
          GetLoggedInTeacherDataModel.fromJson(jsonDecode(
              Get.find<GeneralController>().storageBox.read('userData')));
      log("${Get.find<GeneralController>().storageBox.read('userData')} Bottom User Data");
      Get.find<GeneralController>().teacherModules =
          Get.find<GeneralController>().currentTeacherModel!.teacherModules;
      log("${Get.find<GeneralController>().teacherModules} TEACHER MODULES");
      getMethod(context, "$getTeacherAppointmentHistory?page=1", null, true,
          getAllTeacherAppointmentHistoryRepo);
      getMethod(context, "$getTeacherBookedServices?page=1", null, true,
          getAllTeacherBookedServicesRepo);
    }

    super.initState();
  }

  /// Safely get the profile image widget, handling null loginInfo
  Widget _buildProfileImage() {
    final generalController = Get.find<GeneralController>();

    // Not logged in
    if (generalController.storageBox.read('authToken') == null) {
      return Image(
        image: const AssetImage('assets/icons/user-avatar.png'),
        height: 100.h,
        fit: BoxFit.contain,
      );
    }

    // Logged in but loginInfo or image is null
    final loginInfo = generalController.currentTeacherModel?.loginInfo;
    final image = loginInfo?.image;

    if (image != null && image.toString().isNotEmpty) {
      return Image(
        image: NetworkImage('$mediaUrl$image'),
        height: 100.h,
        errorBuilder: (context, error, stackTrace) => Image(
          image: const AssetImage('assets/icons/user-avatar.png'),
          height: 100.h,
        ),
      );
    }

    return Image(
      image: const AssetImage('assets/icons/user-avatar.png'),
      height: 100.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetScreens = <Widget>[
      Get.find<GeneralController>().storageBox.read('authToken') != null
          ? const AppointmentHistoryScreen()
          : const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Please Signin to see Appointment History",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyTextStyle1,
          ),
        ),
      ),
      HomeScreen(
        totalAppointmentsOnTap:
        Get.find<GeneralController>().storageBox.read('authToken') != null
            ? () {
          setState(
                  () => Get.find<GeneralController>().bottomNavIndex = 0);
        }
            : () {
          Get.find<GeneralController>().showMessageDialog(context);
        },
        userWaitingOnTap:
        Get.find<GeneralController>().storageBox.read('authToken') != null
            ? () {
          setState(
                  () => Get.find<GeneralController>().bottomNavIndex = 0);
        }
            : () {
          Get.find<GeneralController>().showMessageDialog(context);
        },
        pendingAppointmentsOnTap: () {
          setState(() => Get.find<GeneralController>().bottomNavIndex = 0);
        },
      ),
      Get.find<GeneralController>().storageBox.read('authToken') != null
          ? const WalletScreen()
          : const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Please Signin to see Wallet",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyTextStyle1,
          ),
        ),
      ),
    ];
    return GetBuilder<LoggedInUserController>(builder: (loggedInUserLogic) {
      return WillPopScope(
        onWillPop: () async => false,
        child: ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
          inAsyncCall: Get.find<GeneralController>().formLoaderController,
          child: Scaffold(
            backgroundColor: AppColors.white,
            key: scaffoldKey,
            body: Center(
              child: widgetScreens
                  .elementAt(Get.find<GeneralController>().bottomNavIndex),
            ),
            drawer: Drawer(
              backgroundColor: AppColors.offWhite,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                    gradient: AppColors.gradientOne),
                child: ListView(
                  children: [
                    DrawerHeader(
                      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: Divider.createBorderSide(context,
                                color: AppColors.white, width: 0.0),
                          )),
                      child: GetBuilder<GeneralController>(builder: (generalController) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // FIXED: use _buildProfileImage() to safely handle null loginInfo
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: _buildProfileImage(),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  generalController
                                      .storageBox
                                      .read('authToken') !=
                                      null
                                      ? Text(
                                    "${generalController.currentTeacherModel?.name ?? ''} ",
                                    style: AppTextStyles.bodyTextStyle5,
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      Get.toNamed(PageRoutes.signinScreen);
                                    },
                                    child: Text(
                                      LanguageConstant.signIn.tr,
                                      style: AppTextStyles.bodyTextStyle5,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    generalController
                                        .storageBox
                                        .read('authToken') !=
                                        null
                                        ? "${generalController.currentTeacherModel?.email ?? ''} "
                                        : "",
                                    style: AppTextStyles.subHeadingTextStyle3,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Get.find<GeneralController>()
                              .storageBox
                              .read('authToken') !=
                              null
                              ? ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/User.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.profile.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(
                                  PageRoutes.teacherProfileScreen);
                            },
                          )
                              : const SizedBox(),
                          ListTile(
                              isThreeLine: false,
                              dense: true,
                              visualDensity: const VisualDensity(
                                  vertical: -1, horizontal: -3),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 0),
                              leading: const ImageIcon(
                                AssetImage("assets/icons/Folders_light.png"),
                                color: AppColors.white,
                              ),
                              title: Text(
                                LanguageConstant.appointmentHistory.tr,
                                style: AppTextStyles.subHeadingTextStyle2,
                              ),
                              onTap: Get.find<GeneralController>()
                                  .storageBox
                                  .read('authToken') !=
                                  null
                                  ? () {
                                setState(() =>
                                Get.find<GeneralController>()
                                    .bottomNavIndex = 0);
                                Get.back();
                              }
                                  : () {
                                Get.find<GeneralController>()
                                    .showMessageDialog(context);
                              }),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/Folders_light.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.bookedServices.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: Get.find<GeneralController>()
                                .storageBox
                                .read('authToken') !=
                                null
                                ? () {
                              Get.toNamed(
                                  PageRoutes.bookedServicesScreen);
                            }
                                : () {
                              Get.find<GeneralController>()
                                  .showMessageDialog(context);
                            },
                          ),
                          ListTile(
                              isThreeLine: false,
                              dense: true,
                              visualDensity: const VisualDensity(
                                  vertical: -1, horizontal: -3),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 0),
                              leading: const ImageIcon(
                                AssetImage("assets/icons/Folders_light.png"),
                                color: AppColors.white,
                              ),
                              title: Text(
                                LanguageConstant.pricingPlan.tr,
                                style: AppTextStyles.subHeadingTextStyle2,
                              ),
                              onTap: Get.find<GeneralController>()
                                  .storageBox
                                  .read('authToken') !=
                                  null
                                  ? () {
                                Get.to(const WebViewScreen(
                                  fromScreen: "Appointment Screen",
                                ));
                              }
                                  : () {
                                Get.find<GeneralController>()
                                    .showMessageDialog(context);
                              }),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/language-icon.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.languages.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.languagesScreen);
                            },
                          ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/blog-icon.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.blogs.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.blogsScreen);
                            },
                          ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/Group.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.aboutUs.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.aboutusScreen);
                            },
                          ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/Message.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.contactUs.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.contactusScreen);
                            },
                          ),
                          ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage("assets/icons/Chield_alt.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.privacyPolicy.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              Get.toNamed(PageRoutes.privacyPolicyScreen);
                            },
                          ),

                          Get.find<GeneralController>()
                              .storageBox
                              .read('authToken') !=
                              null
                              ? ListTile(
                            isThreeLine: false,
                            dense: true,
                            visualDensity: const VisualDensity(
                                vertical: -1, horizontal: -3),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            leading: const ImageIcon(
                              AssetImage(
                                  "assets/icons/Sign_out_circle.png"),
                              color: AppColors.white,
                            ),
                            title: Text(
                              LanguageConstant.logOut.tr,
                              style: AppTextStyles.subHeadingTextStyle2,
                            ),
                            onTap: () {
                              signOutUserLogic
                                  .updateSignOutLoaderController(true);
                              getMethod(context, signOutURL, null, true,
                                  signOutUserRepo);
                            },
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: SnakeNavigationBar.gradient(
              backgroundGradient: AppColors.gradientOne,

              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage("assets/icons/Folders_light.png"),
                    size: 22,
                    color: AppColors.white,
                  ),
                  label: LanguageConstant.appointmentHistory.tr,
                ),
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage("assets/icons/Home.png"),
                    size: 22,
                    color: AppColors.white,
                  ),
                  label: LanguageConstant.home.tr,
                ),
                BottomNavigationBarItem(
                  icon: const ImageIcon(
                    AssetImage("assets/icons/Wallet_alt.png"),
                    size: 22,
                    color: AppColors.white,
                  ),
                  label: LanguageConstant.wallet.tr,
                ),
              ],
              selectedLabelStyle: AppTextStyles.bodyTextStyle4,
              unselectedLabelStyle: AppTextStyles.bodyTextStyle5,
              behaviour: SnakeBarBehaviour.pinned,
              snakeShape: SnakeShape.indicator,
              padding: EdgeInsets.zero,
              snakeViewGradient: AppColors.gradientFour,
              selectedItemGradient: SnakeShape.rectangle == SnakeShape.indicator
                  ? AppColors.gradientOne
                  : null,
              unselectedItemGradient: AppColors.gradientFour,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              currentIndex: Get.find<GeneralController>().bottomNavIndex,
              onTap: (index) => setState(
                      () => Get.find<GeneralController>().bottomNavIndex = index),
            ),
          ),
        ),
      );
    });
  }
}