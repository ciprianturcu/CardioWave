import 'package:flutter/material.dart';

class PdfViewerPage extends StatelessWidget {
  final String pdfImagePath = "assets/images/loading_page.png";

  const PdfViewerPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 252, 243, 1),
      body: Center(
        child: Image.asset(
          pdfImagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,), 
      ),
    );
  }
}