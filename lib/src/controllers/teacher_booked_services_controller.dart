import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../models/teacher_booked_services_model.dart';
import 'general_controller.dart';

class TeacherBookedServicesController extends GetxController {
  GetTeacherBookedServicesModel getTeacherBookedServicesModel =
      GetTeacherBookedServicesModel();

  bool allTeacherBookedServicesLoader = false;
  updateTeacherBookedServicesLoader(bool newValue) {
    allTeacherBookedServicesLoader = newValue;
    update();
  }

  GetTeacherBookedServicesDataModel getTeacherBookedServicesDataModel =
      GetTeacherBookedServicesDataModel();

  List<TeacherBookedServiceModel> teacherAllBookedServicesListForPagination =
      [];

  ///------------------------------- Teachers-data-check
  bool getTeacherBookedServiceDataCheck = false;
  getTeacherBookedServicesDataCheck(bool value) {
    getTeacherBookedServiceDataCheck = value;
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
    if (getTeacherBookedServicesModel.data!.meta!.lastPage! >
        getTeacherBookedServicesModel.data!.meta!.currentPage!) {
      Get.find<GeneralController>().changeGetPaginationProgressCheck(true);

      update();
    }
  }

  updateTeacherListForPagination(
      TeacherBookedServiceModel teacherBookedServiceModel) {
    teacherAllBookedServicesListForPagination.add(teacherBookedServiceModel);
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
