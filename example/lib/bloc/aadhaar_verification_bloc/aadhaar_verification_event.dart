// aadhaar_verification_event.dart
import 'package:equatable/equatable.dart';

abstract class AadhaarVerificationEvent extends Equatable {
  const AadhaarVerificationEvent();

  @override
  List<Object?> get props => [];
}

class RequestOtpEvent extends AadhaarVerificationEvent {
  final String aadhaarNumber;
  final String auaCode;
  final String subAuaCode;
  final String licenseKey;
  final String asaLicenseKey;

  const RequestOtpEvent({
    required this.aadhaarNumber,
    required this.auaCode,
    required this.subAuaCode,
    required this.licenseKey,
    required this.asaLicenseKey,
  });

  @override
  List<Object> get props =>
      [aadhaarNumber, auaCode, subAuaCode, licenseKey, asaLicenseKey];
}

class VerifyOtpEvent extends AadhaarVerificationEvent {
  final String aadhaarNumber;
  final String otp;
  final String transactionId;
  final String auaCode;
  final String subAuaCode;
  final String licenseKey;
  final String asaLicenseKey;

  const VerifyOtpEvent({
    required this.aadhaarNumber,
    required this.otp,
    required this.transactionId,
    required this.auaCode,
    required this.subAuaCode,
    required this.licenseKey,
    required this.asaLicenseKey,
  });

  @override
  List<Object> get props => [
        aadhaarNumber,
        otp,
        transactionId,
        auaCode,
        subAuaCode,
        licenseKey,
        asaLicenseKey
      ];
}

class ResendOtpEvent extends AadhaarVerificationEvent {
  final String aadhaarNumber;
  final String auaCode;
  final String subAuaCode;
  final String licenseKey;
  final String asaLicenseKey;

  const ResendOtpEvent({
    required this.aadhaarNumber,
    required this.auaCode,
    required this.subAuaCode,
    required this.licenseKey,
    required this.asaLicenseKey,
  });

  @override
  List<Object> get props =>
      [aadhaarNumber, auaCode, subAuaCode, licenseKey, asaLicenseKey];
}

class ResetVerificationEvent extends AadhaarVerificationEvent {}

class StartResendTimerEvent extends AadhaarVerificationEvent {}

class UpdateResendTimerEvent extends AadhaarVerificationEvent {
  final int remainingTime;

  const UpdateResendTimerEvent(this.remainingTime);

  @override
  List<Object> get props => [remainingTime];
}
