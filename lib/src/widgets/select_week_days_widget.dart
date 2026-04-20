import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';

class SelectWeekDays extends StatefulWidget {
  /// [onSelect] callBack to handle the Selected days
  final Function onSelect;

  /// List of days of type `DayInWeek`
  final List<DayInWeek> days;

  /// [backgroundColor] - property to change the color of the container.
  final Color? backgroundColor;

  /// [fontWeight] - property to change the weight of selected text
  final FontWeight? fontWeight;

  /// [fontSize] - property to change the size of selected text
  final double? fontSize;

  /// [fontFamily] - property to change the size of selected text
  final String? fontFamily;

  /// [daysFillColor] -  property to change the button color of days when the button is pressed.
  final Gradient? daysFillColor;

  /// [daysBorderColor] - property to change the border color of the rounded buttons.
  final Color? daysBorderColor;

  /// [selectedDayTextColor] - property to change the color of text when the day is selected.
  final Color? selectedDayTextColor;

  /// [unSelectedDayTextColor] - property to change the text color when the day is not selected.
  final Color? unSelectedDayTextColor;

  /// [border] Boolean to handle the day button border by default the border will be true.
  final bool border;

  /// [boxDecoration] to handle the decoration of the container.
  final BoxDecoration? boxDecoration;

  /// [padding] property  to handle the padding between the container and buttons by default it is 8.0
  final double padding;

  /// The property that can be used to specify the [width] of the [SelectWeekDays] container.
  /// By default this property will take the full width of the screen.
  final double? width;

  /// `SelectWeekDays` takes a list of days of type `DayInWeek`.
  /// `onSelect` property will return `list` of days that are selected.
  SelectWeekDays({
    required this.onSelect,
    this.backgroundColor,
    this.fontWeight,
    this.fontSize,
    this.daysFillColor,
    this.daysBorderColor,
    this.selectedDayTextColor,
    this.unSelectedDayTextColor,
    this.border = true,
    this.boxDecoration,
    this.padding = 8.0,
    this.width,
    required this.days,
    super.key,
    this.fontFamily,
  });

  @override
  SelectWeekDaysState createState() => SelectWeekDaysState(days);
}

class SelectWeekDaysState extends State<SelectWeekDays> {
  SelectWeekDaysState(List<DayInWeek> days) : _daysInWeek = days;

  // list to insert the selected days.
  List<String> selectedDays = [];

  // list of days in a week.
  List<DayInWeek> _daysInWeek = [];

  @override
  void initState() {
    _daysInWeek.forEach((element) {
      if (element.isSelected) {
        selectedDays.add(element.dayKey);
      }
    });
    super.initState();
  }

  /// Set days to new value
  void setDaysState(List<DayInWeek> newDays) {
    selectedDays = [];
    for (DayInWeek dayInWeek in newDays) {
      if (dayInWeek.isSelected) {
        selectedDays.add(dayInWeek.dayKey);
      }
    }
    setState(() {
      _daysInWeek = newDays;
    });
  }

  void _getSelectedWeekDays(bool isSelected, bool isDisabled, String day) {
    if (isSelected == true) {
      if (!selectedDays.contains(day)) {
        selectedDays.add(day);
      }
    } else if (isSelected == false) {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      }
    }

    // if (selectedDays.contains(day)) {
    //   log("CONTAINS");
    //   selectedDays
    //       .remove(Get.find<GetAppoinmentSchedulesController>().selectedDays);
    // }
    // [onSelect] is the callback which passes the Selected days as list.
    widget.onSelect(selectedDays.toList());
  }

// getter to handle background color of container.
  Color? get _handleBackgroundColor {
    if (widget.backgroundColor == null) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return widget.backgroundColor;
    }
  }

// getter to handle fill color of buttons.
  Gradient? get _handleDaysFillColor {
    if (widget.daysFillColor == null) {
      return AppColors.gradientOne;
    } else {
      return widget.daysFillColor;
    }
  }

//getter to handle border color of days[buttons].
  Color? get _handleBorderColorOfDays {
    if (widget.daysBorderColor == null) {
      return AppColors.white;
    } else {
      return widget.daysBorderColor;
    }
  }

// Handler to change the text color when the button is pressed and not pressed.
  Color? _handleTextColor(bool onSelect) {
    Color? textColor = Colors.black;
    if (onSelect == true) {
      if (widget.selectedDayTextColor == null) {
        textColor = AppColors.white;
      } else {
        textColor = widget.selectedDayTextColor;
      }
    } else if (onSelect == false) {
      if (widget.unSelectedDayTextColor == null) {
        textColor = AppColors.textColorOne;
      } else {
        textColor = widget.unSelectedDayTextColor;
      }
    }
    return textColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _daysInWeek.map(
            (day) {
              return Expanded(
                child: GestureDetector(
                  onTap: day.isDisabled
                      ? () {
                          final snackBar = SnackBar(
                            content: Text(
                              'This day has already time slots.',
                              style: TextStyle(
                                fontFamily: widget.fontFamily,
                                fontSize: 14.sp,
                                fontWeight: widget.fontWeight,
                                color: AppColors.white,
                              ),
                            ),
                            backgroundColor: (AppColors.secondaryColor),
                            behavior: SnackBarBehavior.floating,
                            elevation: 10,
                            // action: SnackBarAction(
                            //   label: 'dismiss',
                            //   onPressed: () {},
                            // ),
                            margin: const EdgeInsets.all(8),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      : () {
                          setState(() {
                            day.toggleIsSelected();
                          });
                          _getSelectedWeekDays(
                              day.isSelected, day.isDisabled, day.dayKey);
                        },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0.w, 15.h, 0.w, 15.h),
                        margin: EdgeInsets.fromLTRB(3.w, 0.h, 3.w, 0.h),
                        decoration: BoxDecoration(
                          gradient: day.isSelected
                              ? _handleDaysFillColor
                              : AppColors.gradientFour,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            day.dayName.length < 3
                                ? day.dayName
                                : day.dayName.substring(0, 3),
                            style: TextStyle(
                              fontFamily: widget.fontFamily,
                              fontSize: widget.fontSize,
                              fontWeight: widget.fontWeight,
                              color: _handleTextColor(day.isSelected),
                            ),
                          ),
                        ),
                      ),
                      day.isSelected
                          ? Positioned(
                              right: 2.w,
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.white,
                                    size: 16,
                                  )),
                            )
                          : Container(),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

// class DayInWeek {
//   String dayName;
//   String dayKey;

//   DayInWeek(this.dayName, {required this.dayKey});
// }
class DayInWeek {
  String dayName;
  String dayKey;
  bool isSelected = false;
  bool isDisabled = false;

  DayInWeek(this.dayName,
      {required this.dayKey, this.isSelected = false, this.isDisabled = false});

  void toggleIsSelected() {
    this.isSelected = !this.isSelected;
  }

  void toggleIsDisabled() {
    this.isDisabled = !this.isDisabled;
  }
}
