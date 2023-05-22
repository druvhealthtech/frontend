import 'dart:async';

import 'package:druvtech/widgets/glucoseChart.dart';
import 'package:druvtech/widgets/heartRateChart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../res/variables.dart';
import '../utils/apis/config.dart';
import '../widgets/bloodPressureChart.dart';

class HealthData {
  final int systolic;
  final int diastolic;
  final int heartRate;
  final int glucoseValue;

  HealthData(
      {required this.systolic,
      required this.diastolic,
      required this.heartRate,
      required this.glucoseValue});

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      heartRate: json['heartRate'],
      glucoseValue: json['glucoseValue'],
    );
  }
}

class HealthDataScreen extends StatefulWidget {
  const HealthDataScreen({super.key});

  @override
  _HealthDataScreenState createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  late HealthData healthData = HealthData(
    systolic: 0,
    diastolic: 0,
    heartRate: 0,
    glucoseValue: 0,
  );

  Future<HealthData> fetchData() async {
    const bloodPressureUrl =
        "http://${Config.apiURL}${Config.bloodPressureLatest}";
    const glucoseUrl = "http://${Config.apiURL}${Config.glucoseLatest}";
    const heartRateUrl = "http://${Config.apiURL}${Config.heartRateLatest}";

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final bloodPressureResponse =
        await http.get(Uri.parse(bloodPressureUrl), headers: requestHeaders);
    final glucoseResponse =
        await http.get(Uri.parse(glucoseUrl), headers: requestHeaders);
    final heartRateResponse =
        await http.get(Uri.parse(heartRateUrl), headers: requestHeaders);
    if (bloodPressureResponse.statusCode == 200 &&
        glucoseResponse.statusCode == 200 &&
        heartRateResponse.statusCode == 200) {
      final bloodPressureJson = json.decode(bloodPressureResponse.body);
      final glucoseJson = json.decode(glucoseResponse.body);
      final heartRateJson = json.decode(heartRateResponse.body);
      int systolic = bloodPressureJson['bloodPressureReading'] != null
          ? bloodPressureJson['bloodPressureReading']['systolic']
          : 0;
      int diastolic = bloodPressureJson['bloodPressureReading'] != null
          ? bloodPressureJson['bloodPressureReading']['diastolic']
          : 0;
      int heartRate = heartRateJson['heartRateReading'] != null
          ? heartRateJson['heartRateReading']['heartRate']
          : 0;
      int glucoseValue = glucoseJson['glucoseReading'] != null
          ? glucoseJson['glucoseReading']['glucoseValue']
          : 0;
      HealthData dd = HealthData(
          systolic:
              systolic, //bloodPressureJson['bloodPressureReading']['systolic'],
          diastolic: diastolic,
          heartRate:
              heartRate, //heartRateJson['heartRateReading']['heartRate'],
          glucoseValue:
              glucoseValue); //glucoseJson['glucoseReading']['glucoseValue']);
      return dd;
    } else {
      throw Exception('Failed to fetch health data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((data) {
      setState(() {
        healthData = data;
      });
    });
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      fetchData().then((data) {
        setState(() {
          healthData = data;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: healthData == null
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  color: Colors.blueAccent,
                  child: ListTile(
                    title: const Text('Blood Pressure'),
                    subtitle: Text(
                      'Systolic: ${healthData.systolic == 0 ? '-' : healthData.systolic}\nDiastolic: ${healthData.diastolic == 0 ? '-' : healthData.diastolic}',
                    ),
                    onTap: () {
                      // Navigate to the ReportScreen and pass the document ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BloodPressureChart(),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  color: Colors.blueAccent,
                  child: ListTile(
                    title: const Text('Heart Rate'),
                    subtitle: Text(
                        'Rate: ${healthData.heartRate == 0 ? '-' : healthData.heartRate}'),
                    onTap: () {
                      // Navigate to the ReportScreen and pass the document ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HeartRateChart(),
                        ),
                      );
                    },
                  ),
                ),
                Card(
                  color: Colors.blueAccent,
                  child: ListTile(
                    title: const Text('Glucose Level'),
                    subtitle: Text(
                        'Value: ${healthData.glucoseValue == 0 ? '-' : healthData.glucoseValue}'),
                    onTap: () {
                      // Navigate to the ReportScreen and pass the document ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GlucoseChart(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
