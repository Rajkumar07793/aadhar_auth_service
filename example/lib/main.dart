import 'package:example/bloc/aadhaar_verification_bloc/aadhaar_verification_bloc.dart';
import 'package:example/l10n/generated/app_localizations.dart';
import 'package:example/view/auth/aadhaar_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AadhaarVerificationBloc(),
      child: MaterialApp(
        title: 'Aadhar Authentication Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('hi'), // Hindi
          // Add other supported locales here
        ],
        home: AadhaarVerificationScreen(
          auaCode: 'public',
          subAuaCode: 'public',
          licenseKey: 'MG_g7jJVYUIW7cLYXY5yaqKD6D1TuhjTJTDPHcb0SudOhVpvpnsEw_A',
          asaLicenseKey:
              'MFoSig475ZNf8Fex6pRZJvFgXoOJhiC67s8cbKCTkkI43QB2a0vKlY8',
        ),
      ),
    );
  }
}
