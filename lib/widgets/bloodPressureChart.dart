import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../res/variables.dart';
import '../utils/apis/config.dart';

class BloodPressureChart extends StatefulWidget {
  const BloodPressureChart({super.key});

  @override
  _BloodPressureChartState createState() => _BloodPressureChartState();
}

class _BloodPressureChartState extends State<BloodPressureChart> {
  late List<charts.Series<BloodPressureReading, DateTime>> _seriesData = [];

  Future<List<BloodPressureReading>> _fetchData() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://${Config.apiURL}${Config.bloodPressure}'),
        headers: requestHeaders);
    print("TEMPPP: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body)['bloodPressureReadings'];

      List<BloodPressureReading> data = jsonResponse.map((reading) {
        return BloodPressureReading(
          systolic: reading['systolic'],
          diastolic: reading['diastolic'],
          timestamp: DateTime.parse(reading['timestamp']),
        );
      }).toList();

      return data;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  void _generateData(List<BloodPressureReading> readings) {
    _seriesData = [
      charts.Series<BloodPressureReading, DateTime>(
        id: 'Systolic',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BloodPressureReading reading, _) => reading.timestamp,
        measureFn: (BloodPressureReading reading, _) => reading.systolic,
        data: readings,
      ),
      charts.Series<BloodPressureReading, DateTime>(
        id: 'Diastolic',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (BloodPressureReading reading, _) => reading.timestamp,
        measureFn: (BloodPressureReading reading, _) => reading.diastolic,
        data: readings,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    _fetchData().then((data) {
      setState(() {
        _generateData(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Pressure Chart'),
      ),
      body: _seriesData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: 300,
              child: charts.TimeSeriesChart(
                _seriesData,
                animate: true,
                defaultRenderer: charts.LineRendererConfig(
                  includePoints: true,
                ),
                dateTimeFactory: const charts.LocalDateTimeFactory(),
                primaryMeasureAxis: charts.NumericAxisSpec(
                  tickProviderSpec: charts.BasicNumericTickProviderSpec(
                    desiredTickCount: 5,
                  ),
                  tickFormatterSpec:
                      charts.BasicNumericTickFormatterSpec.fromNumberFormat(
                    NumberFormat.compact(),
                  ),
                  renderSpec: const charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                    ),
                    lineStyle: charts.LineStyleSpec(
                      color: charts.MaterialPalette.white,
                    ),
                  ),
                ),
                domainAxis: const charts.DateTimeAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                    ),
                    lineStyle: charts.LineStyleSpec(
                      color: charts.MaterialPalette.white,
                    ),
                  ),
                ),
                behaviors: [
                  charts.SeriesLegend(
                    position: charts.BehaviorPosition.bottom,
                    horizontalFirst: false,
                    desiredMaxRows: 2,
                    cellPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    entryTextStyle: const charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class BloodPressureReading {
  final int systolic;
  final int diastolic;
  final DateTime timestamp;

  BloodPressureReading({
    required this.systolic,
    required this.diastolic,
    required this.timestamp,
  });
}
