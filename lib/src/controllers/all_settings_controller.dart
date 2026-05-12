import 'package:get/get.dart';
import '../models/all_settings_model.dart';

class GetAllSettingsController extends GetxController {
  GetAllSettingsModel getAllSettingsModel = GetAllSettingsModel();

  getDisplayAmount(amount) {
    if (getAllSettingsModel.data?.defaultCurrency != null) {
      var currency = getAllSettingsModel.data!.defaultCurrency!;
      var decimalPlaces = currency.decimalPlaces?.toInt() ?? 0;
      if (currency.direction == "ltr") {
        return '${currency.symbol}${amount.toStringAsFixed(decimalPlaces)}';
      } else if (currency.direction == "rtl") {
        return '${amount.toStringAsFixed(decimalPlaces)}${currency.symbol}';
      }
    }
    return amount.toString();
  }

  getDefaultCurrencySymbol() {
    return getAllSettingsModel.data?.defaultCurrency?.symbol ?? '';
  }

  bool getAllSettingsLoader = false;
  updateAllSettingsLoader(bool newValue) {
    getAllSettingsLoader = newValue;
    update();
  }
}
