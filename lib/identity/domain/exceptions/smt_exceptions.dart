import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';

class SMTNotFoundException extends PolygonIdException {
  final String storeName;

  SMTNotFoundException(this.storeName);

  @override
  String exceptionInfo() {
    return "profileNonce: $storeName";
  }
}

class SMTNodeKeyAlreadyExistsException extends PolygonIdException {}

class SMTEntryIndexAlreadyExistsException extends PolygonIdException {}

class SMTReachedMaxLevelException extends PolygonIdException {}

class SMTInvalidNodeFoundException extends PolygonIdException {}

class SMTKeyNotFoundException extends PolygonIdException {}
