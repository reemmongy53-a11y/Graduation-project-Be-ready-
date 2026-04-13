import 'package:flutter/material.dart';
import 'package:new_project/attendance_report/Att-report_screen.dart';
import 'package:new_project/Ui/Security%20screen/security_screen.dart';
import 'package:new_project/Ui/statusService/gateService/Status.dart';
import 'package:new_project/Ui/auth_Screen/AuthScreen.dart';
import 'package:new_project/Ui/auth_Screen/LogIn%20Screen/LoginForm.dart';
import 'package:new_project/Ui/auth_Screen/RegisterScreen/SignupForm.dart';
import 'package:new_project/Ui/complaint.dart';
import 'package:new_project/Ui/employee/employeeScreen.dart';
import 'package:new_project/data_qr/qr-Screen.dart';
import 'package:new_project/forgetPassword/chackEmail.dart';
import 'package:new_project/forgetPassword/newPassword.dart';
import 'package:new_project/mainScreen.dart';
import 'package:new_project/parking%20report/Parking.dart';
import 'package:new_project/providers/ThemeProvider.dart';
import 'package:new_project/providers/languageProvider.dart';
import 'package:new_project/vehicle/vehicleEntry.dart';
import 'package:new_project/core/di/di.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'package:new_project/design/AppTheme.dart';
import 'package:new_project/routes.dart';
import 'package:provider/provider.dart';
import 'cach/appSharedPreferences.dart';
import 'forgetPassword/Forgot password.dart';
import 'l10n/app_localizations.dart';
import 'profile/data-list/profileScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSharedPreferences.init();
  await UserSession.load();
  configureDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).getSelectedThemeMode(),

      initialRoute: UserSession.token.isNotEmpty
          ? AppRoutes.mainScreen.name
          : AppRoutes.authScreen.name,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Provider.of<LanguageProvider>(context).getSelectedLocale(),
      routes: {
        AppRoutes.logInForm.name: (context) => LoginForm(),
        AppRoutes.signUpForm.name: (context) => SignupForm(),
        AppRoutes.authScreen.name: (context) => AuthScreen(),
        AppRoutes.mainScreen.name: (context) => const MainScreen(),
        AppRoutes.securityScreen.name: (context) => SecurityScreen(),
        AppRoutes.QR.name: (context) => Qr(),
        AppRoutes.AttReport.name: (context) => AttReport(),
        AppRoutes.complaint.name: (context) => Complaint(),
        AppRoutes.vehicleReport.name: (context) => VehicleEntry(),
        AppRoutes.status.name: (context) => Status(),
        AppRoutes.employee.name: (context) => EmployeeScreen(),
        AppRoutes.profile.name: (context) => ProfileScreen(),
        AppRoutes.forgotPassword.name: (context) => ForgotPassword(),
        AppRoutes.checkEmail.name: (context) => CheckEmail(),
        AppRoutes.newPassword.name: (context) => NewPassword(),
        AppRoutes.parkingReport.name: (context) => ParkingScreen(),
      },
    );
  }
}
