// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:teacher_consultant/src/widgets/button_widget.dart';
// import 'package:resize/resize.dart';

// import '../config/app_colors.dart';
// import '../config/app_text_styles.dart';

// class TeacherCardWidget extends StatelessWidget {
//   final String teacherName, teacherCategoriesName, teacherDegrees, teacherRating;
//   final Image teacherImage;
//   final double teacherInitialRating;
//   final VoidCallback profileOnTap;
//   const TeacherCardWidget(
//       {super.key,
//       required this.teacherImage,
//       required this.teacherName,
//       required this.teacherCategoriesName,
//       required this.teacherDegrees,
//       required this.teacherRating,
//       required this.teacherInitialRating,
//       required this.profileOnTap});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//       margin: const EdgeInsets.only(bottom: 18),
//       decoration: BoxDecoration(
//         color: AppColors.offWhite,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         // mainAxisSize: MainAxisSize.min,
//         children: [
//           ClipRRect(
//               borderRadius: BorderRadius.circular(18),
//               // ignore: unrelated_type_equality_checks
//               child: teacherImage),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 // mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     teacherName,
//                     textAlign: TextAlign.start,
//                     style: AppTextStyles.bodyTextStyle2,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     teacherCategoriesName,
//                     textAlign: TextAlign.start,
//                     style: AppTextStyles.bodyTextStyle3,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     teacherDegrees,
//                     textAlign: TextAlign.start,
//                     style: AppTextStyles.bodyTextStyle4,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             RatingBar.builder(
//                               initialRating: teacherInitialRating,
//                               minRating: 1,
//                               itemSize: 15.h,
//                               direction: Axis.horizontal,
//                               allowHalfRating: true,
//                               itemCount: 5,
//                               ignoreGestures: true,
//                               itemPadding:
//                                   const EdgeInsets.symmetric(horizontal: 0.0),
//                               itemBuilder: (context, _) => const Icon(
//                                 Icons.star,
//                                 color: Colors.amber,
//                               ),
//                               onRatingUpdate: (double value) {},
//                             ),
//                             SizedBox(width: 5.w),
//                             Text(
//                               // '4.5',
//                               teacherRating,
//                               textAlign: TextAlign.start,
//                               style: AppTextStyles.bodyTextStyle4,
//                             ),
//                           ],
//                         ),
//                         ButtonWidgetOne(
//                           buttonText: 'Profile',
//                           onTap: profileOnTap,
//                           buttonTextStyle: AppTextStyles.buttonTextStyle2,
//                           borderRadius: 5,
//                           buttonColor: AppColors.secondaryColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
