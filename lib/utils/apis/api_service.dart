import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:druvtech/models/otp_login_response_model.dart';

class APIService {
  static var client = http.Client();

  static Future<OtpLoginResponseModel> otpLogin(
    String aadhar,
  ) async {
    print("\n----------------------------------");
    print(int.parse(aadhar));
    print("----------------------------------\n");
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.otpLoginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "aadhaar": int.parse(aadhar),
        },
      ),
    );

    return otpLoginResponseJSON(response.body);
  }

  static Future<OtpLoginResponseModel> verifyOTP(
    String txnId,
    String otp,
  ) async {
    print("\n----------------------------------");
    print(txnId);
    print(otp);
    print("----------------------------------\n");
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.otpVerifyAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "otp": int.parse(otp),
          "txnId": txnId,
        },
      ),
    );

    print("\n----------------------------------");
    print(response.body);
    print("----------------------------------\n");
    if (response.statusCode == 404) {
      return otpLoginResponseJSON(jsonEncode({"txnId": null}));
    }

    return otpLoginResponseJSON(response.body);
    // return OtpLoginResponseModel.fromJson(json.decode(response.body));
  }

  static Future<OtpLoginResponseModel> CheckMobileLinked(
    String mobile,
    String txnId,
  ) async {
    print("\n----------------------------------");
    print(mobile);
    print(txnId);
    print("----------------------------------\n");
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.checkAndGenerateMobileOTPAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "mobile": mobile,
          "txnId": txnId,
        },
      ),
    );

    print("\n----------------------------------");
    print(response.body);
    print("----------------------------------\n");
    if (response.statusCode == '404') {
      // return otpLoginResponseJSON(
      //   jsonEncode({"txnId": null, "mobileLinked": false}),
      // );

      var url = Uri.http(Config.apiURL, Config.generateMobileOTPAPI);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          {
            "mobile": mobile,
            "txnId": txnId,
          },
        ),
      );

      return otpLoginResponseJSON(response.body);
    }

    return otpLoginResponseJSON(response.body);
  }

  static Future<OtpLoginResponseModel> MobileOtpLogin(
    String mobile,
    String txnId,
  ) async {
    print("\n----------------------------------");
    print(mobile);
    print(txnId);
    print("----------------------------------\n");
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.generateMobileOTPAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "mobile": mobile,
          "txnId": txnId,
        },
      ),
    );

    return otpLoginResponseJSON(response.body);
  }

  static Future<OtpLoginResponseModel> MobileVerifyOTP(
    String txnId,
    String otp,
  ) async {
    print("\n----------------------------------");
    print(txnId);
    print(otp);
    print("----------------------------------\n");
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.verifyMobileOtpAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "otp": int.parse(otp),
          "txnId": txnId,
        },
      ),
    );

    return otpLoginResponseJSON(response.body);
    // return OtpLoginResponseModel.fromJson(json.decode(response.body));
  }

  static Future<OtpLoginResponseModel> createHealthIdWithPreVerified(
    String email,
    String firstName,
    String healthId,
    String lastName,
    String middleName,
    String password,
    String profilePhoto,
    String txnId,
  ) async {
    print("\n----------------------------------");
    print(email);
    print(firstName);
    print(healthId);
    print(lastName);
    print(middleName);
    print(password);
    print(profilePhoto);
    print(txnId);
    print("----------------------------------\n");
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.createHealthIdWithPreVerifiedAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "email": email,
          "firstName": firstName,
          "healthId": healthId,
          "lastName": lastName,
          "middleName": middleName,
          "password": password,
          "profilePhoto": "",
          "txnId": txnId,
        },
      ),
    );

    return otpLoginResponseJSON(response.body);
    // return OtpLoginResponseModel.fromJson(json.decode(response.body));
  }
}
