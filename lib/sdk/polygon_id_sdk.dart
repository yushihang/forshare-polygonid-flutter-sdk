import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:polygonid_flutter_sdk/common/domain/domain_logger.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/common/domain/use_cases/get_env_use_case.dart';
import 'package:polygonid_flutter_sdk/common/domain/use_cases/set_env_use_case.dart';
import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';
import 'package:polygonid_flutter_sdk/sdk/di/injector.dart';
import 'package:polygonid_flutter_sdk/sdk/error_handling.dart';
import 'package:polygonid_flutter_sdk/sdk/polygonid_flutter_channel.dart';

import 'credential.dart';
import 'iden3comm.dart';
import 'identity.dart';
import 'proof.dart';

class LogHelper {
  static String _currentMethod = "";
  static int _millisecondsSinceEpochForCurrentMethod = 0;
  static int _millisecondsSinceEpochForLastPrint = 0;

  static void markCurrentMethod(String methodName) {
    _currentMethod = methodName;
    var now = DateTime.now();
    var millisecondsSinceEpoch = now.millisecondsSinceEpoch;
    _millisecondsSinceEpochForCurrentMethod = millisecondsSinceEpoch;
    _millisecondsSinceEpochForLastPrint = millisecondsSinceEpoch;
  }

  static String getLogString(String line) {
    DateTime now = DateTime.now();
    String formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${(now.microsecondsSinceEpoch % 1000000).toString().padLeft(6, '0')}";

    if (_currentMethod.isEmpty) {
      return "[$formattedTime]: $line";
    }
    var millisecondsSinceEpoch = now.millisecondsSinceEpoch;

    var millisecondsSinceMethodBegin =
        millisecondsSinceEpoch - _millisecondsSinceEpochForCurrentMethod;

    String durationSinceMethodBegin =
        _formatMilliseconds(millisecondsSinceMethodBegin);

    var millisecondsSinceLastPrint =
        millisecondsSinceEpoch - _millisecondsSinceEpochForLastPrint;

    String durationSinceLastPrint =
        _formatMilliseconds(millisecondsSinceLastPrint);

    _millisecondsSinceEpochForLastPrint = millisecondsSinceEpoch;

    String newLine =
        "[$formattedTime]: <$_currentMethod> ($durationSinceMethodBegin) ($durationSinceLastPrint) $line";
    return newLine;
  }

  static String _formatMilliseconds(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);

    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);
    int seconds = (duration.inSeconds % 60);
    int milliSeconds = (duration.inMilliseconds % 1000);

    String formattedTime =
        '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliSeconds.toString().padLeft(3, '0')}';

    return formattedTime;
  }
}

class PolygonIsSdkNotInitializedException extends PolygonIdException {
  String message;

  PolygonIsSdkNotInitializedException(this.message);

  @override
  String exceptionInfo() {
    return "message: $message";
  }
}

class PolygonIdSdk {
  static PolygonIdSdk? _ref;

  static PolygonIdSdk get I {
    if (_ref == null) {
      throw PolygonIsSdkNotInitializedException(
          "The PolygonID SDK has not been initialized,"
          "please call and await PolygonIdSDK.init()");
    }

    return _ref!;
  }

  static Future<void> init({EnvEntity? env}) async {
    // As [PolygonIdSdk] uses path_provider plugin, we need to ensure the
    // platform is initialized
    WidgetsFlutterBinding.ensureInitialized();

    String? stacktraceEncryptionKey = env?.stacktraceEncryptionKey;
    if (stacktraceEncryptionKey != null &&
        stacktraceEncryptionKey.isNotEmpty &&
        utf8.encode(stacktraceEncryptionKey).length == 32) {
      await Hive.initFlutter();
      await Hive.openBox(
        'stacktrace',
        encryptionCipher: HiveAesCipher(utf8.encode(stacktraceEncryptionKey)),
      );
    }

    // Init injection
    await configureInjection();
    await getItSdk.allReady();

    // Set env
    if (env != null) {
      await getItSdk
          .getAsync<SetEnvUseCase>()
          .then((instance) => instance.execute(param: env));
    }

    // SDK singleton
    _ref = PolygonIdSdk._();
    _ref!.identity = await getItSdk.getAsync<Identity>();
    _ref!.credential = await getItSdk.getAsync<Credential>();
    _ref!.proof = await getItSdk.getAsync<Proof>();
    _ref!.iden3comm = await getItSdk.getAsync<Iden3comm>();
    _ref!.errorHandling = getItSdk.get<ErrorHandling>();

    // Channel
    getItSdk<PolygonIdFlutterChannel>();

    // Logging
    Domain.logger = getItSdk<PolygonIdSdkLogger>();
  }

  late Identity identity;
  late Credential credential;
  late Proof proof;
  late Iden3comm iden3comm;
  late ErrorHandling errorHandling;

  PolygonIdSdk._();

  Future<void> setEnv({required EnvEntity env}) {
    return getItSdk
        .getAsync<SetEnvUseCase>()
        .then((instance) => instance.execute(param: env));
  }

  Future<EnvEntity> getEnv() {
    return getItSdk
        .getAsync<GetEnvUseCase>()
        .then((instance) => instance.execute());
  }

  Future<void> switchLog({required bool enabled}) async {
    print("method channel execute: switchLog: $enabled");
    Domain.logEnabled = enabled;
  }

  Future<void> changeLogLevel({required String level}) async {
    print("method channel execute: changeLogLevel: $level");
    var _level = level.toLowerCase();
    if (_level == "debug" || _level == "d") {
      Logger.level = Level.debug;
    } else if (_level == "verbose" || _level == "v" || _level == "trace") {
      Logger.level = Level.trace;
    } else if (_level == "warn" || _level == "w" || _level == "waring") {
      Logger.level = Level.warning;
    } else if (_level == "error" || _level == "e") {
      Logger.level = Level.error;
    } else if (_level == "info" || _level == "i") {
      Logger.level = Level.info;
    } else if (_level == "fatal") {
      Logger.level = Level.fatal;
    }
  }
}
