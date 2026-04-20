import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:tutorhub_for_teachers/src/widgets/button_widget.dart';

import '../config/app_colors.dart';
import '../config/app_font.dart';
import '../config/app_text_styles.dart';

class CustomDialogBox extends StatefulWidget {
  final String? title, descriptions, text;
  final String? img;
  final Color? titleColor;
  final Function? functionCall;

  const CustomDialogBox(
      {Key? key,
      this.title,
      this.descriptions,
      this.text,
      this.img,
      this.titleColor,
      this.functionCall})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppColors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget.title == null
                  ? const SizedBox()
                  : Text(
                      widget.title!,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: widget.titleColor,
                          fontFamily: AppFont.primaryFontFamily),
                    ),
              widget.title == null
                  ? const SizedBox()
                  : const SizedBox(
                      height: 15,
                    ),
              Text(
                widget.descriptions!,
                style: AppTextStyles.bodyTextStyle10,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22.h,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonWidgetOne(
                    onTap: () => widget.functionCall!(),
                    buttonText: widget.text!,
                    buttonTextStyle: AppTextStyles.buttonTextStyle1,
                    borderRadius: 40,
                    buttonColor: AppColors.gradientOne),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Constants.avatarRadius)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('${widget.img}'),
                )),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 20;
  static const double avatarRadius = 45;
}
