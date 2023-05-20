import 'package:druvtech/screens/reportDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../res/variables.dart';
import '../utils/apis/config.dart';

class ReportScreen extends StatefulWidget {
  final String documentId;

  ReportScreen({required this.documentId});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Map<String, dynamic>? _reportData;
  bool _isLoading = false;

  Future<void> _fetchReport() async {
    setState(() {
      _isLoading = true;
    });

    // Set the headers for the API request
    final Map<String, String> headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Set the body of the API request
    final Map<String, dynamic> body = {
      'documentId': widget.documentId,
    };

    try {
      final response = await http.get(
          Uri.parse(
              'http://${Config.apiURL}${Config.report}?documentId=${widget.documentId}'),
          headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final success = jsonResponse['success'];
        if (success) {
          setState(() {
            _reportData = jsonResponse['report']['details'];
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load report from API');
        }
      } else {
        throw Exception('Failed to load report from API');
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _reportData == null
              ? const Center(
                  child: Text('Failed to load report'),
                )
              : ListView(
                  children: _reportData!.keys.map((key) {
                    return ListTile(
                      title: Text(key),
                      subtitle: Text('${_reportData![key]}'),
                      onTap: () {
                        // Navigate to the ReportScreen and pass the document ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetailScreen(
                              parameter: key,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
    );
  }
}
