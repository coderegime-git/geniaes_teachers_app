import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class ButtonWidgetOne extends StatelessWidget {
  final VoidCallback onTap;
  final Gradient buttonColor;
  final String buttonText;
  final TextStyle buttonTextStyle;
  final double borderRadius;

  const ButtonWidgetOne({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.buttonTextStyle,
    required this.borderRadius,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 0.5,
              blurRadius: 4,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: buttonColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: buttonTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonWidgetTwo extends StatelessWidget {
  final VoidCallback onTap;
  final Gradient buttonColor;
  final String buttonText, buttonIcon;
  final TextStyle buttonTextStyle;
  final double borderRadius;
  final double iconHeight;

  const ButtonWidgetTwo({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.buttonTextStyle,
    required this.borderRadius,
    required this.buttonColor,
    required this.buttonIcon,
    required this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: buttonColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              buttonIcon,
              height: iconHeight,
            ),
            SizedBox(width: 4.w),
            Text(
              buttonText,
              style: buttonTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonWidgetThree extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText, buttonIcon;
  final double iconHeight;
  const ButtonWidgetThree({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.buttonIcon,
    required this.iconHeight,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0.5,
              blurRadius: 4,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Image.asset(
          buttonIcon,
          // "assets/icons/Google.png",
          height: iconHeight,
        ),
      ),
    );
  }
}

class ButtonWidgetFour extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  final Color innerBorderColor;
  final Gradient? outerBorderColor;
  final Widget? icon;

  const ButtonWidgetFour({
    super.key,
    required this.onTap,
    this.buttonText = "",
    required this.innerBorderColor,
    this.icon,
    this.outerBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            buttonText,
            style: AppTextStyles.buttonTextStyle4,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(2.w, 2.h, 2.w, 2.h),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: outerBorderColor ?? AppColors.gradientFive),
            child: Container(
              padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 4.h),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: innerBorderColor, width: 2.w),
                  color: AppColors.primaryColor),
              child: icon ??
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.white,
                    size: 18,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonWidgetFive extends StatelessWidget {
  final VoidCallback onTap;
  final Color? buttonColor, buttonIconColor;
  final IconData buttonIcon;
  final TextStyle buttonTextStyle;
  final double borderRadius, iconSize;

  const ButtonWidgetFive({
    super.key,
    required this.onTap,
    required this.buttonIcon,
    required this.buttonTextStyle,
    required this.borderRadius,
    required this.buttonColor,
    required this.iconSize,
    this.buttonIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: buttonColor),
        child: Icon(buttonIcon,
            size: iconSize, color: buttonIconColor ?? AppColors.black),
      ),
    );
  }
}

class ButtonWidgetSix extends StatelessWidget {
  final VoidCallback onTap;
  final Color buttonColor;
  final String buttonText;
  final TextStyle buttonTextStyle;
  final double borderRadius;

  const ButtonWidgetSix({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.buttonTextStyle,
    required this.borderRadius,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: buttonColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: buttonTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonWidgetSeven extends StatelessWidget {
  final VoidCallback onTap;

  final Color buttonIconColor;
  final IconData buttonIcon;

  final double iconSize;

  const ButtonWidgetSeven({
    super.key,
    required this.onTap,
    required this.buttonIconColor,
    required this.buttonIcon,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(buttonIcon, size: iconSize, color: buttonIconColor),
    );
  }
}
