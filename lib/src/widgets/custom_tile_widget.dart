import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class CustomTileWidgetOne extends StatelessWidget {
  final VoidCallback onTap;
  final String tileTitle, leadingIcon;
  final Color tileColor;
  const CustomTileWidgetOne({
    super.key,
    required this.onTap,
    required this.tileTitle,
    required this.tileColor,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 12.h),
      child: ListTile(
        dense: true,
        onTap: onTap,
        tileColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Image.asset(
          leadingIcon,
          height: 20.h,
          color: AppColors.white,
        ),
        title: Text(
          tileTitle,
          style: AppTextStyles.bodyTextStyle19,
        ),
        trailing: Container(
          padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 6.h),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 0.6,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              color: AppColors.primaryColor),
          child: const Icon(
            Icons.arrow_forward,
            color: AppColors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class CustomTileWidgetTwo extends StatelessWidget {
  final VoidCallback onTap;
  final String tileTitle;
  final Color tileColor;
  const CustomTileWidgetTwo({
    super.key,
    required this.onTap,
    required this.tileTitle,
    required this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
        margin: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 12.h),
        decoration: BoxDecoration(
            color: tileColor, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tileTitle,
              style: AppTextStyles.bodyTextStyle19,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 6.h),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0.6,
                      blurRadius: 4,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: AppColors.primaryColor),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
