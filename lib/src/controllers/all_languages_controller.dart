import 'package:get/get.dart';
import '../models/all_languages_model.dart';

class GetAllLanguagesController extends GetxController {
  GetAllLanguagesModel getAllLanguagesModel = GetAllLanguagesModel();

  bool getAllLanguagesLoader = false;
  updateAllLanguagesLoader(bool newValue) {
    getAllLanguagesLoader = newValue;
    update();
  }
}
