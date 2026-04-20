import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../api_services/post_service.dart';
import '../models/teacher_appointment_history_model.dart';
import 'general_controller.dart';

class TeacherAppointmentHistoryController extends GetxController {
  GetTeacherAppointmentHistoryModel getTeacherAppointmentHistoryModel =
      GetTeacherAppointmentHistoryModel();

  bool allTeacherAppointmentHistoryLoader = false;
  updateTeacherAppointmentHistoryLoader(bool newValue) {
    allTeacherAppointmentHistoryLoader = newValue;
    update();
  }

  String? selectedTeacherCategory;
  // TeacherModel selectedTeacherForView = TeacherModel();
  GetTeacherAppointmentHistoryDataModel getTeacherAppointmentHistoryDataModel =
      GetTeacherAppointmentHistoryDataModel();

  List<TeacherAppointmentHistoryModel>
      teacherAllAppointmentHistoryListForPagination = [];

  // updateSelectedTeacherForView(
  //   TeacherModel newValue,
  // ) {
  //   selectedTeacherForView = newValue;

  //   update();
  // }

  ///------------------------------- Teachers-data-check
  bool getTeacherAppointmentHistoryDataCheck = false;
  getTeacherAppointmentHistorysDataCheck(bool value) {
    getTeacherAppointmentHistoryDataCheck = value;
    update();
  }

  int? selectedTeacherCategoryIndex = 0;
  updateSelectedTeacherCategoryIndex(int? newValue) {
    selectedTeacherCategoryIndex = newValue;
    update();
  }

  /// paginated-data-fetch
  Future paginationDataLoad(BuildContext context) async {
    // perform fetching data delay
    // await new Future.delayed(new Duration(seconds: 2));

    log("load more");
    // update data and loading status
    if (getTeacherAppointmentHistoryModel.data!.meta!.lastPage! >
        getTeacherAppointmentHistoryModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      // postMethod(
      //     context,
      //     '${getTeacherAppointmentHistoryModel.data!.meta!.path}',
      //     {
      //       'page':
      //           (getTeacherAppointmentHistoryModel.data!.meta!.currentPage! +
      //               1),
      //       'perPage': getTeacherAppointmentHistoryModel.data!.meta!.perPage
      //     },
      //     false,
      //     getAllTeachersRepo);
      update();
    }
  }

  updateTeacherListForPagination(
      TeacherAppointmentHistoryModel teacherAppointmentHistoryModel) {
    teacherAllAppointmentHistoryListForPagination
        .add(teacherAppointmentHistoryModel);
    update();
  }

  ///----app-bar-settings-----start
  ScrollController? scrollController;
  bool lastStatus = true;
  double height = 100.h;

  bool get isShrink {
    return scrollController!.hasClients &&
        scrollController!.offset > (height - kToolbarHeight);
  }

  void scrollListener() {
    if (isShrink != lastStatus) {
      lastStatus = isShrink;
      update();
    }
  }
}
