/// UIDAI Aadhaar OTP Service Implementation
///
/// This class provides methods to request OTP and verify OTP for Aadhaar authentication
/// using UIDAI's authentication API. It includes simplified XML builders, response parsers,
/// and placeholders for cryptographic operations.
library;
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// A service class for handling Aadhaar OTP request and verification.
class AadhaarAuthService {
  /// Base URL of UIDAI authentication server.
  /// Production requires private network access, while developer endpoints can be used for testing.
  static const String baseUrl = 'https://developer.uidai.gov.in/uidotp';

  /// API version as per UIDAI specification.
  static const String version = '2.5';

  /// Requests an OTP from UIDAI servers.
  ///
  /// [aadhaarNumber] Aadhaar number of the user.
  /// [auaCode] Authentication User Agency code.
  /// [subAuaCode] Sub-AUA code.
  /// [licenseKey] License key issued by UIDAI.
  /// [asaLicenseKey] ASA license key.
  ///
  /// Returns a [Map] with success status, message, and transactionId.
  static Future<Map<String, dynamic>> requestOtp({
    required String aadhaarNumber,
    required String auaCode,
    required String subAuaCode,
    required String licenseKey,
    required String asaLicenseKey,
  }) async {
    try {
      String transactionId = _generateTransactionId();
      String timestamp = _getCurrentTimestamp();

      // Build OTP request XML according to UIDAI specification
      String otpRequestXml = _buildOtpRequestXml(
        aadhaarNumber: aadhaarNumber,
        transactionId: transactionId,
        timestamp: timestamp,
        auaCode: auaCode,
        subAuaCode: subAuaCode,
        licenseKey: licenseKey,
      );

      // Calculate URL for OTP API call
      String uid0 = aadhaarNumber.substring(0, 1);
      String uid1 = aadhaarNumber.substring(1, 2);
      String url = '$baseUrl/$version/$auaCode/$uid0/$uid1/$asaLicenseKey';

      // Make HTTP request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/xml',
          'User-Agent': 'Aadhaar-OTP-Client/1.0',
        },
        body: otpRequestXml,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = _parseOtpResponse(response.body);
        result['transactionId'] = transactionId;
        return result;
      } else {
        return {
          'success': false,
          'message': 'HTTP Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  /// Verifies the OTP using UIDAI authentication API.
  ///
  /// [aadhaarNumber] Aadhaar number of the user.
  /// [otp] One-time password received on Aadhaar-linked mobile.
  /// [transactionId] Transaction ID generated during OTP request.
  /// [auaCode], [subAuaCode], [licenseKey], [asaLicenseKey] are UIDAI credentials.
  ///
  /// Returns a [Map] containing success status, message, and optional uidToken.
  static Future<Map<String, dynamic>> verifyOtp({
    required String aadhaarNumber,
    required String otp,
    required String transactionId,
    required String auaCode,
    required String subAuaCode,
    required String licenseKey,
    required String asaLicenseKey,
  }) async {
    try {
      String timestamp = _getCurrentTimestamp();

      // Generate session key and encrypt PID block
      List<int> sessionKey = _generateSessionKey();
      String encryptedPidBlock = await _encryptPidBlock(
        otp,
        timestamp,
        sessionKey,
      );
      String encryptedSessionKey = await _encryptSessionKey(sessionKey);
      String hmacValue = _calculateHmac(otp, timestamp, sessionKey);

      // Build authentication XML according to UIDAI specification
      String authXml = _buildAuthXml(
        aadhaarNumber: aadhaarNumber,
        transactionId: transactionId,
        auaCode: auaCode,
        subAuaCode: subAuaCode,
        licenseKey: licenseKey,
        encryptedPidBlock: encryptedPidBlock,
        encryptedSessionKey: encryptedSessionKey,
        hmacValue: hmacValue,
      );

      // Calculate URL for Auth API call
      String uid0 = aadhaarNumber.substring(0, 1);
      String uid1 = aadhaarNumber.substring(1, 2);
      String url = '$baseUrl/$version/$auaCode/$uid0/$uid1/$asaLicenseKey';

      // Make HTTP request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/xml',
          'User-Agent': 'Aadhaar-Auth-Client/1.0',
        },
        body: authXml,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = _parseAuthResponse(response.body);
        result['transactionId'] = transactionId;
        return result;
      } else {
        return {
          'success': false,
          'message': 'HTTP Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Authentication error: ${e.toString()}',
      };
    }
  }

  /// Builds OTP Request XML as per UIDAI spec.
  static String _buildOtpRequestXml({
    required String aadhaarNumber,
    required String transactionId,
    required String timestamp,
    required String auaCode,
    required String subAuaCode,
    required String licenseKey,
  }) {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<Otp uid="$aadhaarNumber" tid="" ac="$auaCode" sa="$subAuaCode" ver="2.5" txn="$transactionId" lk="$licenseKey" ts="$timestamp">
  <Opts ch="01"/>
  <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
    <!-- Digital signature would go here in production -->
  </Signature>
</Otp>''';
  }

  /// Builds Authentication XML as per UIDAI spec.
  static String _buildAuthXml({
    required String aadhaarNumber,
    required String transactionId,
    required String auaCode,
    required String subAuaCode,
    required String licenseKey,
    required String encryptedPidBlock,
    required String encryptedSessionKey,
    required String hmacValue,
  }) {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<Auth uid="$aadhaarNumber" rc="Y" tid="" ac="$auaCode" sa="$subAuaCode" ver="2.5" txn="$transactionId" lk="$licenseKey">
  <Uses pi="n" pa="n" pfa="n" bio="n" pin="n" otp="y"/>
  <Device dpId="" rdsId="" rdsVer="" dc="" mi="" mc=""/>
  <Skey ci="20250101">$encryptedSessionKey</Skey>
  <Hmac>$hmacValue</Hmac>
  <Data type="X">$encryptedPidBlock</Data>
  <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
    <!-- Digital signature would go here in production -->
  </Signature>
</Auth>''';
  }

  /// Parses the OTP response from UIDAI server.
  static Map<String, dynamic> _parseOtpResponse(String xmlResponse) {
    if (xmlResponse.contains('ret="y"') || xmlResponse.contains("ret='y'")) {
      return {'success': true, 'message': 'OTP sent successfully'};
    } else if (xmlResponse.contains('err=')) {
      String errorCode = _extractAttribute(xmlResponse, 'err');
      String errorMessage = _getErrorMessage(errorCode);
      return {'success': false, 'message': errorMessage};
    } else {
      return {'success': false, 'message': 'Unknown response format'};
    }
  }

  /// Parses the Auth response from UIDAI server.
  static Map<String, dynamic> _parseAuthResponse(String xmlResponse) {
    if (xmlResponse.contains('ret="y"') || xmlResponse.contains("ret='y'")) {
      String? uidToken = _extractFromInfo(xmlResponse, 0);
      return {
        'success': true,
        'message': 'Authentication successful',
        'uidToken': uidToken,
      };
    } else if (xmlResponse.contains('err=')) {
      String errorCode = _extractAttribute(xmlResponse, 'err');
      String errorMessage = _getErrorMessage(errorCode);
      return {'success': false, 'message': errorMessage};
    } else {
      return {'success': false, 'message': 'Authentication failed'};
    }
  }

  /// Extracts an attribute value from XML string.
  static String _extractAttribute(String xml, String attribute) {
    RegExp regex = RegExp('$attribute="([^"]*)"');
    Match? match = regex.firstMatch(xml);
    return match?.group(1) ?? '';
  }

  /// Extracts a value from comma-separated `info` attribute.
  static String? _extractFromInfo(String xml, int index) {
    String? info = _extractAttribute(xml, 'info');
    if (info.isNotEmpty) {
      List<String> parts = info.split(',');
      if (parts.length > index) {
        return parts[index].trim();
      }
    }
    return null;
  }

  /// Maps UIDAI error codes to human-readable error messages.
  static String _getErrorMessage(String errorCode) {
    Map<String, String> errorMessages = {
      // Demographic / biometric mismatch
      '100': 'Personal identity data did not match (Pi)',
      '200': 'Address data did not match (Pa)',
      '300': 'Biometric data did not match',
      '310': 'Duplicate fingers used',
      '311': 'Duplicate Irises used',
      '312': 'FMR and FIR cannot be used in same transaction',
      '313': 'Single FIR record contains more than one finger',
      '314': 'Number of FMR/FIR should not exceed 10',
      '315': 'Number of IIR should not exceed 2',
      '316': 'Number of FID should not exceed 1',
      '317': 'Number of biometric modalities exceeded',
      '318': 'BFD transaction should not contain other modalities',
      '330': 'Biometrics locked by Aadhaar holder',
      '331': 'Aadhaar locked by Aadhaar holder',
      '332': 'Aadhaar number usage blocked by Aadhaar holder',

      // OTP errors
      '400': 'Invalid OTP value',
      '402': 'Transaction ID mismatch with OTP request',
      '403': 'OTP attempts exceeded or OTP expired',

      // Encryption / crypto
      '500': 'Invalid encryption of session key',
      '501': 'Invalid certificate identifier in Skey',
      '502': 'Invalid encryption of PID',
      '503': 'Invalid encryption of HMAC',
      '504': 'Session key expired or out of sync',
      '505': 'Synchronized key usage not allowed for AUA',

      // XML / format issues
      '510': 'Invalid Auth XML format',
      '511': 'Invalid PID XML format',
      '512': 'Invalid consent value in Auth',
      '513': 'Invalid Protobuf format',
      '514': 'Invalid UID token in input',
      '515': 'Invalid VID number in input',
      '516': 'Invalid/Non-decryptable ANCS token in input',
      '517': 'Expired VID used',
      '518': 'ANCS token already used or expired',
      '519': 'Inappropriate ANCS token used',
      '520': 'Invalid TID value',
      '521': 'Invalid DC code in Device tag',
      '524': 'Invalid MI code in Device tag',
      '527': 'Invalid MC code in Device tag',
      '528': 'Device key rotation related issue',

      // Auth / AUA errors
      '530': 'Invalid authenticator code',
      '531': 'Invalid Sub-AUA',
      '532': 'VID not yet generated',
      '540': 'Invalid Auth XML version',
      '541': 'Invalid PID XML version',
      '542': 'AUA not authorized for ASA',
      '543': 'Sub-AUA not associated with AUA',

      // Uses / WADH errors
      '550': 'Invalid Uses element attributes',
      '552': 'Invalid WADH element',
      '553': 'RD service not allowed for AUA',
      '554': 'Public devices not allowed',
      '555': 'Invalid rdsId',
      '556': 'Invalid rdsVer',
      '557': 'Invalid dpId',
      '558': 'Invalid dih',
      '559': 'Device certificate expired',
      '560': 'DP master certificate expired',

      // Timestamp / session errors
      '561': 'Request expired',
      '562': 'Timestamp is ahead of server time',
      '563': 'Duplicate request',
      '564': 'HMAC validation failed',
      '565': 'AUA license expired',
      '566': 'Invalid/Non-decryptable license key',
      '567': 'Invalid input (unsupported characters)',
      '568': 'Unsupported language',
      '569': 'Digital signature verification failed',
      '570': 'Invalid key info in digital signature',
      '571': 'PIN requires reset',

      // Biometric / PID issues
      '572': 'Invalid biometric position',
      '573': 'Pi usage not allowed as per license',
      '574': 'Pa usage not allowed as per license',
      '575': 'Pfa usage not allowed as per license',
      '576': 'FMR usage not allowed as per license',
      '577': 'FIR usage not allowed as per license',
      '578': 'IIR usage not allowed as per license',
      '579': 'OTP usage not allowed as per license',
      '580': 'PIN usage not allowed as per license',
      '581': 'Fuzzy matching not allowed as per license',
      '582': 'Local language not allowed as per license',
      '586': 'FID usage not allowed as per license',
      '587': 'Namespace not allowed',
      '588': 'Registered device not allowed as per license',
      '590': 'Public device not allowed as per license',
      '591': 'BFD usage not allowed as per license',
      '592': 'Device blocked (error percentage exceeded)',
      '593': 'Device blocked (velocity exceeded)',

      // Missing elements
      '710': 'Missing Pi data as per Uses',
      '720': 'Missing Pa data as per Uses',
      '721': 'Missing Pfa data as per Uses',
      '730': 'Missing PIN data as per Uses',
      '740': 'Missing OTP data as per Uses',

      // Biometric data errors
      '800': 'Invalid biometric data',
      '810': 'Missing biometric data as per Uses',
      '811': 'Missing biometric data in CIDR for Aadhaar',
      '812': 'Best Finger Detection not done',
      '820': 'Missing or empty bt attribute in Uses',
      '821': 'Invalid bt attribute in Uses',
      '822': 'Invalid bs attribute in Bio element',

      // Generic / technical
      '901': 'No authentication data found in request',
      '902': 'Invalid DOB format in Pi element',
      '910': 'Invalid mv value in Pi element',
      '911': 'Invalid mv value in Pfa element',
      '912': 'Invalid ms value',
      '913': 'Both Pa and Pfa present (mutually exclusive)',
      '914': 'Face must be combined with Finger/Iris/OTP',
      '915': 'Face auth not allowed for this age',
      '916': 'Invalid face image format',
      '917': 'Invalid face capture type',

      // Technical / server
      '930': 'Technical error (server)',
      '940': 'Unauthorized ASA channel',
      '941': 'Unspecified ASA channel',
      '950': 'OTP store related technical error',
      '951': 'Biometric lock related technical error',

      // Suspended Aadhaar
      '980': 'Unsupported option',
      '995': 'Aadhaar suspended by authority',
      '996': 'Aadhaar cancelled',
      '997': 'Aadhaar suspended',
      '998': 'Invalid Aadhaar number',
      '999': 'Unknown error',
      // (Truncated for brevity: include all error codes in full production code)
    };

    return errorMessages[errorCode] ?? 'Unknown error occurred';
  }

  /// Generates a unique transaction ID using timestamp and random number.
  static String _generateTransactionId() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String random = Random().nextInt(999999).toString().padLeft(6, '0');
    return 'TXN$timestamp$random';
  }

