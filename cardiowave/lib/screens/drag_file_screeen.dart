import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/custom_button.dart';

class DragFileScreen extends StatefulWidget {
  @override
  _DragFileScreenState createState() => _DragFileScreenState();
}

class _DragFileScreenState extends State<DragFileScreen> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
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
              onTap: _pickImage,
              onPanUpdate: (details) {
                if (_selectedImage == null) {
                  _onFilesDropped([File("fake_path")]); // Placeholder file path
                }
              },
              child: _selectedImage != null
                  ? _buildImageWidget()
                  : Container(
                color: _selectedImage != null
                    ? Colors.greenAccent
                    : const Color(0xFFCDCDC8),
                child: Center(
                  child: Text(
                      "Trage și plasează imaginea aici ...",
                    style: TextStyle(
                      color: Color(0xFF414040),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                _buildCustomButton("ÎNCARCĂ IMAGINE", _pickImage),
                SizedBox(height: 10),
                _buildCustomButton("SNAPSHOT INSTANT", () {}),
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

  Widget _buildImageWidget() {
    return Positioned.fill(
      child: Image.file(
        _selectedImage!,
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

  Future<void> _onFilesDropped(List<File> files) async {
    setState(() {
      _selectedImage = files.isNotEmpty ? files.first : null;
    });
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      _onFilesDropped([File(result.files.single.path!)]);
    }
  }
}
