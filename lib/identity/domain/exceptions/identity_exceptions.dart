import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';

import '../../../../common/domain/error_exception.dart';

class IdentityException extends ErrorException {
  IdentityException(error) : super(error);
}

class TooLongPrivateKeyException extends PolygonIdException {}

class IdentityAlreadyExistsException extends PolygonIdException {
  final String did;

  IdentityAlreadyExistsException(this.did);
}

class ProfileAlreadyExistsException extends PolygonIdException {
  final String genesisDid;
  final BigInt profileNonce;

  ProfileAlreadyExistsException(this.genesisDid, this.profileNonce);

  @override
  String exceptionInfo() {
    return "genesisDid: $genesisDid, profileNonce: $profileNonce";
  }
}

class UnknownProfileException extends PolygonIdException {
  final BigInt profileNonce;

  UnknownProfileException(this.profileNonce);

  @override
  String exceptionInfo() {
    return "profileNonce: $profileNonce";
  }
}

class UnknownIdentityException extends PolygonIdException {
  final String did;

  UnknownIdentityException(this.did);

  @override
  String exceptionInfo() {
    return "did: $did";
  }
}

class InvalidPrivateKeyException extends PolygonIdException {
  final String privateKey;

  InvalidPrivateKeyException(this.privateKey);

  @override
  String exceptionInfo() {
    return "privateKey: $privateKey";
  }
}

class InvalidProfileException extends PolygonIdException {
  final BigInt profileNonce;

  InvalidProfileException(this.profileNonce) : super(null);

  String get error {
    if (profileNonce == BigInt.zero) {
      return "Genesis profile can't be modified";
    } else if (profileNonce.isNegative) {
      return "Profile nonce can't be negative";
    }

    return "Invalid profile";
  }

  @override
  String exceptionInfo() {
    return "profileNonce: $profileNonce, error: $error";
  }
}

class FetchIdentityStateException extends ErrorException {
  FetchIdentityStateException(error) : super(error);
}

class FetchStateRootsException extends ErrorException {
  FetchStateRootsException(error) : super(error);
}

class NonRevProofException extends ErrorException {
  NonRevProofException(error) : super(error);
}

class DidNotMatchCurrentEnvException extends PolygonIdException {
  final String did;
  final String rightDid;

  DidNotMatchCurrentEnvException(this.did, this.rightDid);

  @override
  String exceptionInfo() {
    return "profileNonce: $did, error: $rightDid";
  }
}
