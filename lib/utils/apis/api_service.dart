import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/patient_details_response_model.dart';
import '../../res/variables.dart';
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

  static Future<PatientDetailsResponseModel> patientDetails(
    String firstName,
    String middleName,
    String lastName,
    String gender,
    String dob,
    double height,
    double weight,
    String bloodGroup,
  ) async {
    if (bloodGroup == 'ap') bloodGroup = 'A+';
    if (bloodGroup == 'an') bloodGroup = 'A-';
    if (bloodGroup == 'bp') bloodGroup = 'B+';
    if (bloodGroup == 'bn') bloodGroup = 'B-';
    if (bloodGroup == 'op') bloodGroup = 'O+';
    if (bloodGroup == 'on') bloodGroup = 'O-';
    if (bloodGroup == 'abp') bloodGroup = 'AB+';
    if (bloodGroup == 'abn') bloodGroup = 'AB-';

    print("\n----------------------------------");
    print(firstName);
    print(middleName);
    print(lastName);
    print(gender);
    print(dob);
    print(height);
    print(weight);
    print(bloodGroup);
    print(token);
    print("----------------------------------\n");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.http(Config.apiURL, Config.patientDetails);

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "firstName": firstName,
          "middleName": middleName,
          "lastName": lastName,
          "dateOfBirth": dob,
          "gender": gender,
          "aadhaarNumber": "",
          "height": height,
          "weight": weight,
          "bloodGroup": bloodGroup,
        },
      ),
    );

    return PatientDetailsResponseModel.fromJson(json.decode(response.body));
  }

  static Future<PatientDetailsResponseModel> patientLoginDetails(
    String emailId,
  ) async {
    print("\n----------------------------------");
    print(emailId);
    print("----------------------------------\n");
    Map<String, String> requestHeaders = {'Content-type': 'application/json'};

    var url = Uri.http(Config.apiURL, Config.patientLoginDetails);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "gmailId": emailId,
          "loginMethods": ["gmailId"],
          "userType": "patient",
        },
      ),
    );

    return PatientDetailsResponseModel.fromJson(json.decode(response.body));
  }

  static Future<PatientDetailsResponseModel> diabetesDetails(
    String type,
    bool insulin,
    bool pills,
    String sugarBeforeMealLow,
    String sugarBeforeMealHigh,
    String sugarAfterMealLow,
    String sugarAfterMealHigh,
    String fitnessLevel,
  ) async {
    print("\n----------------------------------");
    print(type);
    print('insulin $insulin');
    print('pills $pills');
    print(sugarBeforeMealLow);
    print(sugarBeforeMealHigh);
    print(sugarAfterMealLow);
    print(sugarAfterMealHigh);
    print(fitnessLevel);
    print(token);
    print("----------------------------------\n");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var therapyType = List.empty();
    if (insulin && pills) {
      therapyType = ['insulin', 'pills'];
    } else if (insulin) {
      therapyType = ['insulin'];
    } else if (pills) {
      therapyType = ['pills'];
    } else {
      therapyType = [];
    }

    if (type == 'one') type = 'Type 1';
    if (type == 'two') type = 'Type 2';
    if (type == 'gestational') type = 'Gestational';
    if (type == 'prediabetes') type = 'Prediabetes';
    if (type == 'other') type = 'Other';

    var url = Uri.http(Config.apiURL, Config.diabetesDetails);

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(
        {
          "type": type,
          "therapyType": therapyType,
          "measurementType": "mg/dl",
          "targetGlucose": {
            "beforeMeal": {
              "lowest": sugarBeforeMealLow,
              "highest": sugarBeforeMealHigh
            },
            "afterMeal": {
              "lowest": sugarAfterMealLow,
              "highest": sugarAfterMealHigh
            }
          },
          "fitnessLevel": fitnessLevel,
        },
      ),
    );

    print(response.body);

    // return patientDetailsResponseModel(response.body);
    return PatientDetailsResponseModel.fromJson(json.decode(response.body));
  }
}
