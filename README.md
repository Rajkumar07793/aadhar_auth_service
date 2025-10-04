# Aadhaar Auth Service

A robust and secure **Flutter/Dart** package for integrating **Aadhaar-based Authentication (AUA)** and **e-KYC** services into your application.  
It provides a simple, high-level API to handle the complexity of UIDAI-compliant transactions, including **OTP** and **Biometric authentication**.

---

## 🚀 Features

- **OTP-Based Authentication** → Request and verify Aadhaar-linked OTPs.  
- **Biometric Authentication (RD Service)** → Seamless integration with UIDAI-compliant Registered Devices (fingerprint/iris).  
- **e-KYC Retrieval** → Securely fetch demographic data (Name, Address, DoB, Photo) with user consent.  
- **Secure & Compliant** → Fully adheres to UIDAI guidelines: digital signing, encryption, secure key management.  
- **Aadhaar Masking Utility** → Built-in helper to mask Aadhaar numbers (`XXXX XXXX 1234`).  

---

## 🛠️ Installation

### 1. Add Dependency

In your **pubspec.yaml**:

```yaml
dependencies:
  flutter:
    sdk: flutter
  aadhaar_auth_service: ^0.0.1 # Use the latest version
```

Then run:

```bash
flutter pub get
```

### 2. Platform Setup (Android/iOS)

#### Android
- Ensure `minSdkVersion` in `android/app/build.gradle` is set to **21 or higher**.  
- For Biometric support, declare necessary permissions in `AndroidManifest.xml`.

#### iOS
- Aadhaar ecosystem is primarily Android-focused.  
- For iOS, check **official UIDAI guidelines** for hardware/OS compatibility.

---

## ⚙️ Setup and Initialization

Initialize the service with **AUA/Sub-AUA credentials** before authentication:

```dart
import 'package:aadhaar_auth_service/aadhaar_auth_service.dart';

void main() {
  AadhaarAuthService.initialize(
    auaCode: 'YOUR_AUA_CODE',
    saCode: 'YOUR_SUB_AUA_CODE',
    licenseKey: 'YOUR_LICENSE_KEY',
    environment: Environment.STAGING, // or Environment.PRODUCTION
  );
  runApp(const MyApp());
}
```

---

## 💻 Usage Examples

### 1. OTP-Based Authentication

```dart
final service = AadhaarAuthService.instance;

try {
  // --- Step 1: Request OTP ---
  final otpRequest = await service.requestOtp(aadhaarOrVid: '123456789012');
  
  if (otpRequest.success) {
    print('OTP sent successfully. Transaction ID: ${otpRequest.txnId}');
  } else {
    print('OTP request failed: ${otpRequest.errorCode}');
  }

  // --- Step 2: Verify OTP ---
  final otpVerification = await service.verifyOtp(
    otp: '123456',
    txnId: otpRequest.txnId!,
  );

  if (otpVerification.success) {
    print('Authentication Successful!');
  } else {
    print('OTP Verification failed: ${otpVerification.errorCode}');
  }

} catch (e) {
  print('Unexpected error: $e');
}
```

---

### 2. e-KYC Retrieval (Demographic Data)

```dart
final service = AadhaarAuthService.instance;

try {
  final kycResponse = await service.fetchEkyc(
    txnId: 'TXN:202501010000000',
    consent: true, // User must explicitly consent
  );

  if (kycResponse.success && kycResponse.kycData != null) {
    final data = kycResponse.kycData!;
    print('KYC Successful. User: ${data.name}, Address: ${data.address}');
  } else {
    print('e-KYC failed: ${kycResponse.errorCode}');
  }

} catch (e) {
  print('Unexpected error: $e');
}
```

---

## 🛡️ Security & Compliance

This package is designed to meet **UIDAI standards**:

- **Digital Signatures** → Requests signed with AUA’s private key.  
- **Data Encryption** → Sensitive inputs encrypted with UIDAI’s public key.  
- **No Data Storage** → Aadhaar numbers, OTPs, or biometrics are never cached or stored locally.  

---

## 📄 License

This package is licensed under the **MIT License**.  
See the [LICENSE](./LICENSE) file for details.

---
