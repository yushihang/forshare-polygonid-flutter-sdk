import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';

class ErrorException extends PolygonIdException {
  final dynamic error;

  ErrorException(this.error);

  @override
  String exceptionInfo() {
    return "error: $error";
  }
}

class CircuitFileErrorException extends PolygonIdException {
  final String fileName;

  CircuitFileErrorException(this.fileName);

  @override
  String exceptionInfo() {
    return "fileName: $fileName";
  }
}
