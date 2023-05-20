import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../res/variables.dart';
import '../utils/apis/config.dart';

class GlucoseChart extends StatefulWidget {
  const GlucoseChart({super.key});

  @override
  _GlucoseChartState createState() => _GlucoseChartState();
}

class _GlucoseChartState extends State<GlucoseChart> {
  late List<charts.Series<GlucoseReading, DateTime>> _seriesData = [];

  Future<List<GlucoseReading>> _fetchData() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://${Config.apiURL}${Config.glucose}'),
        headers: requestHeaders);
    print("TEMPPP: ${response.body}");
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body)['glucoseReadings'];

      List<GlucoseReading> data = jsonResponse.map((reading) {
        return GlucoseReading(
          glucoseValue: reading['glucoseValue'],
          timestamp: DateTime.parse(reading['timestamp']),
        );
      }).toList();

      return data;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  void _generateData(List<GlucoseReading> readings) {
    _seriesData = [
      charts.Series<GlucoseReading, DateTime>(
        id: 'Glucose',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GlucoseReading reading, _) => reading.timestamp,
        measureFn: (GlucoseReading reading, _) => reading.glucoseValue,
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
        title: Text('Glucose Chart'),
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

class GlucoseReading {
  final int glucoseValue;
  final DateTime timestamp;

  GlucoseReading({
    required this.glucoseValue,
    required this.timestamp,
  });
}
