import 'dart:ffi' as ffi;
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:injectable/injectable.dart';
import 'package:polygonid_flutter_sdk/proof/domain/exceptions/proof_generation_exceptions.dart';
import 'package:polygonid_flutter_sdk/sdk/polygon_id_sdk.dart';

import '../../../common/libs/polygonidcore/native_polygonidcore.dart';
import '../../../common/libs/polygonidcore/pidcore_base.dart';

@injectable
class PolygonIdCoreProof extends PolygonIdCore {
  String proofFromSmartContract(String input) {
    ffi.Pointer<ffi.Char> in1 = input.toNativeUtf8().cast<ffi.Char>();
    ffi.Pointer<ffi.Pointer<ffi.Char>> response =
        malloc<ffi.Pointer<ffi.Char>>();
    ffi.Pointer<ffi.Pointer<PLGNStatus>> status =
        malloc<ffi.Pointer<PLGNStatus>>();

    freeAllocatedMemory() {
      malloc.free(response);
      malloc.free(status);
      print("ffi memory freed");
    }

    int res = PolygonIdCore.nativePolygonIdCoreLib
        .PLGNProofFromSmartContract(response, in1, status);
    if (res == 0) {
      String? consumedStatus = consumeStatus(status, "");
      if (consumedStatus != null) {
        freeAllocatedMemory();
        throw ProofInputsException(consumedStatus);
      }
    }
    String result = "";
    ffi.Pointer<ffi.Char> jsonResponse = response.value;
    ffi.Pointer<Utf8> jsonString = jsonResponse.cast<Utf8>();
    if (jsonString != ffi.nullptr) {
      result = jsonString.toDartString();
    }

    PolygonIdCore.nativePolygonIdCoreLib.PLGNFreeCString(jsonResponse);
    print("jsonResponse freed");

    freeAllocatedMemory();
    return result;
  }

  String getSigProofInputs(String input, String? config) {
    ffi.Pointer<ffi.Char> in1 = input.toNativeUtf8().cast<ffi.Char>();
    ffi.Pointer<ffi.Char> cfg = ffi.nullptr;
    if (config != null) {
      cfg = config.toNativeUtf8().cast<ffi.Char>();
    }
    ffi.Pointer<ffi.Pointer<ffi.Char>> response =
        malloc<ffi.Pointer<ffi.Char>>();
    ffi.Pointer<ffi.Pointer<PLGNStatus>> status =
        malloc<ffi.Pointer<PLGNStatus>>();

    freeAllocatedMemory() {
      malloc.free(response);
      malloc.free(status);
      print("ffi memory freed");
    }

    int res = PolygonIdCore.nativePolygonIdCoreLib
        .PLGNAtomicQuerySigV2Inputs(response, in1, cfg, status);
    if (res == 0) {
      String? consumedStatus = consumeStatus(status, "");
      if (consumedStatus != null) {
        freeAllocatedMemory();
        throw ProofInputsException(consumedStatus);
      }
    }
    String result = "";
    ffi.Pointer<ffi.Char> jsonResponse = response.value;
    ffi.Pointer<Utf8> jsonString = jsonResponse.cast<Utf8>();
    if (jsonString != ffi.nullptr) {
      result = jsonString.toDartString();
    }

    PolygonIdCore.nativePolygonIdCoreLib.PLGNFreeCString(jsonResponse);
    print("jsonResponse freed");

    freeAllocatedMemory();

    return result;
  }

  String getSigOnchainProofInputs(String input, String? config) {
    ffi.Pointer<ffi.Char> in1 = input.toNativeUtf8().cast<ffi.Char>();
    ffi.Pointer<ffi.Char> cfg = ffi.nullptr;
    if (config != null) {
      cfg = config.toNativeUtf8().cast<ffi.Char>();
    }
    ffi.Pointer<ffi.Pointer<ffi.Char>> response =
        malloc<ffi.Pointer<ffi.Char>>();
    ffi.Pointer<ffi.Pointer<PLGNStatus>> status =
        malloc<ffi.Pointer<PLGNStatus>>();

    freeAllocatedMemory() {
      malloc.free(response);
      malloc.free(status);
      print("ffi memory freed");
    }

    int res = PolygonIdCore.nativePolygonIdCoreLib
        .PLGNAtomicQuerySigV2OnChainInputs(response, in1, cfg, status);
    if (res == 0) {
      String? consumedStatus = consumeStatus(status, "");
      if (consumedStatus != null) {
        freeAllocatedMemory();
        throw ProofInputsException(consumedStatus);
      }
    }
    String result = "";
    ffi.Pointer<ffi.Char> jsonResponse = response.value;
    ffi.Pointer<Utf8> jsonString = jsonResponse.cast<Utf8>();
    if (jsonString != ffi.nullptr) {
      result = jsonString.toDartString();
    }

    PolygonIdCore.nativePolygonIdCoreLib.PLGNFreeCString(jsonResponse);
    print("jsonResponse freed");

    freeAllocatedMemory();
    return result;
  }

