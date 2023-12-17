import 'dart:io' show File;
import 'package:cardiowave/backend/ai_script_management.dart';
import 'package:cardiowave/backend/file_management.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../widgets/custom_button.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  FileManager fileManager = FileManager();
  AIScript aiScript = AIScript();
  File? _resultImage;
  String resultDistance = "-1";
  static final _log = Logger();

  @override
  Widget build(BuildContext context) {
    return _buildResultDetails();
  }

  Widget _buildResultDetails() {
    return FutureBuilder(
      future: aiScript.runAlgorithm(
          fileManager.getInputFolderPath(), fileManager.getOutputFolderPath()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show circular progress indicator
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error
          _log.e('Error: ${snapshot.error}');
          return Text('Error retrieving result');
        } else {
          resultDistance = snapshot.data!;
          return FutureBuilder(
              future: fileManager.retrieveImage(),
              builder: (context, snapshot_image) {
                if (snapshot_image.connectionState == ConnectionState.waiting) {
                  // Show circular progress indicator
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot_image.hasError) {
                  // Handle error
                  _log.e('Error: ${snapshot_image.error}');
                  return Text('Error retrieving result');
                } else {
                  _resultImage = fileManager.file;
                  return Scaffold(
                    body: Stack(
                      children: [
                        Container(
                          color: Colors.white,
                        ),
                        Positioned(
                            left: 30,
                            top: 30,
                            bottom: 30,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: GestureDetector(
                              child: _buildResultImage(),
                            )),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Icon(
                            Icons.image,
                            size: 30,
                          ),
                        ),
                        Positioned(
                          right: 50,
                          top: MediaQuery.of(context).size.height * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: Text(resultDistance)),
                              _buildCustomButton(
                                  "REÎNCEARCĂ DIAGNOSTIC", () {}),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 50,
                          bottom: 30,
                          child: _buildCustomButton("ANULEAZĂ", () {}),
                        ),
                      ],
                    ),
                  );
                }
              });
        }
      },
    );
  }

  Widget _buildResultImage() {
    return Positioned.fill(
      child: Image.file(
        _resultImage!,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCustomButton(String label, VoidCallback onPressed) {
    return CustomButton(
      label: label,
      borderColor: Color(0xFF8D1722),
      onPressed: onPressed,
    );
  }
}
