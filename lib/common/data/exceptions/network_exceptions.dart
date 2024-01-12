import 'package:polygonid_flutter_sdk/common/utils/polygonid_exceptions.dart';

class NetworkException extends PolygonIdException {
  final dynamic error;

  NetworkException(this.error);

  @override
  String exceptionInfo() {
    return "error: $error";
  }
}

class UnknownApiException extends PolygonIdException {
  int httpCode;

  UnknownApiException(this.httpCode);

  @override
  String exceptionInfo() {
    return "httpCode: $httpCode";
  }
}

class ItemNotFoundException extends PolygonIdException {
  String message;

  ItemNotFoundException(this.message);

  @override
  String exceptionInfo() {
    return "message: $message";
  }
}

class InternalServerErrorException extends PolygonIdException {
  String message;

  InternalServerErrorException(this.message);

  @override
  String exceptionInfo() {
    return "message: $message";
  }
}

class ConflictErrorException extends PolygonIdException {
  String message;

  ConflictErrorException(this.message);

  @override
  String exceptionInfo() {
    return "message: $message";
  }
}

class BadRequestException extends PolygonIdException {
  String message;

  BadRequestException(this.message);

  @override
  String exceptionInfo() {
    return "message: $message";
  }
}
