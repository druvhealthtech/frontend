import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../res/variables.dart';
import '../utils/apis/config.dart';

class HeartRateChart extends StatefulWidget {
  const HeartRateChart({super.key});

  @override
  _HeartRateChartState createState() => _HeartRateChartState();
}

class _HeartRateChartState extends State<HeartRateChart> {
  late List<charts.Series<HeartRateReading, DateTime>> _seriesData = [];

  Future<List<HeartRateReading>> _fetchData() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://${Config.apiURL}${Config.heartRate}'),
        headers: requestHeaders);
    print("TEMPPP: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body)['heartRateReadings'];

      List<HeartRateReading> data = jsonResponse.map((reading) {
        return HeartRateReading(
          heartRate: reading['heartRate'],
          timestamp: DateTime.parse(reading['timestamp']),
        );
      }).toList();

      return data;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  void _generateData(List<HeartRateReading> readings) {
    _seriesData = [
      charts.Series<HeartRateReading, DateTime>(
        id: 'Heart Rate',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HeartRateReading reading, _) => reading.timestamp,
        measureFn: (HeartRateReading reading, _) => reading.heartRate,
        data: readings,
      )
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
        title: Text('Heart Rate Chart'),
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

class HeartRateReading {
  final int heartRate;
  final DateTime timestamp;

  HeartRateReading({
    required this.heartRate,
    required this.timestamp,
  });
}
