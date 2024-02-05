import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileLogger {
  static Directory _performanceDir = Directory("");
  static Future<File> createRandomFile() async {
    // Generate a unique identifier using uuid
    String uuid = const Uuid().v4();

    // Get the current time in milliseconds
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

    // Construct the file path with the unique identifier and current time
    String filePath =
        '${_performanceDir.path}/random_file_${uuid}_$currentTimeMillis.txt';

    // Create the file
    File file = File(filePath);
    await file.create();

    print('Random file created: $filePath');
    return file;
  }

  static Future<void> handlePerformanceDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String performanceDirPath = '${appDocDir.path}/performance';
    _performanceDir = Directory(performanceDirPath);

    // 检查 performance 目录是否存在
    if (await _performanceDir.exists()) {
      // 如果存在，删除整个目录（包括文件）
      await _performanceDir.delete(recursive: true);
    }

    // 创建新的 performance 目录
    await _performanceDir.create();
    return;
  }

  static Future<void> initializeLogger() async {
    await handlePerformanceDirectory();
  }

  static Future<void> log(String message) async {
    String logMessage = message.replaceAll('\n', '<br>');
    //print(logMessage); // Print to console as well
    await _writeToLog("$logMessage\n");
  }

  static Future<void> _writeToLog(String logMessage) async {
    try {
      var file = await createRandomFile();
      IOSink sink = file.openWrite(mode: FileMode.write);

      // Write the content to the file
      sink.write(logMessage);

      // Close the sink to ensure that all content is written to the file
      await sink.close();
    } catch (e) {
      //print('Error writing to log file: $e');
    }
  }
}
