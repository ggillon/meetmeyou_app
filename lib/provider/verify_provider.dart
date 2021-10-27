import 'package:meetmeyou_app/provider/base_provider.dart';

class VerifyProvider extends BaseProvider{
  bool _correctOtp = true;
  bool get correctOtp => _correctOtp;

  void updateOtpStatus(bool value) {
    _correctOtp = value;
    notifyListeners();
  }
}