  String getMTProofInputs(String input, String? config) {
    ffi.Pointer<ffi.Char> in1 = input.toNativeUtf8().cast<ffi.Char>();
    ffi.Pointer<ffi.Char> cfg = ffi.nullptr;
    if (config != null) {
      cfg = config.toNativeUtf8().cast<ffi.Char>();
    }
    ffi.Pointer<ffi.Pointer<ffi.Char>> response =
        malloc<ffi.Pointer<ffi.Char>>();
    ffi.Pointer<ffi.Pointer<PLGNStatus>> status =
        malloc<ffi.Pointer<PLGNStatus>>();

    freeAllocatedMemory() {
      malloc.free(response);
      malloc.free(status);
      print("ffi memory freed");
    }

    var line = LogHelper.getLogString(
        "<getProofs trace> before PLGNAtomicQueryMtpV2Inputs-");
    print(line);
    int res = PolygonIdCore.nativePolygonIdCoreLib
        .PLGNAtomicQueryMtpV2Inputs(response, in1, cfg, status);

    line = LogHelper.getLogString(
        "<getProofs trace> after PLGNAtomicQueryMtpV2Inputs-");
    print(line);
    if (res == 0) {
      print("<getProofs trace> before consumeStatus");
      String? consumedStatus = consumeStatus(status, "");
      print("<getProofs trace> after consumeStatus");
      if (consumedStatus != null) {
        freeAllocatedMemory();
        throw ProofInputsException(consumedStatus);
      }
    }
    String result = "";
    ffi.Pointer<ffi.Char> jsonResponse = response.value;
    ffi.Pointer<Utf8> jsonString = jsonResponse.cast<Utf8>();
    if (jsonString != ffi.nullptr) {
      result = jsonString.toDartString();
    }

    PolygonIdCore.nativePolygonIdCoreLib.PLGNFreeCString(jsonResponse);
    print("jsonResponse freed");

    freeAllocatedMemory();

    return result;
  }

  String getMTPOnchainProofInputs(String input, String? config) {
    ffi.Pointer<ffi.Char> in1 = input.toNativeUtf8().cast<ffi.Char>();
    ffi.Pointer<ffi.Char> cfg = ffi.nullptr;
    if (config != null) {
      cfg = config.toNativeUtf8().cast<ffi.Char>();
    }
    ffi.Pointer<ffi.Pointer<ffi.Char>> response =
        malloc<ffi.Pointer<ffi.Char>>();
    ffi.Pointer<ffi.Pointer<PLGNStatus>> status =
        malloc<ffi.Pointer<PLGNStatus>>();

    freeAllocatedMemory() {
      malloc.free(response);
      malloc.free(status);
      print("ffi memory freed");
    }

    int res = PolygonIdCore.nativePolygonIdCoreLib
        .PLGNAtomicQueryMtpV2OnChainInputs(response, in1, cfg, status);
    if (res == 0) {
      String? consumedStatus = consumeStatus(status, "");
      if (consumedStatus != null) {
        freeAllocatedMemory();
        throw ProofInputsException(consumedStatus);
      }
    }
    String result = "";
    ffi.Pointer<ffi.Char> jsonResponse = response.value;
    ffi.Pointer<Utf8> jsonString = jsonResponse.cast<Utf8>();
    if (jsonString != ffi.nullptr) {
      result = jsonString.toDartString();
    }

    PolygonIdCore.nativePolygonIdCoreLib.PLGNFreeCString(jsonResponse);
    print("jsonResponse freed");

    freeAllocatedMemory();

    return result;
  }
}
