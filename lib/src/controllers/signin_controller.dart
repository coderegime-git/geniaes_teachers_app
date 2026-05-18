import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../multi_language/language_constants.dart';
import '../api_services/post_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../models/signin_user_model.dart';
import '../repositories/signin_repo.dart';
import '../widgets/custom_dialog.dart';

class SigninController extends GetxController {
  String? emailValidator;
  String? passwordValidator;

  GetSignInUserModel signInUserModel =
      GetSignInUserModel(); //  for saving login-data

  final GlobalKey<FormState> _loginFromKey = GlobalKey();
  GlobalKey<FormState> get loginFromKey => _loginFromKey;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Signin with Facebook
  Future<void> signinWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(permissions: ["email", "public_profile"]);
      if (result.accessToken == null) return;
      if (result.status == LoginStatus.success) {
        Map<String, dynamic> userData = await FacebookAuth.instance.getUserData(
            fields: "email,first_name,last_name,picture.width(200)");

        postMethod(
            Get.context!,
            socialLoginURL,
            {
              'email': userData["email"],
              'first_name': userData["first_name"],
              'last_name': userData["last_name"],
              'login_as': "teacher",
              // 'id': userData["id"],
            },
            false,
            socialSignInWithEmailRepo);
      }
    } on PlatformException catch (e) {
      log("Error: ${e.toString()}");
    } on SocketException catch (e) {
      log("Error: ${e.toString()}");
    }
  }

  /// Signin with Google
  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      if (googleSignInAuthentication?.accessToken == null) {
        return;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;

      if (user != null) {
        String fullName = user.displayName ?? '';
        List<String> nameParts = fullName.split(' ');
        String firstName = nameParts.isNotEmpty ? nameParts.first : '';
        String lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        postMethod(
          Get.context!,
          socialLoginURL,
          {
            'email': user.email,
            'first_name': firstName,
            'last_name': lastName,
            'login_as': "teacher",
          },
          false,
          socialSignInWithEmailRepo,
        );
      }
    } catch (e) {
      print('Google Login Error: $e');
      showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: LanguageConstant.pleaseTryAgain.tr,
              titleColor: AppColors.customDialogErrorColor,
              descriptions: '$e',
              text: LanguageConstant.ok.tr,
              functionCall: () {
                Navigator.pop(context);
              },
              img: 'assets/icons/dialog_error.png',
            );
          });
    }
  }
}
