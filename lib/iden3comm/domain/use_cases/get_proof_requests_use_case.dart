import 'package:polygonid_flutter_sdk/common/domain/use_case.dart';
import 'package:polygonid_flutter_sdk/common/infrastructure/stacktrace_stream_manager.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/request/proof_request_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/request/proof_scope_request.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/exceptions/iden3comm_exceptions.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/get_proof_query_context_use_case.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/use_cases/get_proof_query_use_case.dart';

class GetProofRequestsUseCase
    extends FutureUseCase<Iden3MessageEntity, List<ProofRequestEntity>> {
  final GetProofQueryContextUseCase _getProofQueryContextUseCase;
  final GetProofQueryUseCase _getProofQueryUseCase;
  final StacktraceManager _stacktraceManager;

  GetProofRequestsUseCase(
    this._getProofQueryContextUseCase,
    this._getProofQueryUseCase,
    this._stacktraceManager,
  );

  @override
  Future<List<ProofRequestEntity>> execute(
      {required Iden3MessageEntity param}) async {
    List<ProofRequestEntity> proofRequests = [];

    if (![
      Iden3MessageType.authRequest,
      Iden3MessageType.proofContractInvokeRequest
    ].contains(param.messageType)) {
      _stacktraceManager.addTrace(
          "[GetProofRequestsUseCase] Error: Unsupported message type: ${param.messageType}");
      return Future.error(UnsupportedIden3MsgTypeException(param.messageType));
    }
    print("<getProofs trace> GetProofRequestsUseCase execute");
    var index = 0;
    if (param.body.scope != null && param.body.scope!.isNotEmpty) {
      List<Future<ProofRequestEntity> Function()> closures = [];
      for (ProofScopeRequest scope in param.body.scope!) {
        closures.add(() async {
          print(
              "<getProofs trace> GetProofRequestsUseCase closure $index begin");
          var context =
              await _getProofQueryContextUseCase.execute(param: scope);
          print(
              "<getProofs trace> GetProofRequestsUseCase closure $index _getProofQueryContextUseCase end");
          _stacktraceManager.addTrace(
              "[GetProofRequestsUseCase] _getProofQueryContextUseCase: $context");
          ProofQueryParamEntity query =
              await _getProofQueryUseCase.execute(param: scope);
          _stacktraceManager.addTrace(
              "[GetProofRequestsUseCase] _getProofQueryUseCase: $query");
          print("<getProofs trace> GetProofRequestsUseCase closure $index end");
          return ProofRequestEntity(scope, context, query);
        });

        index += 1;
      }

      print(
          "<getProofs trace> GetProofRequestsUseCase before wait closures.count: ${closures.length}");
      List<ProofRequestEntity> results =
          await Future.wait(closures.map((closure) => closure()));
      proofRequests.addAll(results);
      print(
          "<getProofs trace> GetProofRequestsUseCase after wait closures.count: ${closures.length}");
    }

    return Future.value(proofRequests);
  }
}
