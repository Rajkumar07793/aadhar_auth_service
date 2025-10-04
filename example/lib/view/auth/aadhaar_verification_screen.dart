// aadhaar_verification_screen.dart
import 'package:example/bloc/aadhaar_verification_bloc/aadhaar_verification_bloc.dart';
import 'package:example/bloc/aadhaar_verification_bloc/aadhaar_verification_event.dart';
import 'package:example/bloc/aadhaar_verification_bloc/aadhaar_verification_state.dart';
import 'package:example/l10n/generated/app_localizations.dart';
import 'package:example/view/widgets/custom_app_bar.dart' show CustomAppBar;
import 'package:example/view/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AadhaarVerificationScreen extends StatefulWidget {
  final String? phoneNumber;
  final String auaCode;
  final String subAuaCode;
  final String licenseKey;
  final String asaLicenseKey;

  const AadhaarVerificationScreen({
    super.key,
    this.phoneNumber,
    required this.auaCode,
    required this.subAuaCode,
    required this.licenseKey,
    required this.asaLicenseKey,
  });

  @override
  State<AadhaarVerificationScreen> createState() =>
      _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState extends State<AadhaarVerificationScreen> {
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _aadhaarController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _validateAadhaar(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterAadhaarNumber;
    }
    String cleanValue = value.replaceAll(' ', '');
    if (cleanValue.length != 12) {
      return AppLocalizations.of(context)!.aadhaarNumberMustBeDigits;
    }
    if (!RegExp(r'^\d+$').hasMatch(cleanValue)) {
      return AppLocalizations.of(context)!.aadhaarNumberDigits;
    }
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.pleaseEnterOTP;
    }
    if (value.length != 6) {
      return AppLocalizations.of(context)!.oTPMustDigits;
    }
    return null;
  }

  void _sendOtp() {
    if (!_formKey.currentState!.validate()) return;

    String cleanAadhaar = _aadhaarController.text.replaceAll(' ', '');

    context.read<AadhaarVerificationBloc>().add(
      RequestOtpEvent(
        aadhaarNumber: cleanAadhaar,
        auaCode: widget.auaCode,
        subAuaCode: widget.subAuaCode,
        licenseKey: widget.licenseKey,
        asaLicenseKey: widget.asaLicenseKey,
      ),
    );
  }

  void _verifyOtp() {
    if (!_formKey.currentState!.validate()) return;

    final state = context.read<AadhaarVerificationBloc>().state;
    if (state.transactionId == null) {
      _showErrorSnackBar(AppLocalizations.of(context)!.pleaseRequestOTPFirst);
      return;
    }

    String cleanAadhaar = _aadhaarController.text.replaceAll(' ', '');

    context.read<AadhaarVerificationBloc>().add(
      VerifyOtpEvent(
        aadhaarNumber: cleanAadhaar,
        otp: _otpController.text,
        transactionId: state.transactionId!,
        auaCode: widget.auaCode,
        subAuaCode: widget.subAuaCode,
        licenseKey: widget.licenseKey,
        asaLicenseKey: widget.asaLicenseKey,
      ),
    );
  }

  void _resendOtp() {
    String cleanAadhaar = _aadhaarController.text.replaceAll(' ', '');

    context.read<AadhaarVerificationBloc>().add(
      ResendOtpEvent(
        aadhaarNumber: cleanAadhaar,
        auaCode: widget.auaCode,
        subAuaCode: widget.subAuaCode,
        licenseKey: widget.licenseKey,
        asaLicenseKey: widget.asaLicenseKey,
      ),
    );
  }

  void _resetVerification() {
    _otpController.clear();
    context.read<AadhaarVerificationBloc>().add(ResetVerificationEvent());
  }

  void _showSuccessDialog(Map<String, dynamic> result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.verificationSuccessful),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.yourAadhaarHasBeen),
            const SizedBox(height: 12),
            if (result['uidToken'] != null) ...[
              Text(
                'UID Token: ${result['uidToken']}',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              'Transaction ID: ${result['transactionId']}',
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(result);
            },
            child: Text(AppLocalizations.of(context)!.contineTxt),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.aadhaarVerification,
      ),
      body: BlocConsumer<AadhaarVerificationBloc, AadhaarVerificationState>(
        listener: (context, state) {
          switch (state.status) {
            case AadhaarVerificationStatus.otpSent:
              _showSuccessSnackBar(
                AppLocalizations.of(context)!.oTPSentSuccessfullyTo,
              );
              break;
            case AadhaarVerificationStatus.verified:
              if (state.verificationResult != null) {
                _showSuccessDialog(state.verificationResult!);
              }
              break;
            case AadhaarVerificationStatus.error:
              if (state.errorMessage != null) {
                _showErrorSnackBar(state.errorMessage!);
              }
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state.status == AadhaarVerificationStatus.sendingOtp,
            progressIndicator: Loader(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:
                    BlocBuilder<
                      AadhaarVerificationBloc,
                      AadhaarVerificationState
                    >(
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),

                              // Header
                              Text(
                                _isOtpStep(state.status)
                                    ? AppLocalizations.of(context)!.enterOTP
                                    : AppLocalizations.of(
                                        context,
                                      )!.enterAadhaarNumber,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isOtpStep(state.status)
                                    ? AppLocalizations.of(
                                        context,
                                      )!.weHaveSentYourRegistered
                                    : AppLocalizations.of(
                                        context,
                                      )!.pleaseEnterYourAadhaarNumber,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 30),

                              if (!_isOtpStep(state.status)) ...[
                                // Aadhaar Input Field
                                TextFormField(
                                  controller: _aadhaarController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 14,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    _AadhaarNumberFormatter(),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(
                                      context,
                                    )!.aadhaarNumber,
                                    hintText: 'XXXX XXXX XXXX',
                                    prefixIcon: const Icon(Icons.credit_card),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.blue.shade700,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: _validateAadhaar,
                                ),
                                const SizedBox(height: 30),

                                // Send OTP Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading(state.status)
                                        ? null
                                        : _sendOtp,
                                    child: _isLoading(state.status)
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.sendOTP,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ] else ...[
                                // OTP Input Field
                                TextFormField(
                                  controller: _otpController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 8,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(
                                      context,
                                    )!.enterOTP,
                                    hintText: '000000',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.blue.shade700,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: _validateOtp,
                                ),
                                const SizedBox(height: 20),

                                // Resend OTP
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.didReceiveOTP,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    TextButton(
                                      onPressed:
                                          state.canResendOtp &&
                                              !_isLoading(state.status)
                                          ? _resendOtp
                                          : null,
                                      child: Text(
                                        state.canResendOtp
                                            ? AppLocalizations.of(
                                                context,
                                              )!.resendOTP
                                            : 'Resend in ${state.resendTimerSeconds}s',
                                        style: TextStyle(
                                          color: state.canResendOtp
                                              ? Colors.blue.shade700
                                              : Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Verify OTP Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading(state.status)
                                        ? null
                                        : _verifyOtp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade700,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: _isLoading(state.status)
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.verifyOTP,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Edit Aadhaar Number
                                Center(
                                  child: TextButton(
                                    onPressed: _resetVerification,
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.editAadhaarNumber,
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 30),

                              // Security Note
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.blue.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.security,
                                      color: Colors.blue.shade700,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(
                                          context,
                                        )!.yourAadhaarUIDAIGuidelines,
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isOtpStep(AadhaarVerificationStatus status) {
    return status == AadhaarVerificationStatus.otpSent ||
        status == AadhaarVerificationStatus.verifyingOtp;
  }

  bool _isLoading(AadhaarVerificationStatus status) {
    return status == AadhaarVerificationStatus.sendingOtp ||
        status == AadhaarVerificationStatus.verifyingOtp;
  }
}

// Custom formatter for Aadhaar number (XXXX XXXX XXXX format)
class _AadhaarNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
