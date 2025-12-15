import 'package:flutter/material.dart';
import 'package:skinsync_ai/route_generator.dart';

class ScanYourFaceScreen extends StatelessWidget {
  const ScanYourFaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(faceDetection),
          child: Container(
            color: Colors.blue,
            child: Text('Scan Your Face Screen',))),
      ),
    );
  }
}