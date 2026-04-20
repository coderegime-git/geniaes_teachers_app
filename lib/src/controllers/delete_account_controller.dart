import 'package:get/get.dart';

class DeleteAccountController extends GetxController {
  bool deleteAccountLoader = false;
  updateDeleteAccountLoader(bool newValue) {
    deleteAccountLoader = newValue;
    update();
  }
}
