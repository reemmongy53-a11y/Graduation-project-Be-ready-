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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started now'**
  String get get_started;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create an account or log in to explore about our app'**
  String get create_account;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get log_in;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// No description provided for @name_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get name_required;

  /// No description provided for @invalid_name.
  ///
  /// In en, this message translates to:
  /// **'Invalid Name'**
  String get invalid_name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_required;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email'**
  String get invalid_email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get password_required;

  /// No description provided for @invalid_password.
  ///
  /// In en, this message translates to:
  /// **'Invalid Password'**
  String get invalid_password;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @gate_open.
  ///
  /// In en, this message translates to:
  /// **'The gate has opened'**
  String get gate_open;

  /// No description provided for @gate_close.
  ///
  /// In en, this message translates to:
  /// **'The gate is closed.'**
  String get gate_close;

  /// No description provided for @camera_open.
  ///
  /// In en, this message translates to:
  /// **'The camera turned on'**
  String get camera_open;

  /// No description provided for @camera_close.
  ///
  /// In en, this message translates to:
  /// **'The camera turned off'**
  String get camera_close;

  /// No description provided for @control_of_gate.
  ///
  /// In en, this message translates to:
  /// **'Control of Gate'**
  String get control_of_gate;

  /// No description provided for @gate.
  ///
  /// In en, this message translates to:
  /// **'Gate'**
  String get gate;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @connection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @control_of_camera.
  ///
  /// In en, this message translates to:
  /// **'Control of Camera'**
  String get control_of_camera;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @face_id.
  ///
  /// In en, this message translates to:
  /// **'FaceID'**
  String get face_id;

  /// No description provided for @open_gate.
  ///
  /// In en, this message translates to:
  /// **'Open Gate'**
  String get open_gate;

  /// No description provided for @close_gate.
  ///
  /// In en, this message translates to:
  /// **'Close Gate'**
  String get close_gate;

  /// No description provided for @open_camera.
  ///
  /// In en, this message translates to:
  /// **'Open Camera'**
  String get open_camera;

  /// No description provided for @close_camera.
  ///
  /// In en, this message translates to:
  /// **'Close Camera'**
  String get close_camera;

  /// No description provided for @failed_to_send_camera_command.
  ///
  /// In en, this message translates to:
  /// **'Failed to send camera command'**
  String get failed_to_send_camera_command;

  /// No description provided for @failed_to_check_camera_command_status.
  ///
  /// In en, this message translates to:
  /// **'Failed to check camera command status'**
  String get failed_to_check_camera_command_status;

  /// No description provided for @submit_formal_complaint.
  ///
  /// In en, this message translates to:
  /// **'Submit a formal complaint'**
  String get submit_formal_complaint;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @job_or_department.
  ///
  /// In en, this message translates to:
  /// **'Job or department'**
  String get job_or_department;

  /// No description provided for @report_title.
  ///
  /// In en, this message translates to:
  /// **'Report title'**
  String get report_title;

  /// No description provided for @report_details.
  ///
  /// In en, this message translates to:
  /// **'Report details'**
  String get report_details;

  /// No description provided for @date_of_complaint.
  ///
  /// In en, this message translates to:
  /// **'Date of complaint'**
  String get date_of_complaint;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'You can register your attendance by entering your ID or name.'**
  String get message;

  /// No description provided for @enter_id_or_name.
  ///
  /// In en, this message translates to:
  /// **'Enter ID or name'**
  String get enter_id_or_name;

  /// No description provided for @attend.
  ///
  /// In en, this message translates to:
  /// **'Attend'**
  String get attend;

  /// No description provided for @gate_control.
  ///
  /// In en, this message translates to:
  /// **'GATE CONTROL'**
  String get gate_control;

  /// No description provided for @on_site.
  ///
  /// In en, this message translates to:
  /// **'ON-SITE'**
  String get on_site;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'VEHICLES'**
  String get vehicles;

  /// No description provided for @external_gate.
  ///
  /// In en, this message translates to:
  /// **'External Gate'**
  String get external_gate;

  /// No description provided for @gate_camera.
  ///
  /// In en, this message translates to:
  /// **'GATE Camera'**
  String get gate_camera;

  /// No description provided for @quick_actions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions;

  /// No description provided for @qr.
  ///
  /// In en, this message translates to:
  /// **'QR Check-in'**
  String get qr;

  /// No description provided for @attendance_report.
  ///
  /// In en, this message translates to:
  /// **'Attendance Report'**
  String get attendance_report;

  /// No description provided for @vehicle_entry.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Entry'**
  String get vehicle_entry;

  /// No description provided for @site_status.
  ///
  /// In en, this message translates to:
  /// **'Site Status'**
  String get site_status;

  /// No description provided for @monthly_activity.
  ///
  /// In en, this message translates to:
  /// **'Monthly activity'**
  String get monthly_activity;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @absence.
  ///
  /// In en, this message translates to:
  /// **'Absence'**
  String get absence;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Your activity'**
  String get activity;

  /// No description provided for @submit_complaint.
  ///
  /// In en, this message translates to:
  /// **'Submit a Complaint'**
  String get submit_complaint;

  /// No description provided for @report_incident.
  ///
  /// In en, this message translates to:
  /// **'Report an incident or issue'**
  String get report_incident;

  /// No description provided for @check_email.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get check_email;

  /// No description provided for @send_code.
  ///
  /// In en, this message translates to:
  /// **'We sent a reset code to your email, enter the 5 digit code'**
  String get send_code;

  /// No description provided for @enter_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 5 digit code'**
  String get enter_code;

  /// No description provided for @verify_code.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verify_code;

  /// No description provided for @havent_got_email.
  ///
  /// In en, this message translates to:
  /// **'Haven\'t got the email yet?'**
  String get havent_got_email;

  /// No description provided for @resend_email.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resend_email;

  /// No description provided for @please_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to reset the password'**
  String get please_enter_email;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @otp_sent_successfully.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otp_sent_successfully;

  /// No description provided for @something_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_wrong;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get new_password;

  /// No description provided for @create_new_password.
  ///
  /// In en, this message translates to:
  /// **'Create a new password. Ensure it differs from previous ones for security'**
  String get create_new_password;

  /// No description provided for @new_password_field.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password_field;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @please_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get please_confirm_password;

  /// No description provided for @passwords_dont_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwords_dont_match;

  /// No description provided for @update_password.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password;

  /// No description provided for @failed_to_fetch_qr.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch QR'**
  String get failed_to_fetch_qr;

  /// No description provided for @qr_code.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get qr_code;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @scan_qr.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code to check in'**
  String get scan_qr;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @valid_until.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get valid_until;

  /// No description provided for @refresh_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Refresh QR Code'**
  String get refresh_qr_code;

  /// No description provided for @general_error.
  ///
  /// In en, this message translates to:
  /// **'=== General Error ==='**
  String get general_error;

  /// No description provided for @stack.
  ///
  /// In en, this message translates to:
  /// **'Stack'**
  String get stack;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get login_failed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @eng.
  ///
  /// In en, this message translates to:
  /// **'Eng'**
  String get eng;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

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

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @attendance_recorded.
  ///
  /// In en, this message translates to:
  /// **'Attendance has been recorded'**
  String get attendance_recorded;

  /// No description provided for @attendance_failed.
  ///
  /// In en, this message translates to:
  /// **'Attendance registration failed'**
  String get attendance_failed;

  /// No description provided for @car_registered.
  ///
  /// In en, this message translates to:
  /// **'The car is registered'**
  String get car_registered;
  /// No description provided for @vehicle_registration.
  ///
  /// In en, this message translates to:
  String get vehicle_registration;
  String get register_vehicle;
  String get plate_number;
  String get Employee_ID;
String get e_g;
String get please_enter_number;
String get register_car;
String get d1;
String get executed;
String get new_command;
String get open;
String get close;
String get on_line;
String get off_line;
String get work;
String get view_all;
String get no_activity;
String get data_updated;
String get save_change;
String get days_of_attendance;
String get day;
String get days_of_absence;
String get late_days;
String get details;
String get no_attendance_details_available;
String get present;
String get late;
String get absent;
String get entry;
String get exit;
String get parking;
String get no_data;
  String get report;
  String get complaint;
  String get home;
  String get control;
  String get monthly;
  String get check_in;
  String get check_out;
  String get total;
  String get week;
  String get month;
  String get total_day;
  String get no_attendance_details;
  String get no_report;
  String get jan;
  String get feb;
  String get mar;
  String get apr;
  String get may;
  String get jun;
  String get jul;
  String get aug;
  String get sep;
  String get oct;
  String get nov;
  String get dec;
  String get day_mon;
  String get day_tue;
  String get day_wed;
  String get day_thu;
  String get day_fri;
  String get day_sat;
  String get day_sun;
  String get employee_number;
  String get edit;






}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