  /// Returns the current timestamp in ISO8601 format required by UIDAI.
  static String _getCurrentTimestamp() {
    DateTime now = DateTime.now();
    return "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  /// Generates a 256-bit session key for encryption.
  static List<int> _generateSessionKey() {
    Random random = Random.secure();
    return List<int>.generate(32, (i) => random.nextInt(256));
  }

  /// Encrypts the PID block (placeholder implementation).
  static Future<String> _encryptPidBlock(
    String otp,
    String timestamp,
    List<int> sessionKey,
  ) async {
    String pidXml =
        '''<Pid ts="$timestamp" ver="2.0">
  <Pv otp="$otp"/>
</Pid>''';
    return base64Encode(utf8.encode(pidXml)); // Placeholder
  }

  /// Encrypts the session key with UIDAI public key (placeholder).
  static Future<String> _encryptSessionKey(List<int> sessionKey) async {
    return base64Encode(sessionKey); // Placeholder
  }

  /// Calculates HMAC of PID block (placeholder implementation).
  static String _calculateHmac(
    String otp,
    String timestamp,
    List<int> sessionKey,
  ) {
    String pidXml =
        '''<Pid ts="$timestamp" ver="2.0">
  <Pv otp="$otp"/>
</Pid>''';

    var bytes = utf8.encode(pidXml);
    var digest = sha256.convert(bytes);
    return base64Encode(digest.bytes); // Placeholder
  }
}
