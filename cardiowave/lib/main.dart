// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:cardiowave/screens/drag_file_screeen.dart';
import 'package:cardiowave/screens/form_page.dart';
import 'package:cardiowave/screens/loading_page.dart';
import 'package:cardiowave/screens/result_screen.dart';
import 'package:cardiowave/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      home: SplashScreen(),
    );
  }

}