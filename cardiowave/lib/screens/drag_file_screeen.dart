import 'dart:io' show File;
import 'package:cardiowave/backend/ai_script_management.dart';
import 'package:cardiowave/backend/file_management.dart';
import 'package:cardiowave/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/custom_button.dart';

class DragFileScreen extends StatefulWidget {
  const DragFileScreen({Key? key}) : super(key: key);

  @override
  _DragFileScreenState createState() => _DragFileScreenState();
}

class _DragFileScreenState extends State<DragFileScreen> {
  FileManager fileManager = FileManager();
  AIScript aiScript = AIScript();
  List<File?> _selectedImages = [null, null]; // Updated to hold 2 images

  @override
  void initState() {
    super.initState();
    fileManager.createInputFolder();
    fileManager.createOutputFolder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFCF3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFFFFCF3),
            elevation: 0,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(left:16, right: 16, top: 16),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: const Image(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                    width: 75,
                    height: 75,
                  ),
                ),
              ],
            ),
            )
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDragAndDropContainer(0),
                  ),
                  SizedBox(width: 32.0),
                  Expanded(
                    child: _buildDragAndDropContainer(1),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 48.0), // Adjust as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCustomButton("ÎNCARCĂ IMAGINILE", _pickImages, true),
                SizedBox(width: 16.0),
                _buildCustomButton("ANALIZEAZĂ", _onDonePressed, _canPressDoneButton()),
                SizedBox(width: 16.0),
                _buildCustomButton("ANULEAZĂ", _clearImages, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragAndDropContainer(int index) {
    return GestureDetector(
      onTap: () => _pickImage(index),
      onPanUpdate: (details) {
        if (_selectedImages[index] == null) {
          _onImagePicked(File("fake_path"), index);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height *
            0.6, // Adjust the height as needed
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Center(
          child: _selectedImages[index] != null
              ? _buildImageWidget(_selectedImages[index]!)
              : Text(
                  "Trage și plasează imaginea aici ...",
                  style: TextStyle(
                    color: Color(0xFF414040),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(File image) {
    return Positioned.fill(
      child: Image.file(
        image,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCustomButton(
      String label, VoidCallback onPressed, bool isEnabled) {
    return CustomButton(
      label: label,
      borderColor: Color(0xFF8D1722),
      onPressed: isEnabled ? onPressed : null,
    );
  }

  bool _canPressDoneButton() {
    return _selectedImages.any((image) => image != null);
  }

  Future<void> _onImagePicked(File pickedFile, int index) async {
    await fileManager.saveInputImage(pickedFile, index);

    setState(() {
      _selectedImages[index] = pickedFile;
    });
  }

  Future<void> _onDonePressed() async {
    List<File?> selectedImages = List.from(_selectedImages);

    // If more than 2 images are selected, only keep the first two.
    selectedImages = selectedImages.take(2).toList();

    // // If only one image is selected, duplicate it to have two images.
    // if (selectedImages.length == 1) {
    //   selectedImages.add(selectedImages[0]);
    // }

    for (int i = 0; i < selectedImages.length; i++) {
      if (selectedImages[i] != null) {
        await fileManager.saveInputImage(selectedImages[i]!, i);
      }
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ResultScreen();
    }));
  }

  Future<void> _pickImages() async {
    await fileManager.startClearOfFiles();
    _clearImages();
    for (int i = 0; i < _selectedImages.length; i++) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null) {
        _onImagePicked(File(result.files.single.path!), i);
      }
    }
  }

  void _clearImages() {
    for (int i = 0; i < _selectedImages.length; i++) {
      setState(() {
        _selectedImages[i] = null;
      });
    }
  }

  Future<void> _pickImage(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      _onImagePicked(File(result.files.single.path!), index);
    }
  }
}
