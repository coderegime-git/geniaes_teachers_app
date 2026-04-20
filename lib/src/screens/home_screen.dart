import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

import '../controllers/general_controller.dart';
import '../controllers/teacher_appointment_history_controller.dart';
import '../repositories/appointment_status_update_repo.dart';
import '../routes.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/appointment_card_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/teacher_profile_widgets.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback userWaitingOnTap,
      pendingAppointmentsOnTap,
      totalAppointmentsOnTap;
  const HomeScreen(
      {super.key,
      required this.userWaitingOnTap,
      required this.pendingAppointmentsOnTap,
      required this.totalAppointmentsOnTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int isTeacherListSelected = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    // print(
    //     "${Get.find<EditProfileController>().getTeacherProfileEducationModel.data!.data!.isNotEmpty} EDUCATIONHAI");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return Scaffold(
        backgroundColor: AppColors.bgColorTwo,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150.h),
          child: Stack(
            children: [
              AppBarWidgetTwo(
                leadingIcon: "assets/icons/Sort.png",
                leadingOnTap: () {
                  Scaffold.of(context).openDrawer();
                },
                searchOnTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(top: 150.h),
                child: Container(
                  height: 40.h,
                  decoration: const BoxDecoration(color: AppColors.bgColorTwo),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 130.h),
                  child: generalController.storageBox.read('authToken') != null
                      ? Container(
                          padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 12.h),
                          margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 0.5,
                                blurRadius: 4,
                                offset: const Offset(
                                    0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LanguageConstant.status.tr,
                                style: AppTextStyles.bodyTextStyle6,
                              ),
                              generalController.currentTeacherModel?.loginInfo!
                                              .isOnline ==
                                          1 ||
                                      generalController.currentTeacherModel!
                                              .loginInfo?.isOnline !=
                                          0
                                  ? Row(
                                      children: [
                                        Text(
                                          LanguageConstant.online.tr,
                                          style: AppTextStyles.bodyTextStyle6,
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          height: 10.h,
                                          width: 10.w,
                                          decoration: const BoxDecoration(
                                            color: AppColors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          LanguageConstant.offline.tr,
                                          style: AppTextStyles.bodyTextStyle6,
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          height: 10.h,
                                          width: 10.w,
                                          decoration: const BoxDecoration(
                                            color: AppColors.lightGrey,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      ],
                                    )
                            ],
                          ),
                        )
                      : const Text(
                          "",
                          style: AppTextStyles.bodyTextStyle6,
                        )),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 9.h, 0, 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Get.find<GeneralController>().storageBox.read('authToken') !=
                        null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 0),
                            child: Text(
                              LanguageConstant.completeYourProfile.tr,
                              style: AppTextStyles.headingTextStyle1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 0),
                            child: Text(
                              LanguageConstant
                                  .ourTeamOfHighlySkilledAttorneysComprisesSeasoned
                                  .tr,
                              style: AppTextStyles.subHeadingTextStyle5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ProfileCompletionBarWidget(),
                                ButtonWidgetFour(
                                  buttonText: "",
                                  onTap: () {
                                    Get.toNamed(
                                        PageRoutes.teacherProfileScreen);
                                  },
                                  innerBorderColor: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                            child: Divider(
                              color: AppColors.lightGrey.withOpacity(0.5),
                              height: 2.h,
                              thickness: 1.5.h,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        LanguageConstant.pendingAppointments.tr,
                        style: AppTextStyles.headingTextStyle1,
                      ),
                      GestureDetector(
                        onTap: widget.pendingAppointmentsOnTap,
                        child: Text(
                          LanguageConstant.seeAll.tr,
                          style: AppTextStyles.headingTextStyle2,
                        ),
                      ),
                    ],
                  ),
                ),
                Get.find<TeacherAppointmentHistoryController>()
                        .teacherAllAppointmentHistoryListForPagination
                        .where((i) => i.appointmentStatusName == "Pending")
                        .toList()
                        .isNotEmpty
                    ? CarouselSlider(
                        items: List.generate(
                            Get.find<TeacherAppointmentHistoryController>()
                                .teacherAllAppointmentHistoryListForPagination
                                .where(
                                    (i) => i.appointmentStatusName == "Pending")
                                .toList()
                                .length, (index) {
                          return AppointmentCardWidgetTwo(
                            studentName: Get.find<
                                        TeacherAppointmentHistoryController>()
                                    .teacherAllAppointmentHistoryListForPagination
                                    .where((i) =>
                                        i.appointmentStatusName == "Pending")
                                    .toList()[index]
                                    .studentName ??
                                "",
                            studentImage: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Get.find<TeacherAppointmentHistoryController>()
                                          .teacherAllAppointmentHistoryListForPagination
                                          .where((i) =>
                                              i.appointmentStatusName ==
                                              "Pending")
                                          .toList()[index]
                                          .studentImage
                                          ?.length !=
                                      null
                                  ? Image(
                                      image: NetworkImage(
                                          "$mediaUrl${Get.find<TeacherAppointmentHistoryController>().teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusName == "Pending").toList()[index].studentImage}"),
                                      height: 70.h,
                                      errorBuilder: (context, error, stackTrace) => Image(
                                        image: const AssetImage('assets/images/teacher-image.png'),
                                        height: 70.h,
                                      ),
                                    )
                                  : Image(
                                      image: const AssetImage(
                                          'assets/images/teacher-image.png'),
                                      height: 70.h,
                                    ),
                            ),
                            dateAndTime:
                                "${Get.find<TeacherAppointmentHistoryController>().teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusName == "Pending").toList()[index].date!} (${Get.find<TeacherAppointmentHistoryController>().teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusName == "Pending").toList()[index].startTime ?? ""} - ${Get.find<TeacherAppointmentHistoryController>().teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusName == "Pending").toList()[index].endTime ?? ""})",
                            appoinmentTypeName: Get.find<
                                    TeacherAppointmentHistoryController>()
                                .teacherAllAppointmentHistoryListForPagination
                                .where(
                                    (i) => i.appointmentStatusName == "Pending")
                                .toList()[index]
                                .appointmentTypeName!,
                            onCardTap: widget.userWaitingOnTap,
                            onAcceptTap: () {
                              Get.find<GeneralController>()
                                  .updateAppointmentStatusLoaderController(
                                      true);
                              postMethod(
                                  context,
                                  "$updateAppointmentStatusCodeURL${Get.find<TeacherAppointmentHistoryController>().teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusName == "Pending").toList()[index].id}",
                                  {"appointment_status_code": 2},
                                  true,
                                  appointmentStatusUpdateRepo);
                            },
                            onRejectTap: () {
                              Get.find<GeneralController>()
                                  .updateAppointmentStatusLoaderController(
                                      true);
                              postMethod(
                                  context,
                                  "$updateAppointmentStatusCodeURL${Get.find<TeacherAppointmentHistoryController>().teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusName == "Pending").toList()[index].id}",
                                  {"appointment_status_code": 3},
                                  true,
                                  appointmentStatusUpdateRepo);
                            },
                          );
                        }),
                        carouselController: _controller,
                        options: CarouselOptions(
                            autoPlay: false,
                            aspectRatio: 2.2 / 1,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.5,
                            viewportFraction: 0.88,
                            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                            onPageChanged: (index, reason) {
                              setState(() {});
                            }),
                      )
                    : Container(
                        padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 32.h),
                        margin: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 18.h),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientSix,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 7,
                              blurRadius: 10,
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            LanguageConstant.noPendingAppointmentsYets.tr,
                            style: AppTextStyles.bodyTextStyle19,
                          ),
                        ),
                      ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.h, 0.w, 18.h, 0.w),
                  child: ListTile(
                    dense: true,
                    onTap: widget.userWaitingOnTap,
                    tileColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    leading: Image.asset(
                      "assets/icons/User.png",
                      color: AppColors.white,
                      height: 24.h,
                    ),
                    title: Text(
                      "${Get.find<TeacherAppointmentHistoryController>().teacherAllAppointmentHistoryListForPagination.where((i) => i.appointmentStatusName == "Accepted").toList().length}  ${LanguageConstant.userWaiting.tr}",
                      style: AppTextStyles.bodyTextStyle19,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.fromLTRB(18.h, 0.w, 18.h, 0.w),
                  child: ListTile(
                    dense: true,
                    onTap: widget.totalAppointmentsOnTap,
                    tileColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    leading: Image.asset(
                      "assets/icons/Folders_light.png",
                      color: AppColors.white,
                    ),
                    title: Text(
                      "${Get.find<TeacherAppointmentHistoryController>().teacherAllAppointmentHistoryListForPagination.length}  ${LanguageConstant.totalAppointments.tr}",
                      style: AppTextStyles.bodyTextStyle19,
                    ),
                  ),
                ),
                SizedBox(height: 45.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
