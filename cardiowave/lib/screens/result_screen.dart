import 'dart:io' show File;
import 'package:cardiowave/backend/ai_script_management.dart';
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
  List<File?> _resultImages = [null, null];
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
          return FutureBuilder(future: Future.wait(
            _resultImages.map((image) {
              return fileManager.retrieveImage();
            }),
          ), builder: (context, snapshotImages) {
            if (snapshotImages.connectionState == ConnectionState.waiting) {
              // Show circular progress indicator
              return Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshotImages.hasError) {
              // Handle error
              _log.e('Error: ${snapshotImages.error}');
              return Text('Error retrieving result');
            } else {
              for (int i = 0; i < snapshotImages.data!.length; i++) {
                _resultImages[i] = fileManager.file;
              }

              return Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      flexibleSpace: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: const Image(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildResultImage(_resultImages[0]),
                            ),
                            SizedBox(width: 32.0),
                            Expanded(
                              child: _buildResultImage(_resultImages[1]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   right: 0,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: Image(
                    //       image: AssetImage('assets/images/logo.png'),
                    //       fit: BoxFit.cover,
                    //       width: 50,
                    //       height: 50,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 42.0, left: 250.0, right: 430.0), // Adjust as needed
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
                                "REZULTAT",
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
                              _buildCustomButton(
                                "GENEREAZĂ RAPORT",
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FormPage(),
                                    ),
                                  );
                                }
                              ),
                              SizedBox(height: 16.0),
                              _buildCustomButton("ANULEAZĂ", () {}),
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
