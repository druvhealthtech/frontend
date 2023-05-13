import 'dart:convert';

PatientDetailsResponseModel patientDetailsResponseModel(String str) =>
    PatientDetailsResponseModel.fromJson(json.decode(str));

class PatientDetailsResponseModel {
  PatientDetailsResponseModel({
    required this.token,
  });

  late final String? token;

  PatientDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }
}
