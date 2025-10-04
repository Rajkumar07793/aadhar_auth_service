// aadhaar_verification_bloc.dart
import 'dart:async';

import 'package:aadhar_auth_service/aadhar_auth_service.dart';
import 'package:example/bloc/aadhaar_verification_bloc/aadhaar_verification_event.dart';
import 'package:example/bloc/aadhaar_verification_bloc/aadhaar_verification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AadhaarVerificationBloc
    extends Bloc<AadhaarVerificationEvent, AadhaarVerificationState> {
  Timer? _resendTimer;

  AadhaarVerificationBloc() : super(const AadhaarVerificationState()) {
    on<RequestOtpEvent>(_onRequestOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<ResetVerificationEvent>(_onResetVerification);
    on<StartResendTimerEvent>(_onStartResendTimer);
    on<UpdateResendTimerEvent>(_onUpdateResendTimer);
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }

  Future<void> _onRequestOtp(
    RequestOtpEvent event,
    Emitter<AadhaarVerificationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AadhaarVerificationStatus.sendingOtp,
        errorMessage: null,
      ),
    );

    try {
      final result = await AadhaarAuthService.requestOtp(
        aadhaarNumber: event.aadhaarNumber,
        auaCode: event.auaCode,
        subAuaCode: event.subAuaCode,
        licenseKey: event.licenseKey,
        asaLicenseKey: event.asaLicenseKey,
      );

      if (result['success']) {
        emit(
          state.copyWith(
            status: AadhaarVerificationStatus.otpSent,
            transactionId: result['transactionId'],
            canResendOtp: false,
            resendTimerSeconds: 30,
          ),
        );
        add(StartResendTimerEvent());
      } else {
        emit(
          state.copyWith(
            status: AadhaarVerificationStatus.error,
            errorMessage: result['message'],
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AadhaarVerificationStatus.error,
          errorMessage: 'Failed to send OTP: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AadhaarVerificationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AadhaarVerificationStatus.verifyingOtp,
        errorMessage: null,
      ),
    );

    try {
      final result = await AadhaarAuthService.verifyOtp(
        aadhaarNumber: event.aadhaarNumber,
        otp: event.otp,
        transactionId: event.transactionId,
        auaCode: event.auaCode,
        subAuaCode: event.subAuaCode,
        licenseKey: event.licenseKey,
        asaLicenseKey: event.asaLicenseKey,
      );

      if (result['success']) {
        emit(
          state.copyWith(
            status: AadhaarVerificationStatus.verified,
            uidToken: result['uidToken'],
            verificationResult: result,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AadhaarVerificationStatus.error,
            errorMessage: result['message'],
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AadhaarVerificationStatus.error,
          errorMessage: 'OTP verification failed: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AadhaarVerificationState> emit,
  ) async {
    add(
      RequestOtpEvent(
        aadhaarNumber: event.aadhaarNumber,
        auaCode: event.auaCode,
        subAuaCode: event.subAuaCode,
        licenseKey: event.licenseKey,
        asaLicenseKey: event.asaLicenseKey,
      ),
    );
  }

  void _onResetVerification(
    ResetVerificationEvent event,
    Emitter<AadhaarVerificationState> emit,
  ) {
    _resendTimer?.cancel();
    emit(const AadhaarVerificationState());
  }

  void _onStartResendTimer(
    StartResendTimerEvent event,
    Emitter<AadhaarVerificationState> emit,
  ) {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingTime = 30 - timer.tick;
      if (remainingTime <= 0) {
        timer.cancel();
        add(const UpdateResendTimerEvent(0));
      } else {
        add(UpdateResendTimerEvent(remainingTime));
      }
    });
  }

  void _onUpdateResendTimer(
    UpdateResendTimerEvent event,
    Emitter<AadhaarVerificationState> emit,
  ) {
    emit(
      state.copyWith(
        resendTimerSeconds: event.remainingTime,
        canResendOtp: event.remainingTime <= 0,
      ),
    );
  }
}
