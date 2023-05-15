import 'package:flutter/material.dart';

import '../../res/custom_colors.dart';
import '../../res/variables.dart';
import '../../widgets/documentList.dart';
import '../../widgets/documentUpload.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreen();
}

class _DocumentScreen extends State<DocumentScreen> {
  bool refresh = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Flexible(child: DocumentList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DocumentUpload()),
            ).then((value) => setState(() {}));
          },
          child: const Icon(Icons.add)),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 75),
        child: Text(''),
      ),
    );
  }
}
