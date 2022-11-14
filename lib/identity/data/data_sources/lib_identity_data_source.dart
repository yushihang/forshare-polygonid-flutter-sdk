import 'package:fast_base58/fast_base58.dart';
import 'package:flutter/foundation.dart';
import 'package:polygonid_flutter_sdk/proof_generation/domain/exceptions/proof_generation_exceptions.dart';

import '../../../common/utils/hex_utils.dart';
import '../../libs/iden3core/iden3core.dart';

class LibIdentityDataSource {
  final Iden3CoreLib _iden3coreLib;

  LibIdentityDataSource(
    this._iden3coreLib,
  );

  Future<String> getId(String id) {
    return Future.value(_iden3coreLib.getIdFromString(id)).then((libId) {
      if (libId.isEmpty) {
        throw GenerateNonRevProofException(id);
      }

      return libId;
    });
  }

  ///
  Future<String> getIdentifier({required String pubX, required String pubY}) {
    try {
      Map<String, String> map = _iden3coreLib.generateIdentity(pubX, pubY);
      Uint8List hex = HexUtils.hexToBytes(map['id']!);

      return Future.value(Base58Encode(hex));
    } catch (e) {
      return Future.error(e);
    }
  }

  ///
  Future<String> getAuthClaim({required String pubX, required String pubY}) {
    try {
      String authClaim = _iden3coreLib.getAuthClaim(pubX, pubY);

      return Future.value(authClaim);
    } catch (e) {
      return Future.error(e);
    }
  }

  /// FIXME: no passing repo and lib as params
  // Future<String> createSMT(SMTStorageRepository smtStorageRepository) {
  //   try {
  //     return Future.value((MerkleTree(_iden3coreLib, smtStorageRepository, 32)
  //             .storage as SMTMemoryStorageRepositoryImpl)
  //         .toJson()
  //         .toString());
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }
}
