import 'dart:convert';

OtpLoginResponseModel otpLoginResponseJSON(String str) =>
    OtpLoginResponseModel.fromJson(json.decode(str));

class OtpLoginResponseModel {
  OtpLoginResponseModel({
    // required this.message,
    required this.txnId,
    // required this.otp,
    required this.mobileLinked,
    required this.healthIdNumber,
  });

  // late final String? message;
  late final String? txnId;
  // late final String? otp;
  late final bool? mobileLinked;
  late final String? healthIdNumber;

  OtpLoginResponseModel.fromJson(Map<String, dynamic> json) {
    // message = json['message'];
    txnId = json['txnId'];
    // otp = json['otp'];
    mobileLinked = json['mobileLinked'];
    healthIdNumber = json['healthIdNumber'];
  }
}
