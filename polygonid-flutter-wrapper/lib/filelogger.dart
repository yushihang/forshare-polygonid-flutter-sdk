import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class FileLogger {
  static late File _logFile;

  static Future<void> initializeLogger() async {
    String fileName = 'log.txt';
    Directory appDocDir = await getApplicationDocumentsDirectory();
    _logFile = File('${appDocDir.path}/$fileName');
  }

  static Future<void> logDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _writeToLog('Device Model: ${androidInfo.model}');
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _writeToLog('Device Model: ${iosInfo.model}');
      }
    } catch (e) {
      _writeToLog('Error getting device info: $e');
    }
  }

  static Future<void> log(String message) async {
    String logMessage = '$message\n';
    //print(logMessage); // Print to console as well
    await _writeToLog(logMessage);
  }

  static Future<void> _writeToLog(String logMessage) async {
    try {
      if (!await _logFile.exists()) {
        await _logFile.create();
      }
      IOSink sink = _logFile.openWrite(mode: FileMode.append);
      sink.writeln(logMessage);
      await sink.flush();
      await sink.close();
    } catch (e) {
      //print('Error writing to log file: $e');
    }
  }
}
