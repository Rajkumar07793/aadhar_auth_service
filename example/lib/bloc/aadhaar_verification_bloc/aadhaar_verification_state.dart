// aadhaar_verification_state.dart
import 'package:equatable/equatable.dart';

enum AadhaarVerificationStatus {
  initial,
  sendingOtp,
  otpSent,
  verifyingOtp,
  verified,
  error,
}

class AadhaarVerificationState extends Equatable {
  final AadhaarVerificationStatus status;
  final String? transactionId;
  final String? uidToken;
  final String? errorMessage;
  final int resendTimerSeconds;
  final bool canResendOtp;
  final Map<String, dynamic>? verificationResult;

  const AadhaarVerificationState({
    this.status = AadhaarVerificationStatus.initial,
    this.transactionId,
    this.uidToken,
    this.errorMessage,
    this.resendTimerSeconds = 0,
    this.canResendOtp = false,
    this.verificationResult,
  });

  AadhaarVerificationState copyWith({
    AadhaarVerificationStatus? status,
    String? transactionId,
    String? uidToken,
    String? errorMessage,
    int? resendTimerSeconds,
    bool? canResendOtp,
    Map<String, dynamic>? verificationResult,
  }) {
    return AadhaarVerificationState(
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      uidToken: uidToken ?? this.uidToken,
      errorMessage: errorMessage ?? this.errorMessage,
      resendTimerSeconds: resendTimerSeconds ?? this.resendTimerSeconds,
      canResendOtp: canResendOtp ?? this.canResendOtp,
      verificationResult: verificationResult ?? this.verificationResult,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transactionId,
        uidToken,
        errorMessage,
        resendTimerSeconds,
        canResendOtp,
        verificationResult,
      ];
}
