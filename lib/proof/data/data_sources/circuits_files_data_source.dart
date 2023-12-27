import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:polygonid_flutter_sdk/proof/data/data_sources/circuits_download_data_source.dart';
import 'package:polygonid_flutter_sdk/sdk/di/injector.dart';

class CircuitsFilesDataSource {
  final Directory directory;

  CircuitsFilesDataSource(this.directory);

  Future<List<Uint8List>> loadCircuitFiles(String circuitId) async {
    String path = directory.path;

    var circuitDatFileName = '$circuitId.dat';
    var circuitDatFilePath = '$path/$circuitDatFileName';
    var circuitDatFile = File(circuitDatFilePath);

    var circuitZkeyFileName = '$circuitId.zkey';
    var circuitZkeyFilePath = '$path/$circuitZkeyFileName';
    var circuitZkeyFile = File(circuitZkeyFilePath);

    return [
      circuitDatFile.readAsBytesSync(),
      circuitZkeyFile.readAsBytesSync()
    ];
  }

/*
  ///
  Future<bool> circuitsFilesExist() {
    String fileName = 'circuits.zip';
    String path = directory.path;
    var file = File('$path/$fileName');
  
    return file.exists();
  }
*/

  String calculateSHA256(Uint8List bytes) {
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> circuitsFilesExist() async {
    String fileName = 'circuits.zip';
    String path = directory.path;
    var file = File('$path/$fileName');

    if (await file.exists()) {
      // 获取文件长度
      int fileLength = await file.length();

      // 读取文件内容并计算SHA-256哈希值
      Uint8List fileContent = await file.readAsBytes();
      String sha256 = calculateSHA256(fileContent);

      // 比较文件长度和SHA-256值是否符合预期
      if (fileLength == OHGlobalVariables.circuitsFileLen &&
          sha256 == OHGlobalVariables.circuitsFileSHA256) {
        print('${file.absolute.path} File length matched.');
        print('${file.absolute.path} File SHA-256 matched.');
        return true;
      } else {
        print(
            '${file.absolute.path} Maybe File length mismatch. Expected: $OHGlobalVariables.circuitsFileLen, Actual: $fileLength');
        print(
            '${file.absolute.path} Maybe SHA-256 mismatch. Expected: $OHGlobalVariables.circuitsFileSHA256, Actual: $sha256');

        try {
          await file.delete();
        } catch (e) {
          print(e);
        }

        print('File deleted.');
      }
    }

    return false;
  }

  Future<String> getPathToCircuitZipFile() async {
    String path = directory.path;
    String fileName = 'circuits.zip';

    return '$path/$fileName';
  }

  Future<String> getPathToCircuitZipFileTemp() async {
    String path = directory.path;
    String fileName = 'circuits_temp.zip';

    return '$path/$fileName';
  }

  Future<String> getPath() async {
    return Future.value(directory.path);
  }

  Future<void> deleteFile(String pathToFile) async {
    try {
      var file = File(pathToFile);
      await file.delete();
    } catch (_) {
      // file not found? no problem, we don't need it
    }
  }

  void renameFile(String pathTofile, String newPathToFile) {
    var file = File(pathTofile);
    file.renameSync(newPathToFile);
  }

  void writeZipFile({
    required String pathToFile,
    required List<int> zipBytes,
  }) {
    var file = File(pathToFile);
    file.writeAsBytesSync(
      zipBytes,
      mode: FileMode.append,
    );
  }

  int zipFileSize({required String pathToFile}) {
    var file = File(pathToFile);
    return file.lengthSync();
  }

  Future<void> writeCircuitsFileFromZip({
    required String path,
    required String zipPath,
  }) async {
    var zipFile = File(zipPath);
    Uint8List zipBytes = zipFile.readAsBytesSync();
    final zipDecoder = getItSdk.get<ZipDecoder>();
    var archive = zipDecoder.decodeBytes(zipBytes);

    for (var file in archive) {
      var filename = '$path/${file.name}';
      if (file.isFile) {
        var outFile = File(filename);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
  }
}
