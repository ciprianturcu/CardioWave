import 'dart:io';

import 'package:process_run/process_run.dart';

class AIScript {
  Future<List<String>> runAlgorithm(
      String inputFolderPath, String outputFolderPath) async {
    List<ProcessResult> result_combined = await run('''
    python lib\\backend\\script\\main.py ${inputFolderPath} ${outputFolderPath}''');
    return transformSTDOUTToList(result_combined.first.stdout);
  }

  List<String> transformSTDOUTToList(String multiLineString) {
    List<String> lines = multiLineString.split('\n');
    lines.removeWhere((line) => line.isEmpty);
    return lines;
  }
}
