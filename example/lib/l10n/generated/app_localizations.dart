import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @chooseAnOption.
  ///
  /// In en, this message translates to:
  /// **'Choose an option'**
  String get chooseAnOption;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @contineTxt.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get contineTxt;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6 digit code sent to at 2225656333'**
  String get enterCode;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter First Name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter Last Name'**
  String get enterLastName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhoneNumber;

  /// No description provided for @enterYouMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterYouMobileNumber;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enterYourEmail;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address for the verification process. We will send 6 digit code to your email or sms.'**
  String get forgotPasswordDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @getOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOtp;

  /// No description provided for @joinedUsBefore.
  ///
  /// In en, this message translates to:
  /// **'Joined us before?'**
  String get joinedUsBefore;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to logout?'**
  String get logoutDesc;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @myRides.
  ///
  /// In en, this message translates to:
  /// **'My Rides'**
  String get myRides;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @enterYourAadhaarLinkedMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your Aadhaar-linked mobile number.'**
  String get enterYourAadhaarLinkedMobileNumber;

  /// No description provided for @phoneAutomaticallySigned.
  ///
  /// In en, this message translates to:
  /// **'Phone number automatically verified and signed in!'**
  String get phoneAutomaticallySigned;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @pleasVerifyText.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get pleasVerifyText;

  /// No description provided for @pleaseCheckYourMail.
  ///
  /// In en, this message translates to:
  /// **'Please check your mail'**
  String get pleaseCheckYourMail;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email '**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmailAddress;

  /// No description provided for @pleaseEnterYourFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get pleaseEnterYourFirstName;

  /// No description provided for @pleaseEnterYourLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get pleaseEnterYourLastName;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @pleaseEnterYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone'**
  String get pleaseEnterYourPhone;

  /// No description provided for @pleaseEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// No description provided for @pleaseSelectYourDOB.
  ///
  /// In en, this message translates to:
  /// **'Please select age'**
  String get pleaseSelectYourDOB;

  /// No description provided for @pleaseSelectYourGender.
  ///
  /// In en, this message translates to:
  /// **'Please enter your gender'**
  String get pleaseSelectYourGender;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @receiveCode.
  ///
  /// In en, this message translates to:
  /// **'Receive Code'**
  String get receiveCode;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get request;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendOTP.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOTP;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get updateProfile;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code '**
  String get verificationCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @loginWithAadhaar.
  ///
  /// In en, this message translates to:
  /// **'Login with Aadhaar'**
  String get loginWithAadhaar;

  /// No description provided for @accountNotExist.
  ///
  /// In en, this message translates to:
  /// **'Account doesn\'t exist with this phone number'**
  String get accountNotExist;

  /// No description provided for @availableRides.
  ///
  /// In en, this message translates to:
  /// **'Available Rides'**
  String get availableRides;

  /// No description provided for @enterTheCodeWeSent.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent to your mobile. This will verify your number securely'**
  String get enterTheCodeWeSent;

  /// No description provided for @co.
  ///
  /// In en, this message translates to:
  /// **'Co-'**
  String get co;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @nextText.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextText;

  /// No description provided for @upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNow;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @enterAValidOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 6-digit OTP'**
  String get enterAValidOTP;

  /// No description provided for @enterPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter pickup location'**
  String get enterPickupLocation;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @pickupPoint.
  ///
  /// In en, this message translates to:
  /// **'Pickup point'**
  String get pickupPoint;

  /// No description provided for @whereTOGO.
  ///
  /// In en, this message translates to:
  /// **'Where to go?'**
  String get whereTOGO;

  /// No description provided for @availableSeats.
  ///
  /// In en, this message translates to:
  /// **'Available Seats'**
  String get availableSeats;

  /// No description provided for @selectDestination.
  ///
  /// In en, this message translates to:
  /// **'Select Destination'**
  String get selectDestination;

  /// No description provided for @pleaseEnterAadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter Aadhaar number'**
  String get pleaseEnterAadhaarNumber;

  /// No description provided for @aadhaarNumberMustBeDigits.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number must be 12 digits'**
  String get aadhaarNumberMustBeDigits;

  /// No description provided for @aadhaarNumberDigits.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar number must contain only digits'**
  String get aadhaarNumberDigits;

  /// No description provided for @pleaseEnterOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter OTP'**
  String get pleaseEnterOTP;

  /// No description provided for @awaitingPersonResponse.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Person’s Response'**
  String get awaitingPersonResponse;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time Left'**
  String get timeLeft;

  /// No description provided for @findOtherPassenger.
  ///
  /// In en, this message translates to:
  /// **'Find Other Co-Passenger'**
  String get findOtherPassenger;

  /// No description provided for @yourRequestIsPending.
  ///
  /// In en, this message translates to:
  /// **'Your request is pending. Please wait while the person reviews it.'**
  String get yourRequestIsPending;

  /// No description provided for @thereIsNoNearbyAirport.
  ///
  /// In en, this message translates to:
  /// **'There is no nearby airport you can search manually'**
  String get thereIsNoNearbyAirport;

  /// No description provided for @enterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter valid 10 digits phone number'**
  String get enterValidPhoneNumber;

  /// No description provided for @aDigitEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code we sent to your mobile. This will verify your number securely '**
  String get aDigitEmailSent;

  /// No description provided for @bySigningUp.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you’ve agree to our '**
  String get bySigningUp;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy.'**
  String get privacyPolicy;

  /// No description provided for @noRides.
  ///
  /// In en, this message translates to:
  /// **'No rides found'**
  String get noRides;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @verificationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Verification Successful'**
  String get verificationSuccessful;

  /// No description provided for @yourAadhaarHasBeen.
  ///
  /// In en, this message translates to:
  /// **'Your Aadhaar has been verified successfully!'**
  String get yourAadhaarHasBeen;

  /// No description provided for @aadhaarVerification.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Verification'**
  String get aadhaarVerification;

  /// No description provided for @oTPMustDigits.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 6 digits'**
  String get oTPMustDigits;

  /// No description provided for @oTPSentSuccessfullyTo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully to your registered mobile number'**
  String get oTPSentSuccessfullyTo;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOTP;

  /// No description provided for @enterAadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Aadhaar Number'**
  String get enterAadhaarNumber;

  /// No description provided for @didReceiveOTP.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive OTP?'**
  String get didReceiveOTP;

  /// No description provided for @resendTextOTP.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendTextOTP;

  /// No description provided for @verifyOTP.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOTP;

  /// No description provided for @editAadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Edit Aadhaar Number'**
  String get editAadhaarNumber;

  /// No description provided for @weHaveSentYourRegistered.
  ///
  /// In en, this message translates to:
  /// **'We have sent a 6-digit OTP to your registered mobile number'**
  String get weHaveSentYourRegistered;

  /// No description provided for @pleaseEnterYourAadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your 12-digit Aadhaar number'**
  String get pleaseEnterYourAadhaarNumber;

  /// No description provided for @pleaseRequestOTPFirst.
  ///
  /// In en, this message translates to:
  /// **'Please request OTP first'**
  String get pleaseRequestOTPFirst;

  /// No description provided for @noRequest.
  ///
  /// In en, this message translates to:
  /// **'no requests'**
  String get noRequest;

  /// No description provided for @aadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number'**
  String get aadhaarNumber;

  /// No description provided for @sendOTP.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOTP;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengers;

  /// No description provided for @enterDestination.
  ///
  /// In en, this message translates to:
  /// **'Enter Destination'**
  String get enterDestination;

  /// No description provided for @selectPickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Select pickup location'**
  String get selectPickupLocation;

  /// No description provided for @createRide.
  ///
  /// In en, this message translates to:
  /// **'Create Ride'**
  String get createRide;

  /// No description provided for @chooseTheBestRoute.
  ///
  /// In en, this message translates to:
  /// **'Choose the best Route'**
  String get chooseTheBestRoute;

  /// No description provided for @affordableRidesEverywhere.
  ///
  /// In en, this message translates to:
  /// **'Affordable Rides, Everywhere'**
  String get affordableRidesEverywhere;

  /// No description provided for @effortlessRidesAnytime.
  ///
  /// In en, this message translates to:
  /// **'Effortless Rides,Anytime'**
  String get effortlessRidesAnytime;

  /// No description provided for @shareRideCost.
  ///
  /// In en, this message translates to:
  /// **'Share ride & Cost'**
  String get shareRideCost;

  /// No description provided for @setYourDestination.
  ///
  /// In en, this message translates to:
  /// **'Set Your Destination'**
  String get setYourDestination;

  /// No description provided for @findC0Passenger.
  ///
  /// In en, this message translates to:
  /// **'Find Your CO-Passenger'**
  String get findC0Passenger;

  /// No description provided for @saveMoney.
  ///
  /// In en, this message translates to:
  /// **'Save money, reduce traffic, and enjoy the journey together'**
  String get saveMoney;

  /// No description provided for @allTraveller.
  ///
  /// In en, this message translates to:
  /// **'All Co-Travellers are headed to the same place'**
  String get allTraveller;

  /// No description provided for @matchWithPeople.
  ///
  /// In en, this message translates to:
  /// **'Match with people going to the same destination'**
  String get matchWithPeople;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start'**
  String get letsStart;

  /// No description provided for @helloLet.
  ///
  /// In en, this message translates to:
  /// **'Hello! Let’s Get to'**
  String get helloLet;

  /// No description provided for @knowYou.
  ///
  /// In en, this message translates to:
  /// **'Know You'**
  String get knowYou;

  /// No description provided for @confirmWithOTP.
  ///
  /// In en, this message translates to:
  /// **'Confirm with'**
  String get confirmWithOTP;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @oTP.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get oTP;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Subscription plans'**
  String get plans;

  /// No description provided for @noPlans.
  ///
  /// In en, this message translates to:
  /// **'No plans found'**
  String get noPlans;

  /// No description provided for @yourAadhaarUIDAIGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Your Aadhaar information is secure and encrypted as per UIDAI guidelines. All data is transmitted using end-to-end encryption.'**
  String get yourAadhaarUIDAIGuidelines;

  /// No description provided for @enjoyCompetitivePricing.
  ///
  /// In en, this message translates to:
  /// **'Enjoy competitive pricing on all rides, with transparent fare estimates and multiple payment options.'**
  String get enjoyCompetitivePricing;

  /// No description provided for @travelWithPeace.
  ///
  /// In en, this message translates to:
  /// **'Travel with peace of mind. Our trusted drivers and advanced safety features ensure your safety throughout the job.'**
  String get travelWithPeace;

  /// No description provided for @getARide.
  ///
  /// In en, this message translates to:
  /// **'Get a ride within minutes with just a tap. Your reliable transport solution is always at your fingertips.'**
  String get getARide;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
