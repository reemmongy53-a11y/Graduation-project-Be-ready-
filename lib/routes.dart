enum AppRoutes{
 authScreen("AuthScreen"),
  logInForm("logIn"),
  signUpForm("signUp"),
  register("Register"),
  securityScreen("SecurityScreen"),
  dataFile("DataFile"),
  QR("QR"),
 AttReport("AttReport"),
 manualAtt("manualAtt"),
 complaint("complaint"),
 vehicleReport("vehicleReport"),
 status("Status"),
 employee("Employee"),
 profile("Profile"),
 forgotPassword("forgotPassword"),
 checkEmail("checkEmail"),
 newPassword("newPassword"),
 parkingReport("parkingReport"),
 mainScreen("MainScreen")






 ;


  final String route;
  const AppRoutes(this.route);
}