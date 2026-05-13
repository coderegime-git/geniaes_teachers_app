import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'button_widget.dart';
import 'package:get/get.dart';

class RatingDialog extends StatefulWidget {
  final Function(int rating, String comment) onSubmit;

  const RatingDialog({super.key, required this.onSubmit});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LanguageConstant.rating.tr,
                  style: AppTextStyles.headingTextStyle1,
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          index < _selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 32.h,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20.h),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: LanguageConstant.additionalNotes.tr,
                    hintStyle: AppTextStyles.hintTextStyle1,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                ButtonWidgetOne(
                  onTap: () {
                    widget.onSubmit(_selectedRating, _commentController.text);
                    Navigator.pop(context);
                  },
                  buttonText: LanguageConstant.submit.tr,
                  buttonTextStyle: AppTextStyles.buttonTextStyle1,
                  borderRadius: 40,
                  buttonColor: AppColors.gradientOne,
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, color: AppColors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
