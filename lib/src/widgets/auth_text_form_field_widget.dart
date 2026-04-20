import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class AuthTextFormFieldWidget extends StatelessWidget {
  final String hintText;

  final String? errorText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String> validator;

  // final TextEditingController controller;
  AuthTextFormFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    required this.validator,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(30),
      shadowColor: Colors.grey.withOpacity(0.4),
      child: TextFormField(
          style: AppTextStyles.hintTextStyle1,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            fillColor: AppColors.white,
            filled: true,
            hintText: hintText,
            errorText: errorText,
            hintStyle: AppTextStyles.hintTextStyle1,
            labelStyle: AppTextStyles.hintTextStyle1,
            errorStyle: AppTextStyles.bodyTextStyle21,
            contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            isDense: true,
            border: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.transparent),
              borderRadius: BorderRadius.circular(30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.transparent),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.transparent),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          validator: validator),
    );
  }
}

class AuthPasswordFormFieldWidget extends StatelessWidget {
  final String hintText;

  final String? errorText;
  final Widget? suffixIcon;
  final bool? obsecureText;
  final TextEditingController controller;
  final VoidCallback suffixIconOnTap;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String> validator;

  // final TextEditingController controller;
  AuthPasswordFormFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    required this.validator,
    this.suffixIcon,
    required this.suffixIconOnTap,
    this.obsecureText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(30),
      shadowColor: Colors.grey.withOpacity(0.4),
      child: TextFormField(
          style: AppTextStyles.hintTextStyle1,
          controller: controller,
          onChanged: onChanged,
          obscureText: obsecureText!,
          decoration: InputDecoration(
            fillColor: AppColors.white,
            filled: true,
            hintText: hintText,
            errorText: errorText,
            hintStyle: AppTextStyles.hintTextStyle1,
            labelStyle: AppTextStyles.hintTextStyle1,
            errorStyle: AppTextStyles.bodyTextStyle21,
            contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            isDense: true,
            suffixIcon: InkWell(onTap: suffixIconOnTap, child: suffixIcon),
            border: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.transparent),
              borderRadius: BorderRadius.circular(30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.transparent),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.transparent),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          validator: validator),
    );
  }
}
