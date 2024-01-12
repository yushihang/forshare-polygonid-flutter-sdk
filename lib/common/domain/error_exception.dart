import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';

class ErrorException extends PolygonIdException {
  final dynamic error;

  ErrorException(this.error);

  @override
  String exceptionInfo() {
    return "error: $error";
  }
}
