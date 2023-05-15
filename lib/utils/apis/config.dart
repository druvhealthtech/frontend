class Config {
  static const String apiURL = "192.168.1.75:8080";
  static const String otpLoginAPI = "/api/abha/generateOtp";
  static const String otpVerifyAPI = "/api/abha/verifyOtp";
  static const String checkAndGenerateMobileOTPAPI =
      "/api/abha/checkAndGenerateMobileOTP";
  static const String generateMobileOTPAPI = "/api/abha/generateMobileOTP";
  static const String verifyMobileOtpAPI = "/api/abha/verifyMobileOtp";
  static const String createHealthIdWithPreVerifiedAPI =
      "/api/abha/createHealthIdWithPreVerified";
  static const String patientLoginDetails = "/api/patient";
  static const String patientDetails = "/api/personalDetails";
  static const String diabetesDetails = "/api/diabetesDetails";
  static const String documents = "/api/document/all";
  static const String report = "/api/report/";
  static const String uploadDocument = "/api/document";
  static const String bloodPressure = "/api/bloodPressureReading/all";
}
