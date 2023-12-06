// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _detectDiagnosisController = TextEditingController();
  final TextEditingController _finalDiagnosisController = TextEditingController();
  final TextEditingController _detectedDateController = TextEditingController();
  final TextEditingController _doctorObservationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _resetForm() {
    _nameController.clear();
    _doctorNameController.clear();
    _dateController.clear();
    _timeController.clear();
    _detectDiagnosisController.clear();
    _finalDiagnosisController.clear();
    _detectedDateController.clear();
    _doctorObservationController.clear();
  }

  Future<void> _generateAndSavePDF() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Nume Pacient: ${_nameController.text}\n\n'),
          pw.Text('Nume Doctor: ${_doctorNameController.text}\n\n'),
          pw.Text('Data Observatiei: ${_dateController.text}\n\n'),
          pw.Text('Ora Observatiei: ${_timeController.text}\n\n'),
          pw.Text('Diagnostic Detectat: ${_detectDiagnosisController.text}\n\n'),
          pw.Text('Diagnostic Hotarat: ${_finalDiagnosisController.text}\n\n'),
          pw.Text('Date Detectate: ${_detectedDateController.text}\n\n'),
          pw.Text('Observatii Medicului: ${_doctorObservationController.text}\n\n'),
        ],
      ),
    ));

    final Uint8List pdfBytes = await pdf.save();
    final String? filePath = await FilePicker.platform.saveFile(
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (filePath != null) {
      final File file = File(filePath);
      await file.writeAsBytes(pdfBytes);
    }
  }

  TextFormField _buildTextFormField(
    TextEditingController controller,
    String hintText,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelStyle: const TextStyle(color: Color.fromRGBO(65, 64, 64, 1)),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color.fromRGBO(203, 203, 201, 1),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(141, 23, 34, 1)),
        ),
      ),
      cursorColor: const Color.fromRGBO(65, 64, 64, 1),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Acest camp nu poate fi lasat liber!';
        }
        return null;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AppBar(
            title: const Text('RAPORT GENERAT', style: TextStyle(color: Color.fromRGBO(65, 64, 64, 1))),
            backgroundColor: const Color.fromRGBO(255, 252, 243, 1),
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
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(255, 252, 243, 1),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nume Pacient*",
                              style: TextStyle(color: Color.fromRGBO(65, 64, 64, 1), fontWeight: FontWeight.bold),
                            ),
                            _buildTextFormField(
                              _nameController,
                              "Nume Pacient",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nume doctor*",
                              style: TextStyle(color: Color.fromRGBO(65, 64, 64, 1), fontWeight: FontWeight.bold),
                            ),
                            _buildTextFormField(
                              _doctorNameController,
                              "Nume doctor",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Data observatiei*",
                              style: TextStyle(color: Color.fromRGBO(65, 64, 64, 1), fontWeight: FontWeight.bold),
                            ),
                            _buildTextFormField(
                              _dateController,
                              "Data observatiei",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ora observatiei*",
                              style: TextStyle(color: Color.fromRGBO(65, 64, 64, 1), fontWeight: FontWeight.bold),
                            ),
                            _buildTextFormField(
                              _timeController,
                              "Ora observatiei",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Diagnostic detectat*",
                              style: TextStyle(color: Color.fromRGBO(65, 64, 64, 1), fontWeight: FontWeight.bold),
                            ),
                            _buildTextFormField(
                              _detectDiagnosisController,
                              "Diagnostic detectat",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Diagnostic hotarat*",
                              style: TextStyle(color: Color.fromRGBO(65, 64, 64, 1), fontWeight: FontWeight.bold),
                            ),
                            _buildTextFormField(
                              _finalDiagnosisController,
                              "Diagnostic hotarat",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Date detectate",
                              style: TextStyle(color: Color.fromRGBO(65, 64, 64, 1), fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 5,
                              controller: _detectedDateController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color.fromRGBO(203, 203, 201, 1),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(141, 23, 34, 1)),
                                ),
                              ),
                              cursorColor: const Color.fromRGBO(65, 64, 64, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Observatiile medicului",
                              style: TextStyle(color: Color.fromRGBO(65, 64, 64, 1), fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 5,
                              controller: _doctorObservationController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color.fromRGBO(203, 203, 201, 1),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(141, 23, 34, 1)),
                                ),
                              ),
                              cursorColor: const Color.fromRGBO(65, 64, 64, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _generateAndSavePDF();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Color.fromRGBO(65, 64, 64, 1)),
                        foregroundColor: const Color.fromRGBO(203, 203, 201, 1),
                        backgroundColor: const Color.fromRGBO(255, 252, 243, 1),
                        padding: const EdgeInsets.all(16.0),
                        fixedSize: const Size(280, 40),
                      ),
                      child: const Text(
                        'SALVEAZA RAPORT',
                        style: TextStyle(fontSize: 16.0, color: Color.fromRGBO(65, 64, 64, 1)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _resetForm();
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Color.fromRGBO(65, 64, 64, 1)),
                        foregroundColor: const Color.fromRGBO(203, 203, 201, 1),
                        backgroundColor: const Color.fromRGBO(255, 252, 243, 1),
                        padding: const EdgeInsets.all(16.0),
                        fixedSize: const Size(280, 40),
                      ),
                      child: const Text(
                        'ANULEAZA RAPORT',
                        style: TextStyle(fontSize: 16.0, color: Color.fromRGBO(65, 64, 64, 1)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}