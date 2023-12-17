import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  File? file;
  static final _log = Logger();
  static String _inputFolderPath = "";
  static String _outputFolderPath = "";
  Timer? _timer;
  int _start = 30;

  String getInputFolderPath() {
    return _inputFolderPath;
  }

  String getOutputFolderPath() {
    return _outputFolderPath;
  }

  File? getFile() {
    return file;
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

  Future<void> saveInputImage(File inputFile) async {
    _log.d('Entered input image saving.');
    final fileName = 'cardiowave_input.jpg';
    final newFilePathToBeSaved =
        await File('${_inputFolderPath}/$fileName').create();
    await inputFile.copy(newFilePathToBeSaved.path);
    _log.i('Successfully saved input image.');
  }

  Future<void> retrieveImage() async {
    final imagePath =
        '${_outputFolderPath}\\cardiowave_output.jpg';
    final imageFile = File(imagePath);

    if (await imageFile.existsSync()) {
        _log.d('found it....${imageFile.path}');
        file = imageFile;
        _timer?.cancel();
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (_start == 0) {
          timer.cancel();
        } else {
          await retrieveImage();
          _log.d(_start);
          _start--;
        }
      },
    );
    _log.d('finished timer');
  }
}
