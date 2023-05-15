import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../res/variables.dart';
import '../screens/report_screen.dart';
import '../utils/apis/config.dart';

class Document {
  final String id;
  final String patientId;
  final String name;
  final String type;
  final String ocrStatus;
  final String url;
  final DateTime uploadTime;

  Document({
    required this.id,
    required this.patientId,
    required this.name,
    required this.type,
    required this.ocrStatus,
    required this.url,
    required this.uploadTime,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['_id'],
      patientId: json['patientId'],
      name: json['name'],
      type: json['type'],
      ocrStatus: json['ocrStatus'],
      url: json['url'],
      uploadTime: DateTime.parse(json['uploadTime']),
    );
  }
}

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});
  @override
  _DocumentListState createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  List<Document> _documents = [];

  Future<List<Document>> _fetchDocuments() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response = await http.get(
        Uri.parse('http://${Config.apiURL}${Config.documents}'),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body)['documents'];

      List<Document> documents = jsonResponse.map((document) {
        return Document.fromJson(document);
      }).toList();

      return documents;
    } else {
      throw Exception('Failed to load documents from API');
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchDocuments().then((documents) {
      setState(() {
        _documents = documents;
      });
    });
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _fetchDocuments().then((documents) {
        if (_documents != documents) {
          setState(() {
            _documents = documents;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          final document = _documents[index];
          final uploadTime =
              DateFormat('dd MMM yyyy hh:mm a').format(document.uploadTime);

          // Check if the document's ocrStatus is not "pending"
          final isClickable = document.ocrStatus != "pending";

          return InkWell(
            onTap: isClickable
                ? () {
                    // Navigate to the ReportScreen and pass the document ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReportScreen(documentId: document.id),
                      ),
                    );
                  }
                : null,
            child: ListTile(
              title: Text(document.name),
              subtitle: Text('${document.type}, $uploadTime'),
              trailing: Text(document.ocrStatus),
            ),
          );
        },
      ),
    );
  }
}
