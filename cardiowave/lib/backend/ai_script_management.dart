import 'dart:io';

import 'package:process_run/process_run.dart';

class AIScript {
  Future<String> runAlgorithm(
      String inputFolderPath, String outputFolderPath) async {
    List<ProcessResult> result_combined = await run('''
    python lib\\backend\\script\\main.py ${inputFolderPath} ${outputFolderPath}''');
    return result_combined.first.stdout;
  }
}
