import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static final _log = Logger();
  static String _inputFolderPath = "";
  static String _outputFolderPath = "";

  String getInputFolderPath() {
    return _inputFolderPath;
  }

  String getOutputFolderPath() {
    return _outputFolderPath;
  }

  Future<void> createOutputFolder() async {
    _log.d('Entered output location creation.');
    final directory = await getTemporaryDirectory();
    final _outputFolder =
        await Directory('${directory.path}\\cardiowave\\output')
            .create(recursive: true);
    _outputFolderPath = _outputFolder.path;
    _log.i('Succesfully created output folder');
  }

  Future<void> createInputFolder() async {
    _log.d('Entered input location creation.');
    final directory = await getTemporaryDirectory();
    final inputFolder = await Directory('${directory.path}\\cardiowave\\input')
        .create(recursive: true);
    _inputFolderPath = inputFolder.path;
    _log.i('Succesfully created input folder');
  }
  
  Future<void> startClearOfFiles() async {
    final directory = await getTemporaryDirectory();
    await clearIOFiles("${directory.path}\\cardiowave");
  }

  Future<void> clearIOFiles(String path) async {
    _log.d('Entered clear of input/output temporary locations.');
    final Directory directory = Directory(path);
    if (await directory.exists()) {
      final List<FileSystemEntity> files = directory.listSync();
      for (FileSystemEntity fileEntity in files) {
        if (fileEntity is Directory) {
          await clearIOFiles(fileEntity.path);
        } else if (fileEntity is File && fileEntity.path.endsWith('.jpg')) {
          await fileEntity.delete();
          _log.i('File successfuly deleted.');
        }
      }
    }
  }

  Future<void> saveInputImage(File inputFile, int index) async {
    _log.d('Entered input image saving.');
    final fileName = 'cardiowave_input_$index.jpg';
    final newFilePathToBeSaved =
        await File('${_inputFolderPath}/$fileName').create();
    await inputFile.copy(newFilePathToBeSaved.path);
    _log.i('Successfully saved input image.');
  }

  Future<List<File>> retrieveImages() async {
    final directory = Directory(_outputFolderPath);
    final files = await directory.list().toList();

    List<File> matchingFiles = [];

    for (var entity in files) {
      //print(entity);
      if (entity is File && entity.path.endsWith('.jpg')) {
        //print("is File and ends with jpg");
        String filename = entity.path.split('\\').last;
        if (filename.startsWith('cardiowave_output_')) {
          matchingFiles.add(entity);
        }
      }
    }
    //print(matchingFiles.length);
    return matchingFiles;
  }
}
