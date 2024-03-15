import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:polygonid_flutter_sdk/proof/data/dtos/download_response_dto.dart';

class CircuitFilesInfo {
  String fileName;
  int fileSize;
  String sha256;

  CircuitFilesInfo(this.fileName, this.fileSize, this.sha256);
}

class OHGlobalVariables {
  static String circuitsBucketUrl =
      "https://circuits.polygonid.me/circuits/v1.0.0/polygonid-keys.zip";

  static int circuitsFileLen = 148475322;

  static String circuitsFileSHA256 =
      "c68c8f271edf7628b0379b3175896f694f4cdae2edd86309377179d3d75b743a";

  static Map<String, CircuitFilesInfo> circuitFilesInfoMap = {
    "authV2.dat": CircuitFilesInfo("authV2.dat", 1395600,
        "260e842383e0f750a4cbaa63c414f3e704d2133b7b14944de6236be7bd25aff2"),
    "authV2.zkey": CircuitFilesInfo("authV2.zkey", 28795369,
        "6acb096a716f5f5b1e5505a7b7261c7eeb7f0a90597c5194fad7b14f91180ac1"),
    "credentialAtomicQueryMTPV2.dat": CircuitFilesInfo(
        "credentialAtomicQueryMTPV2.dat",
        1336232,
        "6183c225f8b9b72371c4cbed6a9c7e0610e931c8c606228c65a1df3a74c973de"),
    "credentialAtomicQueryMTPV2.zkey": CircuitFilesInfo(
        "credentialAtomicQueryMTPV2.dat",
        25352841,
        "7424499588e3e96b02763ae8cddf665df01f0829de6fe16227f2f586df01c3de"),
    "credentialAtomicQueryMTPV2OnChain.dat": CircuitFilesInfo(
        "credentialAtomicQueryMTPV2.dat",
        1749288,
        "52396687a54e13a7e9b62f2b0a0ec75cedfdbfd87958f3147986517746254d81"),
    "credentialAtomicQueryMTPV2OnChain.zkey": CircuitFilesInfo(
        "credentialAtomicQueryMTPV2OnChain.zkey",
        60075345,
        "b8778c2d45e16d274d05be84beeebd5b06e13efcf119e35edeaa79fac1f87702"),
    "credentialAtomicQuerySigV2.dat": CircuitFilesInfo(
        "credentialAtomicQuerySigV2.dat",
        1473256,
        "105af251d023967e6e2898d9f3c11757efbc20dee0935bc6804dca64b6ea3a7f"),
    "credentialAtomicQuerySigV2.zkey": CircuitFilesInfo(
        "credentialAtomicQuerySigV2.zkey",
        34465605,
        "a7dfd0a1e55d40992fe95ecc40b5201758cadde69f692ca3eea6ee059c07c1df"),
    "credentialAtomicQuerySigV2OnChain.dat": CircuitFilesInfo(
        "credentialAtomicQuerySigV2OnChain.dat",
        1884112,
        "0dabb0cf30d2c737a275f15a083a62bf54d49b27857a51442ddabe7db073b566"),
    "credentialAtomicQuerySigV2OnChain.zkey": CircuitFilesInfo(
        "credentialAtomicQuerySigV2OnChain.zkey",
        69188109,
        "e136ef02fd15ccf4c404833da21e6e32485142cb4dd25cd36af4b634c9b8ad4d"),
  };
}

@lazySingleton
class CircuitsDownloadDataSource {
  final Dio _client;
  late CancelToken _cancelToken;

  CircuitsDownloadDataSource(this._client);

  StreamController<DownloadResponseDTO> _controller =
      StreamController<DownloadResponseDTO>.broadcast();

  Stream<DownloadResponseDTO> get downloadStream => _controller.stream;

  int _downloadSize = 0;

  /// downloadSize
  int get downloadSize => _downloadSize;

  ///
  Future<void> initStreamedResponseFromServer(String downloadPath) async {
    _cancelToken = CancelToken();
    var bucketUrl = OHGlobalVariables.circuitsBucketUrl.isEmpty
        ? "https://circuits.polygonid.me/circuits/v1.0.0/polygonid-keys.zip"
        : OHGlobalVariables.circuitsBucketUrl;

    // first we get the file size
    try {
      Response headResponse = await _client.head(bucketUrl);
      int contentLength =
          int.parse(headResponse.headers.value('content-length') ?? "0");
      _downloadSize = contentLength;
    } catch (e) {
      _cancelToken.cancel();
      _controller.add(DownloadResponseDTO(
        progress: 0,
        total: 0,
        errorOccurred: true,
        errorMessage: e.toString(),
      ));
      return;
    }

    try {
      await _client.download(
        bucketUrl,
        downloadPath,
        deleteOnError: true,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total <= 0) {
            _cancelToken.cancel();
            _controller.add(DownloadResponseDTO(
              progress: 0,
              total: 0,
              errorOccurred: true,
              errorMessage: "Error occurred while downloading circuits",
            ));
            return;
          }
          _controller.add(
            DownloadResponseDTO(
              progress: received,
              total: total,
            ),
          );
        },
      );
    } catch (e) {
      _cancelToken.cancel();
      _controller.add(DownloadResponseDTO(
        progress: 0,
        total: 0,
        errorOccurred: true,
        errorMessage: e.toString(),
      ));
      return;
    }
    _controller.add(DownloadResponseDTO(
      progress: 100,
      total: 100,
      done: true,
    ));
    _controller.close();
  }

  ///
  void cancelDownload() {
    _cancelToken.cancel();
    _controller.add(DownloadResponseDTO(
      progress: 0,
      total: 0,
      errorOccurred: true,
      errorMessage: 'Download cancelled by user',
    ));
  }
}
