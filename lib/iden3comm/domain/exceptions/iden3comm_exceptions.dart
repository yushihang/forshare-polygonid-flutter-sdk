import 'package:polygonid_flutter_sdk/common/domain/error_exception.dart';
import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/authorization/request/auth_request_iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/iden3_message_entity.dart';
import 'package:polygonid_flutter_sdk/iden3comm/domain/entities/common/request/proof_request_entity.dart';

class UnsupportedIden3MsgTypeException extends PolygonIdException {
  final Iden3MessageType type;

  UnsupportedIden3MsgTypeException(this.type);

  @override
  String exceptionInfo() {
    return "type: $type";
  }
}

class InvalidIden3MsgTypeException extends PolygonIdException {
  final Iden3MessageType expected;
  final Iden3MessageType actual;

  InvalidIden3MsgTypeException(this.expected, this.actual);

  @override
  String exceptionInfo() {
    return "expected: $expected, actual: $actual";
  }
}

class InvalidProofReqException extends PolygonIdException {
  final String message;

  InvalidProofReqException(this.message);

  @override
  String exceptionInfo() {
    return "message: $message";
  }
}

class ProofsNotFoundException extends PolygonIdException {
  final List<ProofRequestEntity> proofRequests;

  ProofsNotFoundException(this.proofRequests);

  @override
  String exceptionInfo() {
    return "proofRequests:\n${proofRequests.join("\n")}";
  }
}

class CredentialsNotFoundException extends PolygonIdException {
  final List<ProofRequestEntity> proofRequests;

  CredentialsNotFoundException(this.proofRequests);
  @override
  String exceptionInfo() {
    return "proofRequests:\n${proofRequests.join("\n")}";
  }
}

class UnsupportedSchemaException extends PolygonIdException {}

class NullAuthenticateCallbackException extends PolygonIdException {
  final AuthIden3MessageEntity authRequest;

  NullAuthenticateCallbackException(this.authRequest);

  @override
  String exceptionInfo() {
    return "authRequest: $authRequest";
  }
}

class FetchClaimException extends ErrorException {
  FetchClaimException(error) : super(error);
}

class FetchSchemaException extends ErrorException {
  FetchSchemaException(error) : super(error);
}

class UnsupportedFetchClaimTypeException extends ErrorException {
  UnsupportedFetchClaimTypeException(error) : super(error);
}

class GetConnectionsException extends ErrorException {
  GetConnectionsException(error) : super(error);
}
