import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';
import 'package:polygonid_flutter_sdk/credential/domain/entities/claim_entity.dart';

import '../../../common/domain/error_exception.dart';

class ClaimNotFoundException extends PolygonIdException {
  final String id;

  ClaimNotFoundException(this.id);

  @override
  String exceptionInfo() {
    return "id: $id";
  }
}

class ClaimWrongIdentityException extends PolygonIdException {
  final String identifier;

  ClaimWrongIdentityException(this.identifier);

  @override
  String exceptionInfo() {
    return "identifier: $identifier";
  }
}

class SaveClaimException extends ErrorException {
  SaveClaimException(error) : super(error);
}

class GetClaimsException extends ErrorException {
  GetClaimsException(error) : super(error);
}

class RemoveClaimsException extends ErrorException {
  RemoveClaimsException(error) : super(error);
}

class UpdateClaimException extends ErrorException {
  UpdateClaimException(error) : super(error);
}

class NullRevocationStatusException extends PolygonIdException {
  final ClaimEntity claim;

  NullRevocationStatusException(this.claim);

  @override
  String exceptionInfo() {
    return "claim: $claim";
  }
}
