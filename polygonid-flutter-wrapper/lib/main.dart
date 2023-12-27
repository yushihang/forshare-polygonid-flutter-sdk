import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:polygonid_flutter_sdk/common/domain/entities/env_entity.dart';
import 'package:polygonid_flutter_sdk/proof/data/data_sources/circuits_download_data_source.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
}

/// Initialize the Flutter SDK wrapper
/// This method is called from the native side
@pragma('vm:entry-point')
Future<void> init(List? env) {
  WidgetsFlutterBinding.ensureInitialized();

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

  return PolygonIdSdk.init(
      env: env != null && env.isNotEmpty
          ? EnvEntity.fromJson(jsonDecode(env[0]))
          : null);
}
