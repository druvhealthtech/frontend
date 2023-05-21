import 'package:flutter/material.dart';
import 'package:druvtech/res/custom_colors.dart';

class ABHAHealthIDScreen extends StatelessWidget {
  final String healthID;
  const ABHAHealthIDScreen({Key? key, required this.healthID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      body: Center(
        child: Text(
          'Your ABHA Health ID -> $healthID',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
