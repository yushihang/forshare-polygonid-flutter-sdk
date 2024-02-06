import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:native_flutter_proxy/custom_proxy.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/proof/data/data_sources/circuits_download_data_source.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_wrapper/filelogger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
}

bool _ohIsForProduct = false;

/// Initialize the Flutter SDK wrapper
/// This method is called from the native side
@pragma('vm:entry-point')
Future<void> init(List? env) async {
  runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      print('Polygon flutter(dart) framework init');

      if (!_ohIsForProduct) {
        await FileLogger.initializeLogger();
      }

      bool enabled = false;
      String? host;
      int? port;
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        if (!iosInfo.isPhysicalDevice) {
          try {
            ProxySetting settings = await NativeProxyReader.proxySetting;
            enabled = settings.enabled;
            host = settings.host;
            port = settings.port;
          } catch (e) {
            print(e);
          }
          if (enabled && host != null) {
            final proxy = CustomProxy(ipAddress: host, port: port);
            proxy.enable();
            print("proxy enabled: $host:$port");
          }
        }
      }

      if (env != null && env.isNotEmpty) {
        var json = jsonDecode(env[0]);
        if (json.containsKey('circuitsBucketUrl')) {
          var circuitsBucketUrl = json['circuitsBucketUrl'];
          if (circuitsBucketUrl != null &&
              circuitsBucketUrl is String &&
              circuitsBucketUrl.isNotEmpty) {
            OHGlobalVariables.circuitsBucketUrl = circuitsBucketUrl;
            print('circuitsBucketUrl: $circuitsBucketUrl');
          }
        }

        if (json.containsKey('circuitsFileLen')) {
          var circuitsFileLen = json['circuitsFileLen'];
          if (circuitsFileLen != null && circuitsFileLen is num) {
            OHGlobalVariables.circuitsFileLen = circuitsFileLen.toInt();
            print('circuitsFileLen: $circuitsFileLen');
          }
        }

        if (json.containsKey('circuitsFileSHA256')) {
          var circuitsFileSHA256 = json['circuitsFileSHA256'];
          if (circuitsFileSHA256 != null &&
              circuitsFileSHA256 is String &&
              circuitsFileSHA256.isNotEmpty) {
            OHGlobalVariables.circuitsFileSHA256 = circuitsFileSHA256;
            print('circuitsFileSHA256: $circuitsFileSHA256');
          }
        }
      }
      PolygonIdSdk.init(
          env: env != null && env.isNotEmpty
              ? EnvEntity.fromJson(jsonDecode(env[0]))
              : null);
    },
    zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      if (_ohIsForProduct) return;
      //var forTrace = line.startsWith("<getProofs trace>") && line.contains("cost");

      var newLine = LogHelper.getLogString(line);
      parent.print(zone, newLine);
      /*
      if (forTrace && Platform.isIOS) {
        FileLogger.log(newLine);
      }
      */
    }),
  );
}
