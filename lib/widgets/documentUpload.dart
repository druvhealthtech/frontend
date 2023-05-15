import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import '../../res/variables.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/apis/config.dart';

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({Key? key}) : super(key: key);

  @override
  _DocumentUploadState createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  late File _selectedFile = File('');
  late String _fileType = "labReport";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;
    // file = result.first;
    print('h2i');
    print('hi ${result.files.first.path}');
    final file = File(result.files.single.path!);

    setState(() {
      _selectedFile = file;
    });
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://${Config.apiURL}${Config.uploadDocument}'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    final fileStream = http.ByteStream(_selectedFile.openRead());
    final fileLength = await _selectedFile.length();

    final multipartFile = http.MultipartFile(
      'pdf',
      fileStream,
      fileLength,
      filename: path.basename(_selectedFile.path),
      contentType: MediaType('application', 'pdf'),
    );

    request.files.add(multipartFile);
    request.fields['type'] = _fileType;

    final response = await request.send();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File uploaded successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File upload failed'),
        ),
      );
    }
    Navigator.pop(context);
    setState(() {
      _selectedFile = File('');
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(body: CircularProgressIndicator());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload Document'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'File Type',
                  ),
                  value: _fileType,
                  onChanged: (value) {
                    setState(() {
                      _fileType = value!;
                    });
                  },
                  items: <String>['labReport', 'prescription']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selectFile,
                  child: Text('Select File'),
                ),
                const SizedBox(height: 16),
                if (_selectedFile != null) ...[
                  Text(
                    'Selected File: ${path.basename(_selectedFile.path)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: _uploadFile,
                    child: Text('Upload File'),
                  ),
                ],
              ],
            ),
          ),
        ));
  }
}
