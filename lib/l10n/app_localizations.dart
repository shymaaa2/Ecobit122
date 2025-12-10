import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
/// import 'l10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Selected Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @welcomeQ.
  ///
  /// In en, this message translates to:
  /// **'Do you want to check\nif the fruit is edible?'**
  String get welcomeQ;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account!'**
  String get newAccount;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get username;

  /// No description provided for @userErr.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get userErr;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailErr.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get emailErr;

  /// No description provided for @pass.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get pass;

  /// No description provided for @passErr.
  ///
  /// In en, this message translates to:
  /// **'Password too short'**
  String get passErr;

  /// No description provided for @confPass.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confPass;

  /// No description provided for @matchPass.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get matchPass;

  /// No description provided for @birth.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birth;

  /// No description provided for @birthField.
  ///
  /// In en, this message translates to:
  /// **'Select birthday'**
  String get birthField;

  /// No description provided for @conditions.
  ///
  /// In en, this message translates to:
  /// **'I accept terms and conditions'**
  String get conditions;

  /// No description provided for @pleaseLogine.
  ///
  /// In en, this message translates to:
  /// **'Please log in to your account'**
  String get pleaseLogine;

  /// No description provided for @frgtPass.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get frgtPass;

  /// No description provided for @noAcc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAcc;

  /// No description provided for @mngList.
  ///
  /// In en, this message translates to:
  /// **'Manage List'**
  String get mngList;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @fav.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get fav;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @notifType.
  ///
  /// In en, this message translates to:
  /// **'Notification Type'**
  String get notifType;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @headsUp.
  ///
  /// In en, this message translates to:
  /// **'Heads up notification'**
  String get headsUp;

  /// No description provided for @popUp.
  ///
  /// In en, this message translates to:
  /// **'Pop up notification'**
  String get popUp;

  /// No description provided for @notifChoice.
  ///
  /// In en, this message translates to:
  /// **'Choose Notification Type'**
  String get notifChoice;

  /// No description provided for @themeChoice.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get themeChoice;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @galleryMsg.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or choose one from the gallery to inference.'**
  String get galleryMsg;

  /// No description provided for @detected.
  ///
  /// In en, this message translates to:
  /// **'Detected'**
  String get detected;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Your voice matters! '**
  String get voice;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'help us by filling a quick survey'**
  String get help;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Maybe, later'**
  String get later;

  /// No description provided for @fb.
  ///
  /// In en, this message translates to:
  /// **'Tell Us What You Think!'**
  String get fb;

  /// No description provided for @qOne.
  ///
  /// In en, this message translates to:
  /// **'Was the edibility result accurate?'**
  String get qOne;

  /// No description provided for @qTwo.
  ///
  /// In en, this message translates to:
  /// **'How easy was it to use the app to check a fruit\'s edibility?'**
  String get qTwo;

  /// No description provided for @qThree.
  ///
  /// In en, this message translates to:
  /// **'How likely are you to recommend this app to a friend?'**
  String get qThree;

  /// No description provided for @qFour.
  ///
  /// In en, this message translates to:
  /// **'How clear was the information provided about the fruit?'**
  String get qFour;

  /// No description provided for @fbErr.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all the fields '**
  String get fbErr;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
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
