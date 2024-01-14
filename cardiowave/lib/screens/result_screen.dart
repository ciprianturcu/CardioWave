import 'dart:io' show File;
import 'package:cardiowave/backend/ai_script_management.dart';
import 'package:cardiowave/backend/colaps_calculation.dart';
import 'package:cardiowave/backend/file_management.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:cardiowave/screens/form_page.dart';

import '../widgets/custom_button.dart';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  FileManager fileManager = FileManager();
  AIScript aiScript = AIScript();
  List<File?> _resultImages = [];
  List<String> _resultDistances = [];
  late bool _colapsCase;
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
            color: const Color.fromRGBO(255, 252, 243, 1),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error
          _log.e('Error: ${snapshot.error}');
          return Text('Error retrieving result');
        } else {
          _resultDistances = snapshot.data!;
          return FutureBuilder(
              future: fileManager.retrieveImages(),
              builder: (context, snapshotImages) {
                if (snapshotImages.connectionState == ConnectionState.waiting) {
                  // Show circular progress indicator
                  return Container(
                    color: const Color.fromRGBO(255, 252, 243, 1),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshotImages.hasError) {
                  // Handle error
                  _log.e('Error: ${snapshotImages.error}');
                  return Text('Error retrieving result');
                } else {
                  _resultImages = snapshotImages.data!;
                  if (_resultDistances.length == 2) {
                    _colapsCase =
                        isColaps(_resultDistances[0], _resultDistances[1]);
                  } else {
                    _colapsCase = false;
                  }

                  return Scaffold(
                    backgroundColor: const Color.fromRGBO(255, 252, 243, 1),
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: Color(0xFFFFFCF3),
                            elevation: 0,
                            flexibleSpace: Padding(
                              padding:
                                  EdgeInsets.only(left: 16, right: 16, top: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: const Image(
                                      image:
                                          AssetImage('assets/images/logo.png'),
                                      fit: BoxFit.cover,
                                      width: 75,
                                      height: 75,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: () {
                                List<Widget> widgets = [];
                                for (int i = 0; i < _resultImages.length; i++) {
                                  widgets.add(
                                    Expanded(
                                      child:
                                          _buildResultImage(_resultImages[i]),
                                    ),
                                  );
                                  widgets.add(
                                    SizedBox(width: 32.0),
                                  );
                                }
                                widgets.removeLast();
                                return widgets;
                              }(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 42.0,
                              left: 250.0,
                              right: 250.0), // Adjust as needed
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${_resultDistances.map((distance) => 'Distance: $distance').join('\n')}\n${(_resultDistances.length == 2 ? ((_colapsCase) ? 'COLAPS' : 'NU E COLAPS') : '')}',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _buildCustomButton("GENEREAZĂ RAPORT", () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FormPage(
                                          distanceList: _resultDistances,
                                          isColaps: _colapsCase,
                                        ),
                                      ),
                                    );
                                  }),
                                  SizedBox(height: 16.0),
                                  _buildCustomButton("ANULEAZĂ", () {
                                    Navigator.pop(context);
                                  }),
                                ],
                              ),
                            ],
                          ),
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

  Widget _buildResultImage(File? image) {
    return Positioned.fill(
      child: Image.file(
        image!,
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
