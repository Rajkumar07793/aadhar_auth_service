import 'package:example/view/auth/aadhaar_verification_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aadhar Authentication Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AadhaarVerificationScreen(
        auaCode: 'public',
        subAuaCode: 'public',
        licenseKey: 'public',
        asaLicenseKey: 'public',
      ),
    );
  }
}
