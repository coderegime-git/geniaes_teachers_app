import 'package:get/get.dart';
import '../../controllers/all_settings_controller.dart';

/// Agora App ID — read dynamically from settings API on every access.
/// Using a getter (not a final variable) prevents stale/empty values
/// that occur when the variable is evaluated before settings finish loading.
String get agoraAppId =>
    Get.find<GetAllSettingsController>()
        .getAllSettingsModel
        .data
        ?.agoraAppId ??
    "";
