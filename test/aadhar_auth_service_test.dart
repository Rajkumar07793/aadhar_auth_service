import 'package:aadhar_auth_service/aadhar_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () async {
    expect(
      await AadhaarAuthService.requestOtp(
        aadhaarNumber: '',
        auaCode: '',
        subAuaCode: '',
        licenseKey: '',
        asaLicenseKey: '',
      ),
      {},
    );
  });
}
