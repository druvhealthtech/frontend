import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:charts_flutter/flutter.dart' as charts;
import '../res/variables.dart';
import '../utils/apis/config.dart';

class ReportDetailScreen extends StatefulWidget {
  final String parameter;

  const ReportDetailScreen({required this.parameter});

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  List<Map<String, dynamic>> _details = [];
  late List<charts.Series<ParameterReading, DateTime>> _seriesData = [];
  bool _isLoading = false;

  Future<List<ParameterReading>> _fetchReportDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
          Uri.parse(
              'http://${Config.apiURL}${Config.reportDetails}?parameter=${widget.parameter}'),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            json.decode(response.body)['details'];
        print(jsonResponse);
        List<ParameterReading> data = jsonResponse.map((reading) {
          return ParameterReading(
            value: reading['value'],
            timestamp: DateTime.parse(reading['timestamp']),
          );
        }).toList();

        return data;
      } else {
        throw Exception('Failed to load report details from API');
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load report details from API');
    }
  }

  void _generateData(List<ParameterReading> dataPoints) {
    _seriesData = [
      charts.Series<ParameterReading, DateTime>(
        id: widget.parameter,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ParameterReading point, _) => point.timestamp,
        measureFn: (ParameterReading point, _) => point.value,
        data: dataPoints,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _fetchReportDetails().then((data) {
      setState(() {
        _generateData(data);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Detail - ${widget.parameter}'),
      ),
      body: _isLoading
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

class ParameterReading {
  final num value;
  final DateTime timestamp;

  ParameterReading({required this.value, required this.timestamp});
}
