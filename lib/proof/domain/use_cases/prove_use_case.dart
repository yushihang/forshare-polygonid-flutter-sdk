import 'dart:typed_data';

import 'package:polygonid_flutter_sdk/common/domain/domain_logger.dart';
import 'package:polygonid_flutter_sdk/common/domain/use_case.dart';
import 'package:polygonid_flutter_sdk/common/infrastructure/stacktrace_stream_manager.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/circuit_data_entity.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/zkproof_entity.dart';
import 'package:polygonid_flutter_sdk/proof/domain/repositories/proof_repository.dart';

class ProveParam {
  final Uint8List inputs;
  final CircuitDataEntity circuitData;

  ProveParam(this.inputs, this.circuitData);
}

class ProveUseCase extends FutureUseCase<ProveParam, ZKProofEntity> {
  final ProofRepository _proofRepository;
  final StacktraceManager _stacktraceManager;

  ProveUseCase(
    this._proofRepository,
    this._stacktraceManager,
  );

  @override
  Future<ZKProofEntity> execute({required ProveParam param}) async {
    try {
      // Calculate witness
      logger().i("[ProveUseCase] proof: before Calculate witness");
      print("<getProofs trace> before Calculate witness");
      Uint8List wtnsBytes = await _proofRepository.calculateWitness(
        param.circuitData,
        param.inputs,
      );

      logger().i("[ProveUseCase] proof: before prove");
      print("<getProofs trace> before prove");

      var time = DateTime.now().millisecondsSinceEpoch;

      // Generate proof
      ZKProofEntity zkProofEntity = await _proofRepository.prove(
        param.circuitData,
        wtnsBytes,
      );

      var duration = DateTime.now().millisecondsSinceEpoch - time;

      _stacktraceManager.addTrace("[ProveUseCase] proof");
      logger().i("[ProveUseCase] proof: $zkProofEntity");

      print("<getProofs trace> after prove");

      print("<getProofs trace> prove cost: $duration ms");

      return zkProofEntity;
    } catch (error) {
      _stacktraceManager.addTrace("[ProveUseCase] Error: $error");
      _stacktraceManager.addError("[ProveUseCase] Error: $error");
      logger().e("[ProveUseCase] Error: $error");
      rethrow;
    }
  }
}
