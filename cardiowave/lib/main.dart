// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:cardiowave/screens/drag_file_screeen.dart';
import 'package:cardiowave/screens/form_page.dart';
import 'package:cardiowave/screens/loading_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Flutter App',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 1),
      () => Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const FormPage(),
          MaterialPageRoute(
            builder: (_) => DragFileScreen(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PdfViewerPage(),
    );
  }
}

