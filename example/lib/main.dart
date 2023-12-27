import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_flutter_proxy/custom_proxy.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';
import 'package:polygonid_flutter_sdk/identity/data/data_sources/lib_babyjubjub_data_source.dart';
import 'package:polygonid_flutter_sdk/identity/libs/bjj/bjj.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/app.dart';
import 'package:polygonid_flutter_sdk_example/src/presentation/dependency_injection/dependencies_provider.dart'
    as di;

Future<void> main() async {
  //Dependency Injection initialization
  WidgetsFlutterBinding.ensureInitialized();
  bool enabled = false;
  String? host;
  int? port;
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

  final bjj = LibBabyJubJubDataSource(BabyjubjubLib());
  final result = await bjj.hashPoseidon("1");
  await di.init();
  PolygonIdSdk.I.switchLog(enabled: true);

  // App UI locked in portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const App());
}
